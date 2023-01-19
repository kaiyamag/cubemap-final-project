
#ifdef VERTEX_SHADER
// ------------------------------------------------------//
// ----------------- VERTEX SHADER ----------------------//
// ------------------------------------------------------//

attribute vec3 a_position; // the position of each vertex
attribute vec3 a_normal;   // the surface normal of each vertex

//TODO: Add a_texcoord attribute
attribute vec2 a_texcoord;

uniform mat4 u_matrixM; // the model matrix of this object
uniform mat4 u_matrixV; // the view matrix of the camera
uniform mat4 u_matrixP; // the projection matrix of the camera
uniform mat3 u_matrixInvTransM;
varying vec3 v_normal;    // normal to forward to the fragment shader

// SPECULAR
// World location of camera
uniform vec3 u_cameraPos;

// World location of light
uniform vec3 u_directionalLight;

// Direction that light reflects off of surface (vector to compute in vertex shader)
varying vec3 v_surfaceToView;

// Opposite direction that light shines onto the surface (vector to compute and pass to fragment shader)
varying vec3 v_surfaceToLight;

//TODO: Add v_texcoord varying
varying vec2 v_texcoord;

// Reflection direction, to be passed to fragment shader
varying vec3 v_reflectionDir;

void main() {
    v_normal = normalize(u_matrixInvTransM * a_normal); // set normal data for fragment shader

    // Calculate half-vector
    vec3 surfaceWorldPos = (u_matrixM * vec4 (a_position, 1)).xyz;

    // Point lights use this calculation:
    // v_surfaceToLight = u_directionalLight - surfaceWorldPos;
    
    // Directional light uses this calculation:
    v_surfaceToLight = -u_directionalLight;
    v_surfaceToView = u_cameraPos - surfaceWorldPos;

    //TODO: Transfer texCoord attribute value to varying
    v_texcoord = a_texcoord;

    // Calculate reflection direction
    vec3 viewToSurface = normalize(-v_surfaceToView);
    v_reflectionDir = reflect(viewToSurface, a_normal);


    gl_Position = u_matrixP * u_matrixV * u_matrixM * vec4 (a_position, 1);
}

#endif
#ifdef FRAGMENT_SHADER
// ------------------------------------------------------//
// ----------------- Fragment SHADER --------------------//
// ------------------------------------------------------//

precision highp float; //float precision settings

uniform vec3 u_tint;            
uniform vec3 u_directionalLight;
uniform vec3 u_directionalColor;
uniform vec3 u_ambientColor;   

uniform float u_shininess;

// SPECULAR
// Use for half-vector
varying vec3 v_surfaceToView;
varying vec3 v_surfaceToLight;

varying vec3 v_normal;  // normal from the vertex shader

varying vec2 v_texcoord;

//TODO: Add u_mainTex sampler (main texture)
uniform sampler2D u_mainTex;

// Reflection direction
varying vec3 v_reflectionDir;

uniform samplerCube u_cubemap;

void main(void){
    // calculate basic directional lighting
    vec3 normal = normalize(v_normal);

    // SPECULAR
    // Half-vector calculations
    vec3 surfaceToLightDirection = normalize(v_surfaceToLight);
    vec3 surfaceToViewDirection = normalize(v_surfaceToView);
    vec3 halfVector = normalize(surfaceToLightDirection + surfaceToViewDirection);

    float specular = pow(
        max(0.0, dot(normal, halfVector)), u_shininess
    );

    float diffuse = max(0.0, dot(normal, -u_directionalLight));
    vec3 diffuseColor = u_directionalColor * diffuse;

    // Diffuse color calculations
    //vec3 finalColor = u_ambientColor + diffuseColor;
    //finalColor = clamp(finalColor, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    //finalColor = finalColor * u_tint.rgb;

    // Texture color calculations
    vec3 ambientDiffuse = u_ambientColor + diffuseColor;
    ambientDiffuse = clamp(ambientDiffuse, vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0));

    // Texture color sampling
    vec3 textureColor = texture2D(u_mainTex, v_texcoord).rgb;
    vec3 reflectionColor = textureCube(u_cubemap, v_reflectionDir).rgb;

    vec3 baseColor = textureColor * u_tint;
    vec3 finalColor = ambientDiffuse * baseColor; // apply lighting to color

    // Normal texture coloring
    //gl_FragColor = vec4(finalColor, 1);

    // Apply specular highlighting
    //gl_FragColor = vec4(finalColor + specular * vec3(1,1,1), 1);
    gl_FragColor = vec4(finalColor + specular * reflectionColor, 1);

    // COLOR DEBUGGING
    // gl_FragColor = vec4(v_texcoord, 0, 1);
}

#endif
