draw_gui(x-3,y-3,image_xscale+6,image_yscale+6,oJADEController.themeaccent4,1,true)

draw_rect(x-2,y+16,image_xscale+4,2,oJADEController.themeaccent3,1)

exitbutton.draw();

draw_set_font(global.rulerGold)

var obj = oJADEController.object_map[| picker_object_index]

var tileset = global.tilesets[$ obj[5][picker_property_index+1][1]]

draw_text(x,y+2,$"Tile Picker - {tileset[2]}")
		
var scissor = gpu_get_scissor();
gpu_set_scissor(x,y+19,image_xscale,image_yscale-19)
		
draw_sprite(tileset[0],0,x+pan_x,y+pan_y)
		
var t_size = 16 * tile_zoom
var t_width = sprite_get_width(tileset[0])
var t_height = sprite_get_height(tileset[0])
if !(tile_drag) { //draw selection rectangle (after selection)
	var uvs = obj[5][picker_property_index][1]
	var uv_x = uvs[0];
	var uv_y = uvs[1];
	var uv_w = uvs[2];
	var uv_h = uvs[3];
	
	draw_rect(x+(uv_x*t_size)+pan_x,y+(uv_y*t_size)+pan_y,(uv_w*t_size),(uv_h*t_size),c_white,1,true)
} else { //draw tile selecting rectangle
	var curs_x = window_mouse_get_x()
	var curs_y = window_mouse_get_y()
	var sel_x = curs_x - x - pan_x
	var sel_y = curs_y - y - pan_y
	var pos_x = clamp(floor(sel_x / t_size),0,t_width)*t_size
	var pos_y = clamp(floor(sel_y / t_size),0,t_height)*t_size
	var boxw = max(pos_x - tile_sel_last_x*t_size,0)
	var boxh = max(pos_y - tile_sel_last_y*t_size,0)
	draw_rect(x+(tile_sel_last_x*t_size)+pan_x,y+(tile_sel_last_y*t_size)+pan_y,min(abs(boxw+16),t_width-tile_sel_last_x*t_size),min(abs(boxh+16),t_height-tile_sel_last_y*t_size),c_white,1,true)
}
		
gpu_set_scissor(scissor)