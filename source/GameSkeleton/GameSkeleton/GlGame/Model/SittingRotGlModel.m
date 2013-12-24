//
//  SittingRotGlModel.m
//  OpenGlSample
//
//  Created by Nobuhiro Kuroiwa on 12/03/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SittingRotGlModel.h"

@implementation SittingRotGlModel

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4RotateY(_trans, rotation);
    
    GLKMatrix4 updated = GLKMatrix4Multiply(*_pBaseModelViewMat, modelViewMatrix);
    memcpy(&_modelViewMatrix, &updated, sizeof(GLKMatrix4));
}

@end
