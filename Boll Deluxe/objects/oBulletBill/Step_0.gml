var coll = instance_place(x + hsp, y, oCollider)

if (coll) && !(coll.no_collide) && !(coll.semi) && (coll != spawn_object) {
	//if on_screen() 
	VinylPlay(snd_enemyexplode)
	instance_destroy();
}

if !rectangle_in_rectangle(
	x - hit_sizex, y - hit_sizey,
	x + hit_sizex, y + hit_sizey,
	0, 0,
	room_width,room_height
) {
	instance_destroy();
}

x += hsp;
y += vsp;