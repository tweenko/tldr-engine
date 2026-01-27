//
// Dieback specific fragment shader
//

uniform vec4 tex_uvs;
uniform vec4 palette_uvs;

uniform ivec2 tex_size;
uniform vec2 tex_offset;

uniform ivec2 palette_size; // palette could technically be on seperate texture page so we need this...
uniform bool palette_enabled;
uniform sampler2D palette_texture;
uniform float palette_index;

uniform ivec2 axis_mode;
uniform ivec2 axis_frequency;
uniform ivec2 axis_amplitude;
uniform vec2 axis_shift;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define PI 3.1415926538
//x vec2 is X, Y
//y vec2 is Y, X
int distort(int d_mode, ivec2 f_position, int i_frequency, int i_amplitude, int i_shift)
{
	
	float fl_frequency = float(i_frequency);
	float fl_amplitude = float(i_amplitude);
	float fl_shift = float(i_shift);
	vec2 fl_position = vec2(f_position);
	
    int offset_pos = 0;
    if(d_mode == 0) { //oscillation
        offset_pos = int(fl_amplitude * sin( ((1.0/fl_frequency)*PI) * float(f_position.y + i_shift) ));
    }
    if(d_mode == 1) { //interlaced
        if(mod(fl_position.y, 2.0) == 0.0) {
            offset_pos = -int(fl_amplitude * sin( ((1.0/fl_frequency)*PI) * float(f_position.y + i_shift) ));
        } else {
            offset_pos = int(fl_amplitude * sin( ((1.0/fl_frequency)*PI) * float(f_position.y + i_shift) ));
        }
    }
    if(d_mode == 2) { //compression
        offset_pos = int(fl_amplitude * sin( ((1.0/fl_frequency)*PI) * float(f_position.x + i_shift) ));
    }
    if(d_mode == 3) { //linear scaling
        offset_pos = int( (f_position.x+i_shift)*int(fl_amplitude/fl_frequency) );
    }
    return offset_pos;
}

void main()
{
	vec2 texture_coords = v_vTexcoord; // quick remap
	
	ivec2 distortion = ivec2(
        distort(axis_mode.x, ivec2(texture_coords.x,texture_coords.y), axis_frequency.x, axis_amplitude.x, int(axis_shift.x)),
        distort(axis_mode.y, ivec2(texture_coords.y,texture_coords.x), axis_frequency.y, axis_amplitude.y, int(axis_shift.y))
    );
	
	vec2 final_pos = vec2(ivec2(texture_coords)+ivec2(tex_offset)+distortion);
	

	final_pos.x = tex_uvs.x+mod(final_pos.x,(tex_uvs.z-tex_uvs.x));
	final_pos.y = tex_uvs.y+mod(final_pos.y,(tex_uvs.w-tex_uvs.y));
	
	vec2 oPos = final_pos/vec2(tex_size);
	
	vec4 base_color = texture2D(gm_BaseTexture, oPos);
    if (palette_enabled) {
		
		vec2 palette_pos = vec2(base_color.r*255.0, palette_index);
		
		palette_pos.x = palette_uvs.x+palette_pos.x;
		palette_pos.y = palette_uvs.y+palette_pos.y-0.5;
		
		vec2 pPos = palette_pos/vec2(palette_size);
		
        base_color = texture2D(palette_texture,pPos);
	}
	gl_FragColor = v_vColour * base_color;
}