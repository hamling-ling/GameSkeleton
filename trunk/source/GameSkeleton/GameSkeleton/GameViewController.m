//
//  ViewController.m
//  GameSkeleton
//
//  Created by nobu on 13/05/12.
//  Copyright (c) 2013年 Nobuhiro Kuroiwa. All rights reserved.
//

#import "GameViewController.h"
#import "BaseGameViewController.h"
#import "CommonUtility.h"
#import "DiagnosticTool.h"
#import "GlGamePresenter.h"

@interface GameViewController () {
    int _stageNum;
}

@end

@implementation GameViewController

@synthesize lblTime;
@synthesize lblBonus;
@synthesize lblStatus;
@synthesize lblEarned;
@synthesize btnGoBack;
@synthesize scoreViewController;
@synthesize imgLeftTouch;
@synthesize imgRightTouch;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setStage:(int)stageNum {
    if (0 <= stageNum && stageNum <= 3) {
        _stageNum = stageNum;
    }
    else {
        _stageNum = 0;
    }
}

- (void)setupGameViewController {
    NSAssert(_state == GAMEVIEWSTATE_UNINIT, @"invalid operation");
    
    _state = GAMEVIEWSTATE_INITIALIZING;
    [CommonUtility addEvtHandlerFor:self Name:EVT_PLAY_START Sel:@selector(skiStarted:)];
    [CommonUtility addEvtHandlerFor:self Name:EVT_PLAY_GOAL Sel:@selector(skiGoaled:)];
    [CommonUtility addEvtHandlerFor:self Name:EVT_PLAY_POINT_EARNED Sel:@selector(skiPointEarned:)];
    [CommonUtility addEvtHandlerFor:self Name:EVT_PLAY_WORN Sel:@selector(skiWorn:)];
    
    [self setupGL];
    
    _state = GAMEVIEWSTATE_RUNNING;
}

- (void)tearDownGameViewController {
    _state = GAMEVIEWSTATE_UNINIT;
    
    [CommonUtility rmvEvtHandlerFor:self Name:EVT_PLAY_START];
    [CommonUtility rmvEvtHandlerFor:self Name:EVT_PLAY_GOAL];
    [CommonUtility rmvEvtHandlerFor:self Name:EVT_PLAY_POINT_EARNED];
    [CommonUtility rmvEvtHandlerFor:self Name:EVT_PLAY_WORN];
    
    [self tearDownGL];
    [self setLblTime:nil];
    [self setLblBonus:nil];
    [self setLblStatus:nil];
    [self setLblEarned:nil];
    [self setBtnGoBack:nil];
    
    [self.scoreViewController removeFromParentViewController];
    self.scoreViewController = nil;
    
    [self.imgLeftTouch inActivate];
    [self.imgLeftTouch removeFromSuperview];
    self.imgLeftTouch = nil;
    [self.imgRightTouch inActivate];
    [self.imgRightTouch removeFromSuperview];
    self.imgRightTouch = nil;
}

- (void)setupGL
{
    [super setupGL];
    
    assert(_theGame == nil);
    _theGame = [[GlGamePresenter alloc] init];
    [_theGame setupGLForStage:_stageNum];
}

- (void)tearDownGL
{
    [_theGame tearDownGL];
    _theGame = nil;
    
    [super tearDownGL];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [self done:self];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    if (_state != GAMEVIEWSTATE_RUNNING)
        return;
    
    if (!_theGame)
        return;
    
    [_theGame updateWithTimeSinceLastUpdate:self.timeSinceLastUpdate];
    lblTime.text = [CommonUtility formatInterval:_theGame.time];
    lblBonus.text = [NSString stringWithFormat:@"%d", _theGame.bonus];
}

#pragma mark -  Interaction Event Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_theGame touchesBegan:touches proj:&_projectionMatrix view:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_theGame touchesMoved:touches proj:&_projectionMatrix view:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_theGame touchesEnded:touches proj:&_projectionMatrix];
}

@end
