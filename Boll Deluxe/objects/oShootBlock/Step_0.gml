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
			for (var i = 0; i < num; i+=1) {
				var blockcoll=ds_list_find_value(blocklist, i)
				if !(blockcoll.no_hit) && (blockcoll.amount != 0) {
					if (blockcoll.hit == 0) {
						blockcoll.blockHit.Emit(goDirection, id)
					}
				}
			}
		}
		
		ds_list_destroy(blocklist);
		
		VinylPlay(snd_shootblockbreak)
		instance_create(x,y+(sprite_height/2)*goDirection,pImpact)
		instance_destroy();
		var j=instance_create(x-4,y+4,pDestruction) with(j){image_index=7 hspeed=-1 vspeed=-2} //bottom left
		var j=instance_create(x+4,y+4,pDestruction) with(j){image_index=7 hspeed=1 vspeed=-2} //bottom right
		var j=instance_create(x-4,y-4,pDestruction) with(j){image_index=7 hspeed=-1 vspeed=-4} //top left
		var j=instance_create(x+4,y-4,pDestruction) with(j){image_index=7 hspeed=1 vspeed=-4} //top right
	}
}