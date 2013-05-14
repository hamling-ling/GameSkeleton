//
//  Pyramid.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlBasePresentee.h"

@interface Player : GlBasePresentee

- (void)setPlayerPos:(GLKVector3)pos Ang:(GLfloat)ang M:(GLfloat)magnitude;

@end
