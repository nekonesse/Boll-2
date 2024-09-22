if ds_list_size(connected_list) {
	fr+=0.125;
	if fr>=sprite_get_number(spr_current) fr=0;
} else fr=0;

for (var i = 0; i < ds_list_size(connected_list); ++i;) {
	var _id=ds_list_find_value(connected_list,i)
	draw_sprite_ext(spr_current,fr,_id[0],_id[1],point_distance(_id[0],_id[1],_id[2],_id[3])/sprite_get_width(spr_current),1,point_direction(_id[0],_id[1],_id[2],_id[3]),c_white,1)
}