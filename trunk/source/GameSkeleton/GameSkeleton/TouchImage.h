//
//  TouchImage.h
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/07/16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClickableImageView.h"

#define CGPointSubraction(a,b)	(CGPointMake(a.x - b.x, a.y - b.y))
#define CGPointAddition(a,b)	(CGPointMake(a.x + b.x, a.y + b.y))

typedef enum TOUCHIMG_STATE {
	TOUCHIMG_STATE_UNSET,
	TOUCHIMG_STATE_SET,
	TOUCHIMG_STATE_TOUCHED
} TouchImageState;

@interface TouchImage : ClickableImageView {
@private
    TouchImageState state;
}

@property (nonatomic, readonly) TouchImageState state;

- (id)initWithImg:(NSString*)imgFile;
- (void)setPos:(CGPoint)pos;
- (void)touched;
- (void)inActivate;

@end
