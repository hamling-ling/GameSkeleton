//
//  DemoPlayer.mm
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DemoPlayer.h"
#import "CommonUtility.h"


@interface DemoPlayer() {
}

@end


@implementation DemoPlayer

- (id) init {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of DemoPlayer init failed"];

    return self;
}

- (void)setPlayerPos:(GLKVector3)pos Ang:(GLfloat)ang M:(GLfloat)magnitude {   
    position = pos;
    angle += 0.001;
    [super setPlayerPos:pos Ang:angle M:magnitude];
}

@end
