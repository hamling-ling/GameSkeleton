//
//  SittingGlModel.m
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/03/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SittingGlModel.h"

@implementation SittingGlModel

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate
{
    GLKMatrix4 updated = GLKMatrix4Multiply(*_pBaseModelViewMat, _trans);
    memcpy(&_modelViewMatrix, &updated, sizeof(GLKMatrix4));
}

@end
