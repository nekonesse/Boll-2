if (on_screen_xy(32,32)) {
	with instance_create(x-4,y+4,pDestruction) {image_index=7 hspeed=-1 vspeed=-2} //bottom left
	with instance_create(x+4,y+4,pDestruction) {image_index=7 hspeed=1 vspeed=-2} //bottom right
	with instance_create(x-4,y-4,pDestruction) {image_index=7 hspeed=-1 vspeed=-4} //top left
	with instance_create(x+4,y-4,pDestruction) {image_index=7 hspeed=1 vspeed=-4} //top right

	if (VinylIsPlaying(snd_shootblockbreak)) {
		VinylStop(snd_shootblockbreak);
	}
	VinylPlay(snd_shootblockbreak);
}