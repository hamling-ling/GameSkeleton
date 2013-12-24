//
//  LivingRoom.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LivingRoom.h"
#import "CommonUtility.h"
#import "Vertex_Bg.h"

#define TEXTURE_NAME_LRM    @"room"

@interface LivingRoom() {
}
@end

@implementation LivingRoom

- (id)init {
    self = [super initWithVertex:BgVertexData ofSize:sizeof(BgVertexData) andTexName:TEXTURE_NAME_LRM];
    [CommonUtility nilToFail:self reason:@"super of LivingRoom init failed"];
    
    return self;
}

@end
