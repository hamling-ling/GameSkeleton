//
//  BaseGameViewController.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/06/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "GlGamePresenter.h"
// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_TEXTURE_SAMPLER,
    UNIFORM_COLOREX,
    UNIFORM_ALPHA,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

typedef enum
{
    GAMEVIEWSTATE_UNINIT,
    GAMEVIEWSTATE_INITIALIZING,
    GAMEVIEWSTATE_RUNNING,
} GameViewState;

@interface BaseGameViewController : GLKViewController
{
    GLuint _program;
    GLKMatrix4 _projectionMatrix;
    GameViewState _state;

    GlGamePresenter* _theGame;
}

@property (strong, nonatomic) EAGLContext *context;

- (void)setupGameViewController;
- (void)tearDownGameViewController;
- (void)setupGL;
- (void)tearDownGL;
- (void)setupSlots;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end
