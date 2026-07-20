//Sara's Magical Girl Shader :3
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D texGradient;
uniform sampler2D texBubble;
uniform sampler2D texStars;
uniform float time;
uniform float appSurfWidth;
const float texGradientWidth = 128.0;

void main()
{
	//Gradient
	vec4 colour = texture2D( gm_BaseTexture, v_vTexcoord );
	float gradPos = mod(gl_FragCoord.x/appSurfWidth + time, 1.0);
	vec2 gradCoord = vec2(gradPos,0.0);
	colour.rgb = texture2D(texGradient,gradCoord).rgb;
	
	//Gradient debanding... maybe a bigger gradient texture is just better here lol?
	vec2 oneStep = vec2(0.5/texGradientWidth,0.0);
	float mixpercent = fract(gl_FragCoord.x / (appSurfWidth/texGradientWidth));
	colour.rgb = mix(colour.rgb,texture2D(texGradient,gradCoord + oneStep).rgb, mixpercent);
	
	//White edges
	colour.rgb += abs(-1.0 + mod(gl_FragCoord.x/appSurfWidth, 1.0)*2.0)*0.5;
	
	//Bubbl
	float bublPosX = mod((gl_FragCoord.x/appSurfWidth*4.0) + time*1.25, 1.0);
	float bublPosY = mod(gl_FragCoord.y/appSurfWidth*4.0 + time*1.20, 1.0);
	vec2 bublCoord = vec2(bublPosX,bublPosY);
	colour.rgb = colour.rgb + texture2D( texBubble, bublCoord ).rgb;
	
	//Bubbl2
	bublPosX = mod((gl_FragCoord.x/appSurfWidth*4.0) + time*2.65, 1.0);
	bublPosY = mod(gl_FragCoord.y/appSurfWidth*4.0 + time*2.60, 1.0);
	bublCoord = vec2(bublPosX,bublPosY);
	colour.rgb = colour.rgb + (texture2D( texBubble, bublCoord ).rgb * 0.15);
	
	//Star
	float starsPosX = mod((gl_FragCoord.x/appSurfWidth*4.0) + time*1.95, 1.0);
	float starsPosY = mod(gl_FragCoord.y/appSurfWidth*4.0 + time*1.90, 1.0);
	vec2 starsCoord = vec2(starsPosX,starsPosY);
	colour.rgb = colour.rgb + texture2D( texStars, starsCoord ).rgb;
	
	//Final colour
    gl_FragColor = v_vColour * colour;
}
