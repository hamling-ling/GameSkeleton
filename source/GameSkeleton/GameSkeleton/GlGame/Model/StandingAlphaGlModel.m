//
//  StandingAlphaGlModel.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StandingAlphaGlModel.h"
#import "CommonUtility.h"

@implementation StandingAlphaGlModel

- (id) initWithVertex:(const vertexData*)data ofSize:(GLsizei)size texPng:(NSString*)pngName
{
    self = [super initWithVertex:data ofSize:size texPng:pngName];
    [CommonUtility nilToFail:self reason:@"super of StandingAlphaGlModel init failed"];
    
    isAlphaEnabled = YES;
    
    return self;
}

@end
