if (subimg < 0.5) {
	draw_sprite_circle(spr_pSmoke, floor(subimg * 8), x, y, 1, 1, subimg * (radius * 2), amount, image_angle)
}

draw_sprite(sprite_index, subimg * 5, x,y)