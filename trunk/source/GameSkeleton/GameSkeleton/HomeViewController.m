//
//  HomeViewController.m
//  GameSkelton
//
//  Created by nobu on 13/05/13.
//  Copyright (c) 2013年 Nobuhiro Kuroiwa. All rights reserved.
//

#import "HomeViewController.h"
#import "GlGamePresenter.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGameViewController {
    NSAssert(_state == GAMEVIEWSTATE_UNINIT, @"invalid operation");
    
    _state = GAMEVIEWSTATE_INITIALIZING;
    
    [super setupGameViewController];
    
    [self setupGL];
    
    _state = GAMEVIEWSTATE_RUNNING;
}

- (void)tearDownGameViewController {
    _state = GAMEVIEWSTATE_UNINIT;
    
    [super tearDownGameViewController];
    
    [self tearDownGL];
}

- (void)setupGL {
    [super setupGL];
    
    assert(_theGame == nil);
    _theGame = [[GlGamePresenter alloc] init];
    [_theGame setupGLForStage:0];
}

- (void)tearDownGL {
    [_theGame tearDownGL];
    _theGame = nil;
    
    [super tearDownGL];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    if (_state != GAMEVIEWSTATE_RUNNING)
        return;
    
    if (!_theGame)
        return;
    
    [_theGame updateWithTimeSinceLastUpdate:self.timeSinceLastUpdate];
}
@end
