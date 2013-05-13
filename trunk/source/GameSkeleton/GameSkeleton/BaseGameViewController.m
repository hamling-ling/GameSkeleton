//
//  BaseGameViewController.m
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/06/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseGameViewController.h"
#import "SittingGlModel.h"
#import "CommonUtility.h"
#import "DiagnosticTool.h"

@interface BaseGameViewController ()

@end

@implementation BaseGameViewController

@synthesize context = _context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [self initContext];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initContext];
    [self setupGameViewController];
}

- (void)initContext {
    if(self.context == nil)
    {
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!self.context) {
            LOG(@"Failed to create ES context");
        }
        
        GLKView *view = (GLKView *)self.view;
        view.context = self.context;
        view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self tearDownGameViewController];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)setupGameViewController {
    // should be overridden.
}

- (void)tearDownGameViewController {
    // should be overridden.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];

    [self loadShaders];
    
    glEnable(GL_DEPTH_TEST);
    
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
}

- (void)tearDownGL
{
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -  OpenGL ES 2 delegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if (_state != GAMEVIEWSTATE_RUNNING)
        return;

    if(!_theGame)
        return;
    
    glClearColor(0.44f, 0.66f, 0.79f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    
    @synchronized(GlGameLock) {
        
        for (GlBasePresentee* p in _theGame.presentees) {
            
            if (!p.isVisible)
                continue;
            
            for (GlModel3* m in p.models) {
                
                if (m.isAlphaEnabled) {
                    if(!glIsEnabled(GL_BLEND)) {
                        glEnable(GL_BLEND);
                        glBlendFunc(GL_ONE, GL_ONE);
                    }
                }
                else {
                    glDisable(GL_BLEND);
                }
                
                glBindVertexArrayOES([m vertexArray]);
                glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _projectionMatrix.m);
                
                const GLKMatrix4* pModelViewMat = [m modelViewMatrixPtr];
                GLKMatrix3 normal = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(*pModelViewMat), NULL);
                glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normal.m);
                
                GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(_projectionMatrix, *pModelViewMat);
                glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
                
                glActiveTexture(GL_TEXTURE0);
                glBindTexture(GL_TEXTURE_2D, m.textureName);
                
                glUniform1i(uniforms[UNIFORM_TEXTURE_SAMPLER], 0);
                
                GLKVector4 exColor = m.extraColor;
                glUniform4f(uniforms[UNIFORM_COLOREX], exColor.r, exColor.g, exColor.b, exColor.a);
                glUniform1f(uniforms[UNIFORM_COLORAMB], m.ambientStrength);
                
                glDrawArrays(GL_TRIANGLES, 0, [m triangleNum]);
                glBindTexture(GL_TEXTURE_2D, 0);
                glBindVertexArrayOES(0);
            }
        }
    }
    glUseProgram(0);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (void)setupSlots {
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_TEXTURE_SAMPLER] = glGetUniformLocation(_program, "Texture");
    uniforms[UNIFORM_COLOREX] = glGetUniformLocation(_program, "colorEx");
    uniforms[UNIFORM_COLORAMB] = glGetUniformLocation(_program, "colorAmb");
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        LOG(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        LOG(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "TexCoordIn");
    
    // Link program.
    if (![self linkProgram:_program]) {
        LOG(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    [self setupSlots];
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        LOG(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        LOG(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        LOG(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        LOG(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


@end
