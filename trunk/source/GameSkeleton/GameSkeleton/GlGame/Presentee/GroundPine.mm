//
//  GroundPine.mm
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroundPine.h"
#import "CommonUtility.h"
#import "Vertex_Grd.h"

#define TEXTURE_NAME_GRDPINE    @"ground_pine"

@interface GroundPine() {
}

@end


@implementation GroundPine

- (id)init {
    self = [super initWithVertex:GroundVertexData ofSize:sizeof(GroundVertexData) andTexName:TEXTURE_NAME_GRDPINE];
    [CommonUtility nilToFail:self reason:@"super of GroundPine init failed"];

    return self;
}

@end
