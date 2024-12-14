//wandering coder PLEASE make the spinning better i BEG -moster

if (!hit && image_speed == 0) {
	image_index = 0 + (dir * 6);
	exit
} 

var flawed = floor(image_index)

if (image_speed > 0 && flawed mod 3 == 0 && prev_image_index != flawed) {
	image_speed -= 0.25
	if (palette_speed > 1)
		palette_speed -= 0.25
	if (image_speed <= 0.5)
		image_speed = 0
}

if (flawed == 3 && prev_image_index != flawed) {
	if (spin_amount >= 0) {
		spin_amount -= 1
	}
}

if (hit && spin_amount == -1)
	sprite_index = spr_checkpoint_hit

prev_image_index = flawed

if !place_meeting(x,y,oPlayer) && image_speed == 0
	spinning = 0;	