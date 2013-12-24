//
//  TimeKeeper.m
//  FingerSki
//
//  Created by Nobuhiro Kuroiwa on 12/05/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TimeKeeper.h"
#import "CommonUtility.h"

static const NSTimeInterval INTERVAL = 0.01f;

@interface TimeKeeper()
{
    NSTimer *_timer;
}
@end

@implementation TimeKeeper

@synthesize time;

- (id)init {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of TimeKeeper init failed"];

    _timer = nil;
    
    return self;
}

- (NSTimeInterval)start {
    
    [self nilTimer];
    
    // don't time=0 for restarting from paused state
    _timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(timerEllapsed:) userInfo:nil repeats:YES];
    return time;
}

- (NSTimeInterval)stop {
    
    NSTimeInterval retTime = time;
    [self nilTimer];
    time = 0;
    
    return retTime;
}

- (NSTimeInterval)pause {
    
    if(!_timer)
        return time;
    
    [_timer invalidate];
    return time;
}

- (void)timerEllapsed:(NSTimer*)timer {
    time = time + INTERVAL;
}

- (void)nilTimer {
    if(_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
