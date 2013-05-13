//
//  ScoreViewController.h
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/06/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameResult.h"

@interface ScoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblGrade;

- (void)setResult:(GameResult*) result;
- (void)showUp;

@end
