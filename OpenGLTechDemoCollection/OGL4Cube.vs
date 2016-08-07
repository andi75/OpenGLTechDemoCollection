#version 410 core

in vec3 position;
in vec3 normal;
in vec3 vertexColor;

uniform mat4 Pmatrix;
uniform mat4 MVmatrix;
uniform mat3 matNormal;

out vec4 color;

void main(void) {
    gl_Position = Pmatrix * MVmatrix * vec4(position, 1.0);
    
    vec3 eyeNormal = matNormal * normal;
    float light = eyeNormal.z; // camera light
    color = vec4(light * vertexColor, 1);
}