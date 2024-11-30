image_yscale=1;
pathprenum=max(pathnum-1,0)
if is_array(pathing) && (pathdraw) {
	ds_list_add(oNodeManager.objectNodesList,[pathing,pathcanrev,pathcanfall,sprite_get_xoffset(sprite_index),sprite_get_yoffset(sprite_index)])
}