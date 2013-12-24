//
//  GlModel3.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#include "GlTypes.h"

#define M_PI_8 0.392699082

extern const GLKVector3 ZERO_VECTOR3;
extern const GLKVector4 ZERO_VECTOR4;
extern const GLKVector3 AXIS_X;
extern const GLKVector3 AXIS_Y;
extern const GLKVector3 AXIS_Z;
extern const GLKVector3 AXIS_mX;
extern const GLKVector3 AXIS_mY;
extern const GLKVector3 AXIS_mZ;

@interface GlModel3 : NSObject {

    NSString* _texFileName;
    const vertexData* _data;
    GLsizei _dataSize;
    GLKVector3 _box[4];
    GLKVector3 boxSize;
    
    GLKMatrix4 _modelViewMatrix;
    GLKMatrix4* _pBaseModelViewMat;
    GLKMatrix4 _trans;
    GLKMatrix4 _initTrans;
    
    GLfloat rotation;
    GLKVector3 rotationCenter;
    GLfloat frameRotation;
    GLKVector3 position;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLKTextureInfo* _texture;
    GLuint textureName;
    
    GLboolean isAlphaEnabled;
}

@property (nonatomic, readwrite) GLKVector4 extraColor;
@property (nonatomic, readwrite) GLfloat alpha;
@property (nonatomic, readonly) GLfloat rotation;
@property (nonatomic, readonly) GLKVector3 rotationCenter;
@property (nonatomic, readonly) GLfloat frameRotation;
@property (nonatomic, readonly) GLKVector3 position;
@property (nonatomic, readonly) GLKVector3 boxSize;
@property (nonatomic, readonly) GLuint textureName;
@property (nonatomic, readonly) GLboolean isAlphaEnabled;

- (id) initWithVertex:(const vertexData*)data ofSize:(GLsizei)size texPng:(NSString*)pngName;
- (void)initPos:(GLKVector3)pos andBaseModelViewMat:(GLKMatrix4*)pBMVM;
- (void)resetInitPos:(GLKVector3)pos;
- (void)setPos:(GLKVector3)pos;
- (void)setRot:(GLfloat)rot update:(BOOL)update;
- (void)setFrameRotation:(GLfloat)rot;
- (bool)boxContains:(GLKVector3)pos;
- (GLuint)vertexArray;
- (const GLKMatrix4*)modelViewMatrixPtr;
- (const GLKVector3*)boxPtr;
- (GLsizei)triangleNum;
- (void)setupGL;
- (void)tearDownGL;
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate;
- (GLuint)loadTextures;
- (void)logError:(NSError *)error;

@end
