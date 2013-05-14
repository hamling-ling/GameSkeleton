//
//  ClickableImageView.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 10/08/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EVT_CLICKABLE_IMG_CLICKED	@"ClickableIvClicked"

@interface ClickableImageView : UIImageView 
 {
	CGRect initPos;
	SEL OnClick;
	NSObject* target;
	NSString* imageFileName;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* imageFileName;

- (id)initWithImg:(NSString*)imgFile;
- (NSString*)getImageFileName;

@end
