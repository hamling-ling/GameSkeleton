//
//  Background.h
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlBasePresentee.h"
#import "BackgroundGlModel.h"

@interface Background : GlBasePresentee {
    BackgroundGlModel* _background;
}

- (id)initWithVertex:(const vertexData*)data ofSize:(GLsizei)size andTexName:(NSString*)texName;

@end
