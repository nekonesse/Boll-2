varying vec2 v_texcoord;

uniform float alpha;

void main()
{ 
    vec4 colour = texture2D(gm_BaseTexture, v_texcoord);
    gl_FragColor.rgb = vec3(colour.r,colour.g,colour.b);
	
	if (colour.a > 0.0)
	{
		gl_FragColor.a = alpha;
	}
}