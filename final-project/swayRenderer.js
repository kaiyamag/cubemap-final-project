"use strict";

class SwayRenderer extends TextureRenderer{

    /**
    * Sets ALL uniforms for the vertex and fragment shader of this renderers shader program before drawing.
    * @param {ModelTransform} model the model to draw.
    * @param {Object} shaderData whatever other data the Shader needs for drawing.
    */
    setUniformData(model, camera, shaderData){

        let viewMatrix = camera.viewMatrix;
        let projectionMatrix = camera.projectionMatrix;

        // set model, view and projection matrices in the vertex shader
        let modelMatrixLoc = gl.getUniformLocation(this.program, "u_matrixM");
        gl.uniformMatrix4fv(modelMatrixLoc, false, model.modelMatrix.toFloat32());
        let viewMatrixLoc = gl.getUniformLocation(this.program, "u_matrixV");
        gl.uniformMatrix4fv(viewMatrixLoc, false, viewMatrix.toFloat32());
        let projMatrixLoc = gl.getUniformLocation(this.program, "u_matrixP");
        gl.uniformMatrix4fv(projMatrixLoc, false, projectionMatrix.toFloat32());

        // set tint color data
        let colorLoc = gl.getUniformLocation(this.program, "u_tint");
        gl.uniform3fv(colorLoc, model.material.tint.toFloat32());

        // set model inverse transpose to enable lighting calulations using normals
        let invtransLoc = gl.getUniformLocation(this.program, "u_matrixInvTransM");
        gl.uniformMatrix3fv(invtransLoc, false, M4.inverseTranspose3x3(model.modelMatrix).toFloat32());

        // directional and ambient lighting lighting
        let directionalLight = new V3(g_lightingData.lightDirX, g_lightingData.lightDirY, g_lightingData.lightDirZ).normalize();
        let directionalColor = new V3(g_lightingData.lightColorR, g_lightingData.lightColorG, g_lightingData.lightColorB);
        let ambientColor = new V3(g_lightingData.ambientColorR, g_lightingData.ambientColorG, g_lightingData.ambientColorB);

        let lightDirLoc = gl.getUniformLocation(this.program, "u_directionalLight");
        gl.uniform3fv(lightDirLoc, directionalLight.toFloat32());

        let lightColLoc = gl.getUniformLocation(this.program, "u_directionalColor");
        gl.uniform3fv(lightColLoc, directionalColor.toFloat32());

        let ambColLoc = gl.getUniformLocation(this.program, "u_ambientColor");
        gl.uniform3fv(ambColLoc, ambientColor.toFloat32());

        let shininessLoc = gl.getUniformLocation(this.program, "u_shininess");
        gl.uniform1f(shininessLoc, model.material.shininess);

        let cameraPosLoc = gl.getUniformLocation(this.program, "u_cameraPos");
        gl.uniform3fv(cameraPosLoc, camera.getPosition().toFloat32());

        let timeLoc = gl.getUniformLocation(this.program, "u_time");
        gl.uniform1f(timeLoc, shaderData.time);

        let cubemapLoc = gl.getUniformLocation(this.program, "u_cubemap");
        gl.uniform1i(cubemapLoc, 0);

        // texturing
        gl.activeTexture(gl.TEXTURE1);
        let mainTexture = TextureCache[model.material.mainTexture];
        gl.bindTexture(gl.TEXTURE_2D, mainTexture);

        let mainTexLoc = gl.getUniformLocation(this.program, "u_mainTex");
        gl.uniform1i(mainTexLoc, 1);
    }
}
