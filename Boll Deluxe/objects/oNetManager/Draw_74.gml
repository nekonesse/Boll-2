var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

draw_set_font(global.omiFont)
draw_set_halign(fa_middle)
var i=0;
var keys = variable_struct_get_names(cursors);
repeat(array_length(keys)) {
	var k = keys[i];
	if k!=cursorexclusion {
		var curs=cursors[$ k]
		show_debug_message(curs);
		if rectangle_in_rectangle(curs[0]-2-(string_width(curs[3])/2),curs[1]-2,curs[0]+18+(string_width(curs[3])/2),curs[1]+24, cam_x, cam_y, cam_x+cam_w, cam_y+cam_h) {
			draw_sprite(spr_JADEcursor,0,curs[0]-cam_x,curs[1]-cam_y)
			draw_sprite_ext(spr_JADEicons,curs[2]-1,curs[0]+4-cam_x,curs[1]+4-cam_y,0.5,0.5,0,c_white,1)
			draw_text_outline(curs[0]+6-cam_x, curs[1]+16-cam_y, curs[3], 1, c_black, 8, 1, 1, 0)
		}
	}
	i++;
}
draw_set_halign(fa_left)