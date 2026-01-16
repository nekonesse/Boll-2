var obj = oJADEController.object_map[| picker_object_index]
var uvs = obj[5][picker_property_index][1]

x=median(x,0,oJADEController.guiw-sprite_width)
y=median(y,0,oJADEController.guih-sprite_height)

var mbleftpress = mouse_check_button_pressed(mb_left)

if (mbleftpress) && !instance_exists(oJADEDropDown) {
	exitbutton.update();
}

var curs_x = window_mouse_get_x()
var curs_y = window_mouse_get_y()
var over = point_in_rectangle(curs_x, curs_y,x,y+19,x+image_xscale-1,y+image_yscale-1)
var mbleft = mouse_check_button(mb_left);
var mbleftrel = !mbleft
var mbrightpress = mouse_check_button_pressed(mb_right);
var mbmiddlepress = (mouse_check_button_pressed(mb_middle) || (keyboard_check(vk_space) && mouse_check_button_pressed(mb_left)))
var mbmiddlerel = (mouse_check_button_released(mb_middle) || (keyboard_check(vk_space) && mouse_check_button_released(mb_left)) || (keyboard_check_released(vk_space) && mouse_check_button(mb_left)))
		
var tileset = global.tilesets[$ oJADEController.current_tileset]
var t_size = 16 * tile_zoom
var t_width = sprite_get_width(tileset[0])
var t_height = sprite_get_height(tileset[0])
var sel_x = curs_x - x - pan_x
var sel_y = curs_y - y - pan_y
var pos_x = clamp(floor(sel_x / t_size),0,(t_width/16)-1)
var pos_y = clamp(floor(sel_y / t_size),0,(t_height/16)-1)
		
//select single tile/start tile dragging
if (over) {
	if (mbleftpress && !tile_drag) && !(keyboard_check(vk_space)) {
		tile_sel_last_x = pos_x
		tile_sel_last_y = pos_y
		tile_drag = true
	}
			
	if (mbrightpress) {
		uvs = [0,0,1,1];
		tile_sel_last_x = 0
		tile_sel_last_y = 0
		tile_drag = false
	}
			
	if (mbmiddlepress) {
		start_pan_x=curs_x;
		start_pan_y=curs_y;
		initial_pan_x=pan_x;
		initial_pan_y=pan_y;
		panning=true;
	}
}
		
if (mbmiddlerel) {
	panning = false;
}
		
if (panning) {
	pan_x = clamp(initial_pan_x+curs_x-start_pan_x,-(t_width-image_xscale),19);
	pan_y = clamp(initial_pan_y+curs_y-start_pan_y,-(t_height-image_yscale),0);
}

//complete tile dragging
if (mbleftrel && tile_drag) {
	uvs[0] = tile_sel_last_x;
	uvs[1] = tile_sel_last_y;
	uvs[2] = clamp(pos_x - tile_sel_last_x,0,(t_width/16)-1)+1;
	uvs[3] = clamp(pos_y - tile_sel_last_y,0,(t_height/16)-1)+1;
	tile_drag = false
}