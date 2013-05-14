//
//  StandingGlModel.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StandingGlModel.h"

@implementation StandingGlModel

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate
{
    GLKMatrix4 rotSlope = GLKMatrix4RotateX(_trans, -M_PI/12.0);
    GLKMatrix4 modelViewMatrix = GLKMatrix4RotateY(rotSlope, rotation);

    GLKMatrix4 updated = GLKMatrix4Multiply(*_pBaseModelViewMat, modelViewMatrix);
    memcpy(&_modelViewMatrix, &updated, sizeof(GLKMatrix4));
}

@end
