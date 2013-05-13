//
//  Ground.mm
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Ground.h"
#import "CommonUtility.h"

@interface Ground() {
    GLfloat altitude;
}

@end


@implementation Ground

- (id)initWithVertex:(const vertexData*)data ofSize:(GLsizei)size andTexName:(NSString*)texName {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of Ground init failed"];
    [self setupGroundWithVertex:data ofSize:size andTexName:texName];

    altitude = 0.0;

    return self;
}

- (void)setupGroundWithVertex:(const vertexData*)data ofSize:(GLsizei)size andTexName:(NSString*)texName {
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            SittingGlModel* grd = [[SittingGlModel alloc] initWithVertex:data ofSize:size texPng:texName];
            _grounds[i][j] = grd;
            [arr addObject:grd];
        }
    }
    
    self.models = [NSArray arrayWithArray:arr];
    _boxSize = _grounds[0][0].boxSize;
}

- (void)setAltitude:(GLfloat)alt {
    altitude = alt;
}

- (void)setPlayerPos:(GLKVector3)pos {
    _skierPos = pos;

    [self rearrangeGrounds];
}

- (BOOL)boundsCompartment:(SittingGlModel*)model pos:(GLKVector3)pos {
    GLKVector3 modelpos = model.position;
    GLKVector3 box_2 = GLKVector3MultiplyScalar(_boxSize, 0.5);
    if(modelpos.x - box_2.x <= pos.x && pos.x < modelpos.x + box_2.x)
        if(modelpos.z - box_2.z <= pos.z && pos.z < modelpos.z + box_2.z)
            return true;
    return false;
}

- (void)rearrangeGrounds {
    // get grounds index where skier is on
    int pos_i = -1, pos_j = -1;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if([self boundsCompartment:_grounds[i][j] pos:_skierPos]) {
                pos_i = i;
                pos_j = j;
                i=3;j=3;// break the loop
            }
        }
    }
    assert(pos_i >= 0);
    assert(pos_j >= 0);

    // rearrange
    int di = 1-pos_i;
    int dj = 1-pos_j;
    GLKVector3 sz = _boxSize;
    SittingGlModel* update[3][3] = {NULL};
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            int inc_i = i+di;
            int inc_j = j+dj;
            int dst_i = (0<=inc_i)?(inc_i%3):(2);
            int dst_j = (0<=inc_j)?(inc_j%3):(2);
            update[dst_i][dst_j] = _grounds[i][j];

            GLKVector3 pos = _grounds[i][j].position;
            GLKVector3 nxt_pos = GLKVector3Make(pos.x - di * sz.x, pos.y, pos.z + dj * sz.z);
            [_grounds[i][j] resetInitPos:nxt_pos];
        }
    }
}

- (void)setupGLWithBaseModelViewMatPtr:(GLKMatrix4*)pMat {
    [super setupGLWithBaseModelViewMatPtr:pMat];

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {

            GLfloat w = _boxSize.x;
            GLfloat h = _boxSize.z;

            [_grounds[i][j] initPos:GLKVector3Make(-w+i*w, altitude, h-j*h)
                andBaseModelViewMat:pMat];
        }
    }
}

- (void)tearDownGL {
    [super tearDownGL];

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            _grounds[i][j] = nil;
        }
    }

    self.models = nil;
}

@end
