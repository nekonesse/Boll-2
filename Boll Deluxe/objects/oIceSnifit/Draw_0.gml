// Inherit the parent event
event_inherited();

if (fireballflash) {
	shader_set(shd_flatcolor)
	shader_set_uniform_f(uni_r,1);
	draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,fireballflash/30)
	fireballflash=max(0,fireballflash-1);
	shader_reset();
}