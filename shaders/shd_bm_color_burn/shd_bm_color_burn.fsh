// based on DragoniteSpam's fancy blending shader

varying vec2 v_vTexcoord;

bool Equals(float val1, float val2) {
    return abs(val1 - val2) < 0.001;
}

uniform sampler2D samp_dst;

void main() {
    vec4 src_color = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 dst_color = texture2D(samp_dst, v_vTexcoord);
    
    vec3 blended_color;
    if (src_color.a < 0.1) {
        blended_color = dst_color.rgb;
    } else {
        blended_color = 1.0 - ((1.0 - dst_color.rgb) / max(src_color.rgb, 0.001));
    }
    
    // the final blending
    src_color.rgb = blended_color;
    
    src_color = clamp(src_color, vec4(0.0), vec4(1.0));
    dst_color = clamp(dst_color, vec4(0.0), vec4(1.0));
    
    gl_FragColor = src_color * src_color.a + dst_color * (1.0 - src_color.a);
}