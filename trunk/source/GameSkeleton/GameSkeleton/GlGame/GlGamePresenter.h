//
//  GlGamePresenter.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlBasePresentee.h"
#import "GameResult.h"

extern const NSString* GlGameLock;

#define EVT_PLAY_START           @"PlayStartedEvent"
#define EVT_PLAY_GOAL            @"PLayGoaledEvent"
#define EVT_PLAY_POINT_EARNED    @"PlayPointEarnedEvent"

@interface GlGamePresenter : NSObject

@property (nonatomic, readonly, strong) NSArray* presentees;
@property (nonatomic, readonly, assign) NSTimeInterval time;
@property (nonatomic, readonly, assign) int score;
@property (nonatomic, readonly, assign) int bonus;

- (id)init;
- (void)setupGLForStage:(int)stage;
- (void)tearDownGL;
- (void)touchesBegan:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view;
- (void)touchesMoved:(NSSet *)touches proj:(const GLKMatrix4*)pProj view:(UIView*)view;
- (void)touchesEnded:(NSSet *)touches proj:(const GLKMatrix4*)pProj;
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLastUpdate;
- (GameResult*)getResult;

@end
