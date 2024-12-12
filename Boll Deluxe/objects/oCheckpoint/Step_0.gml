//wandering coder PLEASE make the spinning better i BEG -moster

if (!hit) {
	image_index = 0 + (dir * 6);
	exit
} 

var flawed = floor(image_index)

if (image_speed > 0 && flawed mod 3 == 0 && prev_image_index != flawed) {
	image_speed -= 0.25
	if (image_speed <= 0.25)
		image_speed = 0
}

if (flawed == 3 && prev_image_index != flawed) {
	if (spin_amount <= 0)
		sprite_index = spr_checkpoint_hit
	spin_amount -= 1
}

prev_image_index = flawed
