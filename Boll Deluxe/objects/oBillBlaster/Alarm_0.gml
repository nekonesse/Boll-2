if inview() {
	var dir=sign(nearestplayer().x-x)
	if !position_meeting(x+8+(16*dir),y+8,oCollider) || instance_position(x+8+(16*dir),y+8,oCollider).no_collide || instance_position(x+8+(16*dir),y+8,oCollider).semi {
		var i=instance_create_depth(x+8,y+8,depth+2,oBulletBill);
		i.hsp=dir*2
		i.spawn_object=id
		xscale=1.33;
		yscale=1.33;
		VinylPlay(snd_enemycannon)
	}
}
alarm[0]=120;