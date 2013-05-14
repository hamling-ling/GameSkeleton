//
//  Background.mm
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Background.h"
#import "CommonUtility.h"

@interface Background() {
}
@end

@implementation Background

- (id)initWithVertex:(const vertexData*)data ofSize:(GLsizei)size andTexName:(NSString*)texName {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of Background init failed"];
    
    _background = [[BackgroundGlModel alloc] initWithVertex:data ofSize:size texPng:texName];

    self.models = [NSArray arrayWithObjects:_background, nil];
    
    return self;
}

- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat {
    [super setupGLWithBaseModelViewMatPtr:pMat];
    
    [_background initPos:ZERO_VECTOR3 andBaseModelViewMat:pMat];
}

- (void)setPos:(GLKVector3)pos {
    [_background setPos:pos];
}

@end
