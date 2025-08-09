//
// Invert Color Shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 OC = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    float NCr = 1.0 / ( 112.0 * ( OC.r / 2.0));
    float NCg = 1.0 / ( 66.0 * ( OC.g / 2.0 ));
    float NCb = 1.0 / ( 20.0 * ( OC.b / 2.0 ));
    gl_FragColor = vec4( NCr, NCg, NCb, OC.a );
}