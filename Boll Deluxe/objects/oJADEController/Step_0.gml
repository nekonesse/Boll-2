mbleftpress=mouse_check_button_pressed(mb_left)
mbleft=mouse_check_button(mb_left)

var guiw=display_get_gui_width()
var guih=display_get_gui_height()
var tb_length = array_length(toolbar[selected_mode])
var not_on_gui=!point_in_rectangle(curs_x,curs_y,(guiw-16)-(32*14),0,(guiw-16)-(32*14)+(32*tb_length)+4,34)&&!point_in_rectangle(curs_x,curs_y,(guiw)-(32*5),0,(guiw)-(32*5)+(32*5)+4,34)&&!point_in_rectangle(curs_x,curs_y,0,(guih/4)-10,32,(guih/4)-10+(32*5)+4)

curs_x=mouse_x
curs_y=mouse_y

gridx = floor(curs_x/16)
gridy = floor(curs_y/16)

if keyboard_check_pressed(vk_escape) room_goto(rMainMenu)

for (var i = 0; i < 5; ++i)
{
	if (mbleftpress) && mouse_in_mode_slot(i) {
		if selected_mode != i {
			selected_toolbar=0
			selected_mode=i
		}
	}
}

var tb_length = array_length(toolbar[selected_mode])
for (var i = 0; i < tb_length; ++i)
{
	if (mbleftpress) && mouse_in_toolbar_slot(i) {
		selected_toolbar=i
	}
}

selected_tool=toolbar[selected_mode][selected_toolbar]

if (mbleftpress) {
	if mouse_in_setting_slot(0) { //exit button
		room_goto(rMainMenu)
	}
}
if (mbleft) {
	if (not_on_gui) && selected_tool == BRUSH_TOOL && is_string(selected_obj) {
		if !collision_rectangle(gridx*16,gridy*16,gridx*16+16,gridy*16+16,oJADEobj,false,true) {
			i=instance_create_depth(gridx*16,gridy*16,0,oJADEobj)
			i.obj=selected_obj
			with (i) {
				get_values(other.selected_obj)
			}
		}
	}
}