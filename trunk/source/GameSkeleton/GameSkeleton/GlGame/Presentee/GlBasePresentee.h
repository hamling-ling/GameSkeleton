//
//  GlBasePresentee.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "GlModel3.h"

@interface GlBasePresentee : NSObject
{
    GLKVector3 boxSize;
    GLKVector3 position;
    GLfloat angle;
}

@property (nonatomic, strong) NSArray* models;
@property (nonatomic, readonly) GLKVector3 boxSize;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign, readonly) GLKVector3 position;
@property (nonatomic, assign, readonly) GLfloat angle;

- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat;
- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat andInitPos:(GLKVector3) pos;
- (void)setPos:(GLKVector3)pos;
- (void)setRot:(GLfloat)rot;
- (void)resetInitPos:(GLKVector3)pos;
- (void)tearDownGL;
- (void)touchesBegan:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view;
- (void)touchesMoved:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view;
- (void)touchesEnded:(NSSet *)touches proj:(const GLKMatrix4*)pProj;
- (GLKVector3)to2x2:(const CGPoint*)cgp sizePtr:(const CGSize*)pSz;
- (GLKVector3)cgPtTo3D:(const CGPoint*)pPt
                 model:(const GlModel3*)model
                  proj:(const GLKMatrix4*)pProj
              viewSize:(const CGSize*)pSz
                result:(bool*)success;
- (BOOL)isBoxHit:(const CGPoint*)pPt
           model:(const GlModel3*)model
            proj:(const GLKMatrix4*)pProj
        viewSize:(const CGSize*)pSz;
- (CGPoint)getModelCenterOnScreen:(GlModel3*)model proj:(const GLKMatrix4*)pProj viewSize:(const CGSize*)pSz;
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate;

@end
