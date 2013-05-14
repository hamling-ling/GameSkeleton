//
//  CommonUtility.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/03/21.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define VERSION			@"1.00.00"
#define COPYRIGHT		@"Your Name"
#define STATUSBAR_H		20
#define DEFAULT_ORIENTATION UIDeviceOrientationPortrait
#define EVT_TRANSITION_REQ	@"TransitionRequest"

@interface CommonUtility : NSObject {
}

+ (void)nilToFail:(id)ptr reason:(NSString*)msg;
+ (void)setOrientation:(UIDeviceOrientation) ori;
+ (int)screenHeight;
+ (int)screenWidth;
+ (int)clientHeight;
+ (BOOL)isLandscape;
+ (UIDeviceOrientation)getMeaningfulOrientation;
+ (BOOL)isFaceUpDown:(UIDeviceOrientation)ori;
+ (void)alertInvalidInput:(NSString*) msg;
+ (NSString*)getVersion;
+ (NSString*)getCopyRight;
+ (BOOL)mutArray:(NSMutableArray*)arr containsInt:(int)num;
+ (NSDate*)createEndTime:(int)timeFrom withLength:(int)len;
+ (NSDate*)createTime:(double)timeInDouble;
+ (void)applyPaddedFooter:(UITableView*)tableView;
+ (CGPoint)getRelPos:(CGPoint*)p forView:(UIView*)v;
+ (CGPoint)getRelPosX:(float)x Y:(float)Y forView:(UIView*)v;
+ (void)addEvtHandlerFor:(id)observer Name:(NSString*)name Sel:(SEL)sel;
+ (void)rmvEvtHandlerFor:(id)observer Name:(NSString*)name;
+ (void)asyncNotifyEvt:(NSString*)name obj:(id)theObj;
+ (void)asyncNotifyEvt:(NSString*)name sdr:(id)theSdr obj:(id)theObj;
+ (BOOL)shouldAutorot2IfOri:(UIInterfaceOrientation)ori;
+ (NSString*)formatInterval:(NSTimeInterval) interval;
+ (void)moveControl:(UIView*)control pos:(CGPoint)pt;
+ (NSString*)bundleDisplayName;
+ (NSString*)bundleName;
+ (NSString*)bundleVersion;
+ (NSString*)bundleInfo:(NSString*)key;
+ (NSString*)copyright;

@end
