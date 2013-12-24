//
//  TimeKeeper.h
//  FingerSki
//
//  Created by Nobuhiro Kuroiwa on 12/05/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlBasePresentee.h"

@interface TimeKeeper : GlBasePresentee

@property (nonatomic, readonly, assign) NSTimeInterval time;

- (id)init;
- (NSTimeInterval)start;
- (NSTimeInterval)stop;
- (NSTimeInterval)pause;

@end
