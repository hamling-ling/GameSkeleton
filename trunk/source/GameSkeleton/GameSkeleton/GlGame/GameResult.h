//
//  GameResult.h
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/08/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject
{
    NSString* gradeString;
    float time;
    int flags;
    float score;
}

@property (nonatomic, readonly, strong) NSString* gradeString;
@property (nonatomic, readonly, assign) float time;
@property (nonatomic, readonly, assign) int flags;
@property (nonatomic, readonly, assign) float score;

- (id)initWithGradeString:(NSString*)str time:(float)theTime flags:(int)flagNum score:(float)theScore ;

@end

