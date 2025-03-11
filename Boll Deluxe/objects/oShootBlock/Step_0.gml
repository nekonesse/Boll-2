event_inherited();

if (goDirection != 0) {
	y += goDirection*3;
	image_index = ternary(goDirection, 1, 2);
	
	if !on_screen_xy(32,32) && !place_meeting(x,y,oActivationRegion) {
		instance_destroy();
	}
	
	if check_collision_line(bbox_left+1,y+(sprite_height/2)*goDirection,bbox_right-1,y+(sprite_height/2)*goDirection,COL_TOP,oCollider) {
		var blocklist=ds_list_create();
		var num=collision_line_list(bbox_left+1,y+(sprite_height/2)*goDirection,bbox_right-1,y+(sprite_height/2)*goDirection,oHittable, false, true, blocklist, true)
		if (num > 0) {
			var i=0;
			repeat (num) {
				var blockcoll=ds_list_find_value(blocklist, i)
				if !(blockcoll.no_hit) && (blockcoll.amount != 0) {
					if (blockcoll.hit == 0) {
						blockcoll.blockHit.Emit(goDirection, id)
					}
				}
				i++;
			}
		}
		
		ds_list_destroy(blocklist);
		
		instance_create(x,y+(sprite_height/2)*goDirection,pImpact)
		instance_destroy();
	}
}