//
//  DemoBackground
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DemoBackground.h"
#import "CommonUtility.h"

@implementation DemoBackground

- (id)init {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of DemoBackground init failed"];

    // overrite
    _background.standAngle = 0.0;

    return self;
}

@end
