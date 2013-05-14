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

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate {
    
    if(!_model)
        return;
    
    [_model updateWithTimeSinceLastUpdate:timeSinceLastUpdate];
}

@end
