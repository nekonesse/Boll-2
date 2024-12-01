var coll=instance_place(x+hsp,y,oCollider)
if (coll) && !(coll.no_collide) && !(coll.semi) && (coll != spawn_object) {
	if on_screen() VinylPlay(snd_enemyexplode)
	instance_destroy();
}