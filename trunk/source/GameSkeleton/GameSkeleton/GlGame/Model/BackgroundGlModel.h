//
//  MountainGlModel.h
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlModel3.h"

@interface BackgroundGlModel : GlModel3 {
    GLfloat standAngle;
}

@property (nonatomic, readwrite) GLfloat standAngle;

@end
