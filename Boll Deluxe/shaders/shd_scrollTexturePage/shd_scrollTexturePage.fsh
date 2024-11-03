
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float xpos;
uniform float ypos;

float modulo(float value, float lower, float upper) {
	vec2 hold = vec2(value-lower, upper-lower);

	if (hold.y == 0.) {
		return lower;
	}
	
	return hold.x - floor(hold.x / hold.y) * hold.y + lower;
}

void main() {
	//v_vTexcoord.x = v_vTexcoord.x / v_vTexcoord.y
	
	//v_vTexcoord = vec2(modulo(xpos,0.,1.), modulo(ypos,0.,1.));
	
    gl_FragColor = v_vColour * texture2D(
		gm_BaseTexture, 
		vec2(
			modulo(((0.5 - v_vTexcoord.x) / v_vTexcoord.y) + xpos,0.,1.),
			modulo((v_vTexcoord.y + ypos), 0., 1.)
		)
	);
}
