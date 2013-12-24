//
//  ClickableImageView.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 10/08/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClickableImageView.h"
#import "DiagnosticTool.h"

@implementation ClickableImageView

@synthesize name;
@synthesize imageFileName;

- (id)initWithImg:(NSString*)imgFile {
	
	if(!imgFile) {
		return nil;
	}
	
	OnClick = nil;
	target = nil;
	
	NSString* fixedFileName = [self fixImgFileName:imgFile];
	
	self = [super initWithImage:[UIImage imageNamed:fixedFileName]];
	self.imageFileName = fixedFileName;
	
	[self setUserInteractionEnabled:YES];
	
	return self;
}

- (NSString*)fixImgFileName:(NSString*)fileName {

	NSString* fixedFileName = fileName;
	NSString* extension = [fileName pathExtension];
	
	if([extension isEqualToString:@""]) {
		fixedFileName = [fileName stringByAppendingFormat:@".png"];
	}
	
	return fixedFileName;
}

- (NSString*)getImageFileName {
	return imageFileName;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
    
	NSNotificationQueue* q = [NSNotificationQueue defaultQueue];
	NSNotification* note = [NSNotification notificationWithName:EVT_CLICKABLE_IMG_CLICKED object:self];
	[q enqueueNotification:note postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:nil];
}

@end
