//
//  MountainGlModel.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackgroundGlModel.h"
#import "CommonUtility.h"
#import "Vertex_Bg.h"

#define SCALE_FACTOR_XZ  40.0
#define SCALE_FACTOR_Y   40.0

@implementation BackgroundGlModel

@synthesize standAngle;

- (id) initWithVertex:(const vertexData*)data ofSize:(GLsizei)size texPng:(NSString*)pngName
{
    self = [super initWithVertex:data ofSize:size texPng:pngName];
    [CommonUtility nilToFail:self reason:@"super of BackgroundGlModel init failed"];

    standAngle = 0.0;

    return self;
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate
{
    GLKMatrix4 scaled = GLKMatrix4Scale(_trans, SCALE_FACTOR_XZ, SCALE_FACTOR_Y, SCALE_FACTOR_XZ); 
    GLKMatrix4 rotSlope = GLKMatrix4RotateX(scaled, standAngle);
    GLKMatrix4 modelViewMatrix = GLKMatrix4RotateY(rotSlope, rotation);
    
    GLKMatrix4 updated = GLKMatrix4Multiply(*_pBaseModelViewMat, modelViewMatrix);
    memcpy(&_modelViewMatrix, &updated, sizeof(GLKMatrix4));
}

@end
