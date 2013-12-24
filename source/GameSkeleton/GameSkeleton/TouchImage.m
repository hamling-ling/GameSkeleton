//
//  TouchImage.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/07/16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TouchImage.h"
#import "CommonUtility.h"

@interface TouchImage () {
    CGPoint pointingPos;
    BOOL isActive;
}
@end

@implementation TouchImage

@synthesize state;

- (id)initWithImg:(NSString*)imgFile {
    self = [super initWithImg:imgFile];
    [CommonUtility nilToFail:self reason:@"super of TouchImage init failed"];

    self.alpha = 0.0;
    isActive = YES;

    return self;
}

- (void)setPos:(CGPoint)pos {

    if(state == TOUCH_STATE_UNSET) {
        self.hidden = NO;
        state = TOUCH_STATE_SET;
    }
    else {
        return;
    }
    
    CGRect rect = [self frame];
    CGPoint newPos = CGPointMake(pos.x - rect.size.width/2.0,
                                 pos.y - rect.size.height);
    rect.origin = newPos;
    [self setFrame:rect];
    pointingPos = pos;
    
    self.transform = CGAffineTransformMakeTranslation(0.0, -100.0);
    [self showAnime];
}

- (void)touched {
    state = TOUCH_STATE_TOUCHED;
    [self inActivate];
}

- (void)showAnime {

    [UIView beginAnimations:@"Show" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didShowAnime:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)didShowAnime:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    if (!isActive)
        return;

    [UIView beginAnimations:@"Fall" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didFallAnime:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    [UIView commitAnimations];
}

- (void)didFallAnime:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    if (!isActive)
        return;

    [UIView beginAnimations:@"Jump" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didShowAnime:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.transform = CGAffineTransformMakeTranslation(0.0, -50.0);
    [UIView commitAnimations];
}

- (void)inActivate {
    isActive = NO;
    [self.layer removeAllAnimations];
    self.hidden = YES;
}

@end
