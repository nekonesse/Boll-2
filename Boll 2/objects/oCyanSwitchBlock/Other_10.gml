if (switch_state) {
	no_collide=true
	sprite_index=spr_cyanswitchblockoff
} else {
	var _list = ds_list_create();
	var _num = check_rectangle_in_hitbox_list(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1, oEnemy, _list);

	if (_num > 0) {
		var i=0;
	    repeat(_num) {
			var enemy = _list[| i];
			enemy.hp = 0;
			enemy.killtype="suffocate";
			enemy.xsc=sign(enemy.x-x);
			make_particle(pImpact, enemy.x, enemy.y,-2);
			i++;
	    }
		audio_play_sound(snd_enemykick)
	}

	ds_list_destroy(_list);
	
	no_collide=false
	sprite_index=spr_cyanswitchblock
}