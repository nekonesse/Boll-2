varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float red;
uniform float blue;
uniform float green;

void main()
{
    vec4 colour = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor.rgb = vec3(red,green,blue);
    gl_FragColor.a = colour.a;
}