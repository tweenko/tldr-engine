//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 getColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	float average = (getColor.r + getColor.g + getColor.b) / 3.0;
	vec4 newColor = vec4(average, average, average, getColor.a);
    gl_FragColor = newColor;
}
