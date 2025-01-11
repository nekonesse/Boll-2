///@description Shoot
if  on_screen() {
	var dir = 1
	if (instance_exists(oPlayer)) {
		dir = sign(nearestplayer().x-x)
	}
	if !position_meeting(x+8+(16*dir),y+8,oCollider) || instance_position(x+8+(16*dir),y+8,oCollider).no_collide || instance_position(x+8+(16*dir),y+8,oCollider).semi {
		var i=instance_create_depth(x + (8 * dir), y + 8, depth + 2, oBulletBill);
		i.hsp = dir * 2
		i.xsc = -dir;
		i.spawn_object = id;
		xscale = 1.33;
		yscale = 1.33;
		VinylPlay(snd_enemycannonfast)
	}
}
alarm[0]=random_range(120, 120 + timer_offset);