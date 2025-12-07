/// \file  scr_morph.gml
/// \brief Handling of variables relevant to the morph shader

global.morph_yoffsets = array_create(256,0.91);
global.morph_xoffsets = array_create(256,0.0);

global.morph_uv_left = 0.0;
global.morph_uv_right = 1.0;

global.morph_uv_top = 0.0;
global.morph_uv_bottom = 1.0;

global.u_morph_yoffsets = shader_get_uniform(shd_morphing,"array_yOffsets");
global.u_morph_xoffsets = shader_get_uniform(shd_morphing,"array_xOffsets");
global.u_morph_uv = shader_get_uniform(shd_morphing,"u_uv");
global.u_morph_uv_x = shader_get_uniform(shd_morphing,"u_uv_x");

function morph_set_shader_data(morph)
{
	shader_set_uniform_f_array(global.u_morph_xoffsets,morph.shader_data[0]);
	shader_set_uniform_f_array(global.u_morph_yoffsets,morph.shader_data[1]);
	shader_set_uniform_f(global.u_morph_uv, global.morph_uv_top, global.morph_uv_bottom);
	shader_set_uniform_f(global.u_morph_uv_x, global.morph_uv_left, global.morph_uv_right);
}

function morph_set_shader_data_ex()
{
	shader_set_uniform_f_array(global.u_morph_xoffsets,global.morph_xoffsets);
	shader_set_uniform_f_array(global.u_morph_yoffsets,global.morph_yoffsets);
	shader_set_uniform_f(global.u_morph_uv, global.morph_uv_top, global.morph_uv_bottom);
	shader_set_uniform_f(global.u_morph_uv_x, global.morph_uv_left, global.morph_uv_right);
}

// morph struct setup
function morph_struct(_parent = noone) constructor{
    // parent
    if (_parent)
    {
        parent = _parent;
    }

    // visual (sprite) positions
    vis_y = 0;
    vis_x = 0;

    // X positions
    x1 = 0;
    x2 = 0;
    x3 = 0;

    // Y positions
    y1 = 0;
    y2 = 0;
    y3 = 0;
    prevy = 0;

    // camera-relative positions
    x_rel = 0;
    y_rel = 0;

    // relative position offsets
    rel_offset = [ -8, 0 ];

    // bottom position of morph
    bottom = 0;

    // scaling, 16-bit fixed-point scale (0 to 65535, 65535 = 0.99)
    scale = 65535;

    // how tall is our morphing sprite?
    height = 65535;
	vis_height = 256; // how our height is when rendered out, for collision stuff
	vis_width = 256; // the widest our sprite is

    // sine wave control
    sinmul = 0; // controls the frequency of the sine wave
    sinoffs = 0; // controls the amplitude of the sine wave

    // how severe was our collision?
    collide_severity = 0;
    fin_collide_severity = collide_severity;
	hitme = noone;

    // width of longest line on morph
    x_width = 0;
    y_width = 0;
	
	col_width = 0;
	col_height = 0;

    y_prev = 0; // previous Y position, likely used for something else

    // collision factors
    colfactor_x = 0;
    colfactor_y = 0;
    colfactor2 = 0;

    // collision flags
    colflags = 0;

    // I Don't Know What This Is :PENIS:
    unk_6f46 = 0;

    // Y offset on morph grid
    offset = 0;
	
	// would cause the sprite to clip out of sprite bounds
	exceed_x = 0;
	exceed_y = 0;

    // the morph grid in question
	// DEPRECATED
    data = array_create(512, 0xFFD0);
	
	shader_data = [ array_create(256, -0.1875), array_create(256, 0) ];
	
	//shader_data[1] = empty_morpharray;
	
	var i=1;
	repeat (255)
    {
        shader_data[1][i] = 0xFFFF - (i);
		i++;
    }

    // debug stuff, comment out when done
    debug_col = array_create(1, noone);
}