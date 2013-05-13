//
//  Shader.vsh
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/03/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 TexCoordIn;

varying vec2 TexCoordOut;
varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec4 colorEx;
uniform float colorAmb;
//float ambient = 0.85;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    colorVarying = colorAmb + diffuseColor * nDotVP + colorEx;
    
    gl_Position = modelViewProjectionMatrix * position;

    TexCoordOut = TexCoordIn;
}
