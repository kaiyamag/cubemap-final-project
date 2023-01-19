# cubemap-final-project
A WebGL project exploring cubemaps, directional lighting, reflection, and animation. This project unites all of the concepts covered in my Computer Graphics course and showcases individual research into skymaps and reflections. Developed from a course template.

## Running the Project:
Download all project files from `common/` and `final-project/` and run `engine.html` with Visual Studio Code Live Server. Click "Start Animation" to render the scene, navigate using the arrow keys and click & drag, and mute music with the button in the upper right corner.

## Project Features:
* Free camera: move forwards and backwards with arrow keys, turn left and right with arrow keys, click and drag to look around
* Directional lighting with specular highlights and shininess.
* Skymap implemented with a cubemap. Cubemap renderer and shader are separate from other shader files.
* Environment reflections with cubemaps. Reflections are intentionally most visible in specular highlights.
* Textures (photo and hand-drawn)
* Animated sunrise: direction and color of directional lighting changes to mimic a sunrise/sunset cycle. Cubemap tint also changes to match lighting color.
* Music synced to animation frame rate when start button is clicked.

## Sources:
* Skybox images from https://learnopengl.com/Advanced-OpenGL/Cubemaps
* Music from https://www.epidemicsound.com/track/PsefVL0aA7/
* 3D models and textures created independently in Blender
