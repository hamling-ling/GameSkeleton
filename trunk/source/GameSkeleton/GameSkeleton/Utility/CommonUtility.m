//
//  CommonUtility.m
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwaon 12/03/21.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonUtility.h"

#define BUNDLE_DISP_NAME    @"CFBundleDisplayName"
#define BUNDLE_NAME         @"CFBundleName"
#define BUNDLE_VERSION      @"CFBundleVersion"
#define COPYRIGHT_HOLDER    @"Nobuhiro Kuroiwa"

@implementation CommonUtility

static UIDeviceOrientation m_previousOrientation;

+ (void)nilToFail:(id)ptr reason:(NSString*)msg {
    if (ptr == nil) {
        [[NSException exceptionWithName:@"InitFailure"
                                 reason:msg
                               userInfo:nil]
         raise];
    }
}

+ (void)setOrientation:(UIDeviceOrientation) ori {
	if (ori == m_previousOrientation) {
		return;
	}
	if ([self isFaceUpDown:ori]) {
		return;
	}
	if (UIDeviceOrientationUnknown) {
		return;
	}
	m_previousOrientation = ori;
}
+ (int)getToolBarHeight:(UIToolbar*)tb {
	CGRect toolBarRect = [tb frame];
	return toolBarRect.size.height;
}

+ (int)screenHeight {
	int h = 0;

	UIDeviceOrientation ori = [self getMeaningfulOrientation];
	if(ori == UIDeviceOrientationLandscapeLeft ||
	   ori == UIDeviceOrientationLandscapeRight) {
		h = [[UIScreen mainScreen] bounds].size.width;
	}
	else {
		h = [[UIScreen mainScreen] bounds].size.height;
	}

	return h;
}

+ (int)screenWidth {
	int w = 0;
	
	UIDeviceOrientation ori = [self getMeaningfulOrientation];
	if(ori == UIDeviceOrientationLandscapeLeft ||
	   ori == UIDeviceOrientationLandscapeRight) {
		w = [[UIScreen mainScreen] bounds].size.height;
	}
	else {
		w = [[UIScreen mainScreen] bounds].size.width;
	}
	
	return w;
}

+ (int)clientHeight {
	int h = 0;
	
	UIDeviceOrientation ori = [self getMeaningfulOrientation];
	if(ori == UIDeviceOrientationLandscapeLeft ||
	   ori == UIDeviceOrientationLandscapeRight) {
		h = [[UIScreen mainScreen] bounds].size.width
			- STATUSBAR_H;
	}
	else {
		h = [[UIScreen mainScreen] bounds].size.height
			- STATUSBAR_H;
	}
	
	return h;
}

+ (BOOL)isLandscape {
	UIDeviceOrientation ori = [self getMeaningfulOrientation];
	
	if(ori == UIDeviceOrientationLandscapeLeft ||
	   ori == UIDeviceOrientationLandscapeRight) {
		return YES;
	}
	return NO;
}

+ (UIDeviceOrientation)getMeaningfulOrientation {
	UIDeviceOrientation ori = [[UIDevice currentDevice] orientation];
	if([self isFaceUpDown:ori] || ori == UIDeviceOrientationUnknown) {
		if([self isFaceUpDown:m_previousOrientation] || m_previousOrientation == UIDeviceOrientationUnknown) {
			return DEFAULT_ORIENTATION;
		}
		return m_previousOrientation;
	}

	return ori;
}

+ (BOOL)isFaceUpDown:(UIDeviceOrientation)ori {
	return (ori == UIDeviceOrientationFaceUp || ori == UIDeviceOrientationFaceUp);
}

+ (void)alertInvalidInput:(NSString*) msg {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"error"
						  message:msg
						  delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
}

+ (BOOL)mutArray:(NSMutableArray*)arr containsInt:(int)num {
	for (NSNumber* nsnum in arr) {
		if ([nsnum intValue] == num) {
			return YES;
		}
	}
	
	return NO;
}

+ (NSDate*)createEndTime:(int)timeFrom withLength:(int)len {
	double endTime = timeFrom + len;
	return [CommonUtility createTime:endTime];
}

+ (NSDate*)createTime:(double)timeInDouble {
	NSDate* theDate = [NSDate dateWithTimeIntervalSince1970:timeInDouble];
	NSTimeInterval offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	NSTimeInterval gmtTimeInterval = [theDate timeIntervalSinceReferenceDate] - offset;
	NSDate* retTime = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
	
	return retTime;
}

+ (void)applyPaddedFooter:(UITableView*)tableView {
	UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0,0,1,80)];
	footer.backgroundColor = [UIColor clearColor];
	tableView.tableFooterView = footer;
}

+ (CGPoint)getRelPos:(CGPoint*)p forView:(UIView*)v {
	return [CommonUtility getRelPosX:p->x Y:p->y forView:v];
}

+ (CGPoint)getRelPosX:(float)x Y:(float)y forView:(UIView*)v {
	CGRect f = v.frame;
	return CGPointMake(x / f.size.width, y / f.size.height);
}

+ (void)addEvtHandlerFor:(id)observer Name:(NSString*)name Sel:(SEL)sel {
	[[NSNotificationCenter defaultCenter] removeObserver:observer
													name:name 
												  object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:observer
											 selector:sel
												 name:name 
											   object:nil];

}

+ (void)rmvEvtHandlerFor:(id)observer Name:(NSString*)name {
	[[NSNotificationCenter defaultCenter] removeObserver:observer
													name:name 
												  object:nil];
}

+ (void)asyncNotifyEvt:(NSString*)name obj:(id)theObj {
	NSNotificationQueue* q = [NSNotificationQueue defaultQueue];
	NSNotification* note = [NSNotification notificationWithName:name object:theObj];
	[q enqueueNotification:note postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
}

+ (void)asyncNotifyEvt:(NSString*)name sdr:(id)theSdr obj:(id)theObj {
	[CommonUtility asyncNotifyEvt:name obj:[NSArray arrayWithObjects:theSdr, theObj, nil]];
}

+ (BOOL)shouldAutorot2IfOri:(UIInterfaceOrientation)ori {
    // Return YES for supported orientations.
    return (ori == UIInterfaceOrientationLandscapeLeft);
}

+ (NSString*)getVersion {
	return VERSION;
}

+ (NSString*)getCopyRight {
	return COPYRIGHT;
}

+ (NSString*)formatInterval:(NSTimeInterval) interval {
    unsigned long seconds = interval;
    unsigned long tenmilsec = (interval*100.0)-(seconds*100.0);
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    minutes %= 60;
    
    NSMutableString * str = [[NSMutableString alloc] init];
    if(hours)
        [str appendFormat:@"%d:", (int)hours];
    [str appendFormat:@"%02d:%02d.%02d", (int)minutes, (int)seconds, (int)tenmilsec];
    
    return str;
}

+ (void)moveControl:(UIView*)control pos:(CGPoint)pt {
    CGRect frame = [control frame];
    frame.origin = pt;
    [control setFrame:frame];
}

+ (NSString*)bundleDisplayName {
    return [self bundleInfo:BUNDLE_DISP_NAME];
}

+ (NSString*)bundleName {
    return [self bundleInfo:BUNDLE_NAME];
}

+ (NSString*)bundleVersion {
    return [self bundleInfo:BUNDLE_VERSION];
}

+ (NSString*)bundleInfo:(NSString*)key {
    NSString* value = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
    if (!value) {
        value = [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
    }
    return value;
}

+ (NSString*)copyright {
    return COPYRIGHT_HOLDER;
}

@end
