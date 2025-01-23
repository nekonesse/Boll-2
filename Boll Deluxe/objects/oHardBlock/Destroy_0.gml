if (on_screen_xy(32,32)) {
with(instance_create(x+4,y+12,pDestruction)) {image_index=4 hspeed=-1 vspeed=-2} //bottom left
with(instance_create(x+12,y+12,pDestruction)){image_index=4 hspeed=1 vspeed=-2} //bottom right
with(instance_create(x+4,y+4,pDestruction))  {image_index=4 hspeed=-1 vspeed=-4} //top left
with(instance_create(x+12,y+4,pDestruction)) {image_index=4 hspeed=1 vspeed=-4} //top right
		
if (VinylIsPlaying(snd_hardblockbreak)) {
	VinylStop(snd_hardblockbreak);
}
VinylPlay(snd_hardblockbreak);
}