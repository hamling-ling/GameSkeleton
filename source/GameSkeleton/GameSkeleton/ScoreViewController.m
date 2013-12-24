//
//  ScoreViewController.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/06/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScoreViewController.h"
#import "CommonUtility.h"
//#import "DataCluster.h"

#define ASPECT_RATIO    (280.0/180.0)   // W/H

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize lblTime;
@synthesize lblFlag;
@synthesize lblTotal;
@synthesize lblGrade;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    CGRect parent_rect = [self.view frame];
    float screenWidth = parent_rect.size.width;
    float screenHeight = parent_rect.size.height;
    
    CGRect my_rect = [self.view frame];
    my_rect.size.width = 0.80 * screenWidth;
    my_rect.size.height = my_rect.size.width/ASPECT_RATIO;
    
    my_rect.origin.x = (screenWidth-my_rect.size.width)/2.0;
    my_rect.origin.y = (screenHeight-my_rect.size.height)/2.0;
    
    [self.view setFrame:my_rect];
}

- (void)viewDidUnload
{
    [self setLblTime:nil];
    [self setLblFlag:nil];
    [self setLblTotal:nil];
    [self setLblGrade:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setResult:(GameResult*) result {
    /*lblTime.text = [CommonUtility formatInterval:result.time];
    lblFlag.text = [NSString stringWithFormat:@"%d", result.flags];
    lblTotal.text = [NSString stringWithFormat:@"%d", (int)result.score];
    lblGrade.text = result.gradeString;*/
}

- (void)showUp {
        [UIView beginAnimations:@"Showup" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.alpha = 0.7;
        [UIView commitAnimations];
}

@end
