//
//  DiagnosticTool.h
//  TimeIsMoneyCore
//
//  Created by Nobuhiro Kuroiwa on 11/01/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

#ifdef DEBUG
#  define LOG(...) NSLog(__VA_ARGS__)
#  define LOG_ENT()	NSLog(@"ENT %@.%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define LOG_LEAVE() NSLog(@"LEAVE %@.%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define LOG_METHOD() NSLog(@"%@.%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define LOG_METHODMSG(...) NSLog(@"%@.%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __VA_ARGS__)
#  define LOGN(...) NSLog(@"%@ %@ %@", NSStringFromClass([self class]), [self name], NSStringFromSelector(_cmd))
#else
#  define LOG(...);
#  define LOG_ENT(...);
#  define LOG_LEAVE(...);
#  define LOG_METHOD(...);
#  define LOG_METHODMSG(...);
#  define LOGN(...);
#endif

#import <Foundation/Foundation.h>


@interface DiagnosticTool : NSObject {
}

+ (void)printVec3:(GLKVector3)v;
+ (void)printVec4:(GLKVector4)v;
+ (void)printMat4:(GLKMatrix4)m;

@end
