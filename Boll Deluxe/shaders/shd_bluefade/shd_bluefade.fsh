//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float staged_offset;
uniform bool fadein;

void main()
{
	vec4 colour = texture2D(gm_BaseTexture, v_vTexcoord);
	if (fadein == true){
		gl_FragColor.r = colour.r - clamp(staged_offset, 0.0, 1.0);
		gl_FragColor.g = colour.g - clamp(staged_offset - colour.r, 0.0, 1.0);
		gl_FragColor.b = colour.b - clamp(staged_offset - colour.r - colour.g, 0.0, 1.0);
	} else {
		gl_FragColor.b = clamp(staged_offset, 0.0, colour.b);
		gl_FragColor.g = clamp(staged_offset - colour.b, 0.0, colour.g);
		gl_FragColor.r = clamp(staged_offset - colour.b - colour.g, 0.0, colour.r);
	}
    gl_FragColor.a = colour.a;
}
