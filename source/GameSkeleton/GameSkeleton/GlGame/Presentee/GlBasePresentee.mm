//
//  GlBasePresentee.mm
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlBasePresentee.h"
#import "CommonUtility.h"
#import "DiagnosticTool.h"

#define HITMARGIN 12.0
#define IS_NEIGHBOR(a,b)  (((b-HITMARGIN) <= (a)) && ((a) <= (b+HITMARGIN)))

@interface GlBasePresentee() {
    
}

@end


@implementation GlBasePresentee

@synthesize models;
@synthesize boxSize;
@synthesize isVisible;
@synthesize position;
@synthesize angle;

- (id)init {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"GlBasePresentee init failed"];

    isVisible = YES;

    return self;
}

- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat {
    for (GlModel3* model in models) {
        [model setupGL];
    }
}

- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat andInitPos:(GLKVector3) pos {
    [self setupGLWithBaseModelViewMatPtr:pMat];
    
    for (GlModel3* model in models) {
        [model initPos:pos andBaseModelViewMat:pMat];
    }
}

- (void)tearDownGL {
    for (id item in models) {
        GlModel3* model = (GlModel3*)item;
        [model tearDownGL];
    }
    self.models = nil;
}

- (void)setPos:(GLKVector3)pos {

    position = pos;

    for (GlModel3* m in self.models)
        [m setPos:pos];
}

- (void)resetInitPos:(GLKVector3)pos {

    position = pos;

    for (GlModel3* m in self.models)
        [m resetInitPos:pos];
}

- (void)setRot:(GLfloat)rot {
    for (GlModel3* m in self.models)
        [m setRot:rot update:NO];
}

- (void)touchesBegan:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view {
    // base class does nothing
}

- (void)touchesMoved:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view {
    // base class does nothing
}

- (void)touchesEnded:(NSSet *)touches proj:(const GLKMatrix4*)pProj {
    // base class does nothing
}

// convert viewport to cocoa cgpoint
- (CGPoint)toDip:(const GLKVector3*)pV3 viewportPtr:(const GLint*)pViewport sizePtr:(const CGSize*)pSz {
    CGPoint cvted = CGPointMake(pV3->x/pViewport[2] * pSz->width,
                                pV3->y/pViewport[3] * pSz->height);
    cvted.y = pSz->height - cvted.y;

    return cvted;
}

// convert cocoa cgpoint to viewport coord
- (GLKVector2)toPix:(const CGPoint*)cgp viewportPtr:(const GLint*)pViewport sizePtr:(const CGSize*)pSz {
    GLKVector2 glc;
    
    float y = pSz->height - cgp->y;
    
    glc.x = cgp->x / pSz->width * pViewport[2];
    glc.y = y / pSz->height * pViewport[3];
    
    return glc;
}

- (GLKVector3)to2x2:(const CGPoint*)cgp sizePtr:(const CGSize*)pSz {
    GLKVector3 vec;
    vec.x = cgp->x / pSz->width * 2.0 - 1.0;
    vec.y = cgp->y / pSz->height * 2.0 - 1.0;
    vec.z = 0.0;
    vec.y *= -1.0;
    
    return vec;
}

- (BOOL)isCenterHit:(const CGPoint*)pPt model:(const GlModel3*)model proj:(const GLKMatrix4*)pProj viewSize:(const CGSize*)pSz {
    
    const GLKMatrix4* pModeViewMat = [model modelViewMatrixPtr];
    GLint viewPort[4];
    glGetIntegerv(GL_VIEWPORT, viewPort);
    
    GLKVector3 p = GLKMathProject(ZERO_VECTOR3, *pModeViewMat, *pProj, viewPort);
    CGPoint cgp = [self toDip:&p viewportPtr:viewPort sizePtr:pSz];
    
    BOOL isHit = IS_NEIGHBOR(cgp.x, pPt->x) && IS_NEIGHBOR(cgp.y, pPt->y);
    return isHit;
}

- (GLKVector3)cgPtTo3D:(const CGPoint*)pPt
                 model:(const GlModel3*)model
                  proj:(const GLKMatrix4*)pProj
              viewSize:(const CGSize*)pSz
                result:(bool*)success {
    
    *success = NO;
    
    // get data and viewport size
    const GLKMatrix4* pModelViewMat = [model modelViewMatrixPtr];
    GLint viewPort[4];
    glGetIntegerv(GL_VIEWPORT, viewPort);
    
    // get screen coord for touch pos
    GLKVector2 glTchPt = [self toPix:pPt viewportPtr:viewPort sizePtr:pSz];
    
    GLKVector3 a = GLKMathUnproject(GLKVector3Make(glTchPt.x, glTchPt.y, 0.0),
                                    *pModelViewMat,
                                    *pProj,
                                    viewPort,
                                    success);
    
    if(!success) {
        LOG(@"1st GLKMathUnproject failed");
        return ZERO_VECTOR3;
    }
    
    GLKVector3 b = GLKMathUnproject(GLKVector3Make(glTchPt.x, glTchPt.y, 1.0),
                                    *pModelViewMat,
                                    *pProj,
                                    viewPort,
                                    success);
    
    if(!success) {
        LOG(@"2nd GLKMathUnproject failed");
        return ZERO_VECTOR3;
    }

    GLfloat Y = -a.y/(b.y-a.y);
    GLKVector3 pt = GLKVector3Make(
                                   Y*(b.x-a.x)+a.x,
                                   0.0,
                                   Y*(b.z-a.z)+a.z);

    *success = YES;
    
    return pt;
}

- (BOOL)isBoxHit:(const CGPoint*)pPt model:(GlModel3*)model proj:(const GLKMatrix4*)pProj viewSize:(const CGSize*)pSz {
    
    // get data and viewport size
    const GLKMatrix4* pModelViewMat = [model modelViewMatrixPtr];
    GLint viewPort[4];
    glGetIntegerv(GL_VIEWPORT, viewPort);

    // get screen screen coord for touch pos
    GLKVector2 glTchPt = [self toPix:pPt viewportPtr:viewPort sizePtr:pSz];
    
    // get box and convert to screen coord
    GLKVector2 glScrBox[4];
    {
        const GLKVector3 *pBox = [model boxPtr];
        for (int i = 0; i < 4; i++) {
            GLKVector3 p = GLKMathProject(*(pBox++), *pModelViewMat, *pProj, viewPort);
            glScrBox[i] = GLKVector2Make(p.x, p.y);
        }
    }

    BOOL isHit = [self isInsideBox:&glTchPt Box:glScrBox];
    return isHit;
}

- (BOOL)isInsideBox:(const GLKVector2*)p Box:(const GLKVector2*)box {
    BOOL signs[4] = {NO};
    
    // get dot product of ab and ap and take sign, ...
    for (int i = 0; i < 4; i++) {
        GLKVector2 ab = GLKVector2Subtract(box[(i+1)%4], box[i]);
        GLKVector2 ap = GLKVector2Subtract(*p, box[i]);
        float ab_ap = ab.x * ap.y - ap.x * ab.y;
        signs[i] = (ab_ap >= 0);
    }
    
    int numYes = 0;
    for (int i = 0; i < 4; i++) {
        if (signs[i])
            numYes++;
    }
    
    return (numYes == 0 || numYes == 4);
}

- (GLKVector3)glkProjectPos:(const GLKVector3*)objPos
                        pMV:(const GLKMatrix4*)pModelView
                       pPrj:(const GLKMatrix4*)pProj
                         pV:(const GLint*)pVp
                         pR:(GLfloat*)ratio {
    
    GLKVector3 projected;
    projected = GLKMathProject(*objPos, *pModelView, *pProj, (int*)pVp);
    
    return projected;
}

- (CGPoint)getModelCenterOnScreen:(GlModel3*)model proj:(const GLKMatrix4*)pProj viewSize:(const CGSize*)pSz {
    
    // get data and viewport size
    const GLKMatrix4* pModelViewMat = [model modelViewMatrixPtr];
    GLint viewPort[4];
    glGetIntegerv(GL_VIEWPORT, viewPort);
    

    GLKVector3 p = GLKMathProject(ZERO_VECTOR3, *pModelViewMat, *pProj, viewPort);
    
    CGPoint cgCtr = [self toDip:&p viewportPtr:viewPort sizePtr:pSz];
    return cgCtr;
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate {
    if(!models)
        return;
    
    for (GlModel3* m in models) {
        [m updateWithTimeSinceLastUpdate:timeSinceLastUpdate];
    }
}

@end
