
// Black and white fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float time;

vec3 hsv2rgb(vec3 c) 
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    float gray = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
    gl_FragColor = v_vColour * vec4(gray, gray, gray, texColor.a);
	gl_FragColor.rgb = gl_FragColor.rgb + hsv2rgb(vec3(time,1,0.7));
}
