//
//  GlModel3.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DiagnosticTool.h"
#import "GlModel3.h"
#import "CommonUtility.h"
#import "GLKit/GLKMath.h"
#include "math.h"

const GLKVector3 ZERO_VECTOR3 = {0.0,0.0,0.0};
const GLKVector4 ZERO_VECTOR4 = {0.0,0.0,0.0,0.0};
const GLKVector3 AXIS_X = {1.0, 0.0, 0.0};
const GLKVector3 AXIS_Y = {0.0, 1.0, 0.0};
const GLKVector3 AXIS_Z = {0.0, 0.0, 1.0};
const GLKVector3 AXIS_mX = {-1.0, 0.0, 0.0};
const GLKVector3 AXIS_mY = {0.0, -1.0, 0.0};
const GLKVector3 AXIS_mZ = {0.0, 0.0, -1.0};

@implementation GlModel3

@synthesize extraColor;
@synthesize alpha;
@synthesize rotationCenter;
@synthesize rotation;
@synthesize frameRotation;
@synthesize position;
@synthesize boxSize;
@synthesize textureName;
@synthesize isAlphaEnabled;

- (id) initWithVertex:(const vertexData*)data ofSize:(GLsizei)size texPng:(NSString*)pngName
{
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of GlModel3 init failed"];

    _data = data;
    _dataSize = size;
    _texFileName = pngName;
    extraColor = ZERO_VECTOR4;
    alpha = 1.0;
    rotation = 0.0;
    position = ZERO_VECTOR3;
    rotationCenter = ZERO_VECTOR3;
    
    [self boxXZ:_box data:data ofSize:size];
    
    return self;
}

- (void)boxXZ:(GLKVector3*)dest data:(const vertexData*)data ofSize:(GLsizei)size {
    
    // bounding box on x-z plane
    GLfloat minmax_x[2] = {data[0].vertex.x};
    GLfloat minmax_z[2] = {data[0].vertex.z};
    for (int i = 1; i < size/sizeof(vertexData); i++) {
        minmax_x[0] = MIN(minmax_x[0], data[i].vertex.x);
        minmax_x[1] = MAX(minmax_x[1], data[i].vertex.x);
        minmax_z[0] = MIN(minmax_z[0], data[i].vertex.z);
        minmax_z[1] = MAX(minmax_z[1], data[i].vertex.z);
    }
    // order continuously
    GLKVector3 box[4] = {
        GLKVector3Make(minmax_x[0], 0.0, minmax_z[0]),// min,min
        GLKVector3Make(minmax_x[0], 0.0, minmax_z[1]),// min,max
        GLKVector3Make(minmax_x[1], 0.0, minmax_z[1]),// max,max
        GLKVector3Make(minmax_x[1], 0.0, minmax_z[0]),// max,min
    };
    
    memcpy(_box, box, sizeof(_box));
    
    boxSize = GLKVector3Make(minmax_x[1]-minmax_x[0], 0.0, minmax_z[1]-minmax_z[0]);
}

- (void)initPos:(GLKVector3)pos andBaseModelViewMat:(GLKMatrix4*)pBMVM
{
    textureName = [self loadTextures];
    
    _pBaseModelViewMat = pBMVM;
    _trans = GLKMatrix4MakeTranslation(pos.x, pos.y, pos.z);
    _initTrans = _trans;
    position = pos;
}

- (void)resetInitPos:(GLKVector3)pos
{
    _trans = GLKMatrix4MakeTranslation(pos.x, pos.y, pos.z);
    _initTrans = _trans;
    position = pos;
}

- (void)setPos:(GLKVector3)pos
{
    GLKVector3 curPos = GLKMatrix4MultiplyAndProjectVector3(_initTrans, ZERO_VECTOR3);
    GLKVector3 nextPos = GLKVector3Add(pos, curPos);
    _trans = GLKMatrix4MakeTranslation(nextPos.x, nextPos.y, nextPos.z);
    position = nextPos;
}

- (void)setRot:(GLfloat)rot update:(BOOL)update
{
    rotation = rot;
}

- (void)setFrameRotation:(GLfloat)rot {
    frameRotation = rot;
}

- (bool)boxContains:(GLKVector3)pos {
    float x_min = _box[0].x + position.x;
    float x_max = _box[2].x + position.x;
    float z_min = _box[0].z + position.z;
    float z_max = _box[2].z + position.z;
    
    if (x_min <= pos.x && pos.x < x_max) {
        if (z_min <= pos.z && pos.z < z_max) {
            return true;
        }
    }
    return false;
}

- (GLuint)vertexArray
{
    return _vertexArray;
}

- (const GLKMatrix4*)modelViewMatrixPtr
{
    return &_modelViewMatrix;
}

- (const GLKVector3*)boxPtr
{
    return _box;
}
- (GLsizei)triangleNum
{
    return _dataSize / sizeof(vertexData);
}

- (void)setupGL
{
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _dataSize, _data, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(vertexData), BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(vertexData), BUFFER_OFFSET(12));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(vertexData), BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate
{

}

- (GLuint)loadTextures
{
    NSError* error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                        forKey:GLKTextureLoaderGenerateMipmaps];
    NSString *bundlepath = [[NSBundle mainBundle] pathForResource:_texFileName ofType:@"png"];
    
    _texture = [GLKTextureLoader textureWithContentsOfFile:bundlepath options:options error:&error];

    [self logError:error];
    
    return _texture.name;
}

- (GLuint)setupTexture:(NSString*)filename {
    CGImageRef spriteImage = [UIImage imageNamed:filename].CGImage;
    if(!spriteImage)
    {
        // report error
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte* spriteData = (GLubyte*)calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0,0,width,height), spriteImage);
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

- (void)logError:(NSError *)error
{
    if(!error)
        return;
    
    NSString* domain = [error domain];
    LOG(@"Error loading texture: %@. Domain: %@", [error localizedDescription], domain);
    NSDictionary* userInfo = [error userInfo];
    if(domain == GLKTextureLoaderErrorDomain)
    {
        if(nil != [userInfo objectForKey:GLKTextureLoaderErrorKey]) {
            LOG(@"%@", [userInfo objectForKey:GLKTextureLoaderErrorKey]);
        }
        
        if(nil != [userInfo objectForKey:GLKTextureLoaderGLErrorKey]) {
            LOG(@"%@", [userInfo objectForKey:GLKTextureLoaderGLErrorKey]);
        }
    }
}

@end
