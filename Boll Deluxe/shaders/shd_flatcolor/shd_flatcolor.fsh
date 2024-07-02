varying vec2 v_texcoord;

uniform float red;
uniform float blue;
uniform float green;

void main()
{ 
    vec4 colour = texture2D(gm_BaseTexture, v_texcoord);
    gl_FragColor.rgb = vec3(red,green,blue);
    gl_FragColor.a = colour.a;
}