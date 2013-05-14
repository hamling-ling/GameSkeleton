//
//  DemoBackground
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DemoBackground.h"
#import "CommonUtility.h"
#import "Vertex_Bg.h"

#define TEXTURE_NAME_MTN    @"alps"

@implementation DemoBackground

- (id)init {
    self = [super initWithVertex:BgVertexData ofSize:sizeof(BgVertexData) andTexName:TEXTURE_NAME_MTN];
    [CommonUtility nilToFail:self reason:@"super of DemoBackground init failed"];

    // overrite
    _background.standAngle = 0.0;

    return self;
}

@end
