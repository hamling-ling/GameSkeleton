//
//  Pyramid.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlBasePresentee.h"

#define EVT_PLAYER_FIRST_TOUCHED	@"PLayerFirstTouchedEvent"
#define EVT_PLAYER_READY_TO_GO     @"PlayerReadyToGoEvent"

@interface Player : GlBasePresentee

- (void)setPlayerPos:(GLKVector3)pos Ang:(GLfloat)ang M:(GLfloat)magnitude;

@end
