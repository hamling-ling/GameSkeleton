//
//  Ground.h
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlBasePresentee.h"
#import "SittingGlModel.h"

@interface Ground : GlBasePresentee {
    SittingGlModel* _grounds[3][3];
    GLKVector3 _skierPos;
    GLKVector3 _boxSize;
}

- (id)initWithVertex:(const vertexData*)data ofSize:(GLsizei)size andTexName:(NSString*)texName;
- (void)setAltitude:(GLfloat)alt;
- (void)setPlayerPos:(GLKVector3)pos;
- (BOOL)boundsCompartment:(SittingGlModel*)model pos:(GLKVector3)pos;

@end

