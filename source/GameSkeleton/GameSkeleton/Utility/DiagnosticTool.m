//
//  DiagnosticTool.m
//  TimeIsMoneyCore
//
//  Created by Nobuhiro Kuroiwaon 11/01/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiagnosticTool.h"


@implementation DiagnosticTool

+ (void)printVec3:(GLKVector3)v {
    NSLog(@"%f, %f, %f", v.x, v.y, v.z);
}

+ (void)printVec4:(GLKVector4)v {
    NSLog(@"%f, %f, %f, %f", v.x, v.y, v.z, v.w);
}

+ (void)printMat4:(GLKMatrix4)m {
    NSLog(@"mat:");
    NSLog(@"%f, %f, %f, %f", m.m[0], m.m[4], m.m[8], m.m[12]);
    NSLog(@"%f, %f, %f, %f", m.m[1], m.m[5], m.m[9], m.m[13]);
    NSLog(@"%f, %f, %f, %f", m.m[2], m.m[6], m.m[10], m.m[14]);
    NSLog(@"%f, %f, %f, %f", m.m[3], m.m[7], m.m[11], m.m[15]);
}

@end
