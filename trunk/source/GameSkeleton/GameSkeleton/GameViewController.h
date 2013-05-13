//
//  ViewController.h
//  GameSkelton
//
//  Created by nobu on 13/05/12.
//  Copyright (c) 2013年 Nobuhiro Kuroiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "BaseGameViewController.h"
#import "ScoreViewController.h"
#import "TouchImage.h"

@interface GameViewController : BaseGameViewController

@property (weak, nonatomic) IBOutlet UILabel* lblTime;
@property (weak, nonatomic) IBOutlet UILabel* lblBonus;
@property (weak, nonatomic) IBOutlet UILabel* lblEarned;
@property (weak, nonatomic) IBOutlet UILabel* lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnGoBack;
@property (strong, nonatomic) IBOutlet ScoreViewController* scoreViewController;
@property (strong, nonatomic) IBOutlet TouchImage* imgLeftTouch;
@property (strong, nonatomic) IBOutlet TouchImage* imgRightTouch;

- (void)setStage:(int)stageNum;
- (IBAction)done:(id)sender;

@end
