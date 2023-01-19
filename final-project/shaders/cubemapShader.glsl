// From https://learnopengl.com/Advanced-OpenGL/Cubemaps

#ifdef VERTEX_SHADER
// ------------------------------------------------------//
// ----------------- VERTEX SHADER ----------------------//
// ------------------------------------------------------//

attribute vec3 a_position;

uniform mat4 u_matrixP;
uniform mat4 u_matrixV;

varying vec3 v_texcoord;

void main()
{
    v_texcoord = a_position;
    gl_Position = u_matrixP * u_matrixV * vec4(a_position, 1.0);
}  

#endif
#ifdef FRAGMENT_SHADER
// ------------------------------------------------------//
// ----------------- Fragment SHADER --------------------//
// ------------------------------------------------------//
precision highp float; //float precision settings
uniform samplerCube u_cubemap; 
uniform vec3 u_tint;

varying vec3 v_texcoord;

void main()
{             
    gl_FragColor = vec4(u_tint, 1) + textureCube(u_cubemap, v_texcoord);
}

#endif