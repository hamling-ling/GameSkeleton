//
//  Shader.fsh
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/03/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;

void main()
{
    gl_FragColor = colorVarying * texture2D(Texture, TexCoordOut);
}
