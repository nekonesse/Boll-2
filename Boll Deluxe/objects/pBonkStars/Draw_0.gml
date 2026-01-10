image_index = abs(sin(timer * 0.2)) * 4;
draw_sprite_circle(sprite_index,round(image_index),floor(x),floor(y),0.5,0.5,timer * 2,6,0,0,#F0D818)
timer += (timer < 15);
if (timer == 15) {
	instance_destroy();
}