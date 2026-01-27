// Fragment (Overlay)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D texOverlay;
void main() {
    vec4 inColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 outColor = vec4(0.0,0.0,0.0, inColor.a);
    vec4 overlay = texture2D(texOverlay, v_vTexcoord);
    if (inColor.r > 0.5) {
        outColor.r = (1.0 - (1.0 - 2.0 * (inColor.r - 0.5)) * (1.0 - overlay.r));
    }
    else {
        outColor.r = ((2.0 * inColor.r) * overlay.r);
    }
    if (inColor.g > 0.5) {
        outColor.g = (1.0 - (1.0 - 2.0 * (inColor.g - 0.5)) * (1.0 - overlay.g));
    }
    else {
        outColor.g = ((2.0 * inColor.g) * overlay.g);
    }
    if (inColor.b > 0.5) {
        outColor.b = (1.0 - (1.0 - 2.0 * (inColor.b - 0.5)) * (1.0 - overlay.b));
    }
    else {
        outColor.b = ((2.0 * inColor.b) * overlay.b);
    }
    gl_FragColor = mix(outColor, inColor, 1.0 - overlay.a);
}