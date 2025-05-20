if (switch_state) {
	no_collide=true
	sprite_index=spr_yellowswitchblockoff
} else {
	var _list = ds_list_create();
	var _num = check_rectangle_in_hitbox_list(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1, oEnemy, _list) ;

	if (_num > 0) {
		var i=0;
	    repeat(_num) {
			var enemy = _list[| i];
			enemy.hp -= 1;
			enemy.killtype="bump";
			enemy.xsc=sign(enemy.x-x) 
			i++;
	    }
	}

	ds_list_destroy(_list);
	no_collide=false
	sprite_index=spr_yellowswitchblock
}