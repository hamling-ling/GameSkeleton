//
//  Player.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "CommonUtility.h"
#import "StandingAlphaGlModel.h"
#import "Vertex_Pyr.h"

#define TEXTURE_NAME_PYR    @"pyramid"

const GLKVector4 EXTRA_COLOR_ACTIVE = {1.0, 1.0, 1.0, 0.0};
const GLKVector4 EXTRA_COLOR_INACTIVE = {0.0, 0.0, 0.0, 0.0};

@interface Player() {
    StandingAlphaGlModel *_model;
}
@end

@implementation Player

- (id)init {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of Player init failed"];

    _model = [[StandingAlphaGlModel alloc]
                 initWithVertex:PyrVertexData ofSize:sizeof(PyrVertexData) texPng:TEXTURE_NAME_PYR];

    self.models = [NSArray arrayWithObjects:_model, nil];

    return self;
}

- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat {
    [super setupGLWithBaseModelViewMatPtr:pMat];
    
    [_model initPos:ZERO_VECTOR3 andBaseModelViewMat:pMat];
}

- (void)setPlayerPos:(GLKVector3)pos Ang:(GLfloat)ang M:(GLfloat)magnitude {
    position = pos;
    angle = ang;

    [_model setPos:position];
    [_model setRot:ang update:NO];
    [_model setFrameRotation:ang];
}

- (void)touchesBegan:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view {
    
    CGSize viewSize = view.bounds.size;
    for (UITouch* touch in touches) {
        
        CGPoint pt = [touch locationInView:view];
        
        if ([self isBoxHit:&pt model:_model proj:pProj viewSize:&viewSize]) {
            _model.extraColor = EXTRA_COLOR_ACTIVE;
            _model.ambientStrength = AMBIENT_ACTIVE;
            
            continue;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view {
}

- (void)touchesEnded:(NSSet *)touches proj:(const GLKMatrix4*)pProj{
    
    _model.extraColor = EXTRA_COLOR_INACTIVE;
    _model.ambientStrength = AMBIENT_INACTIVE;
}


- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate {
    
    if(!_model)
        return;
    
    [_model updateWithTimeSinceLastUpdate:timeSinceLastUpdate];
}

@end
