/// @description Insert description here
// You can write your code in this editor
if ramp {
	
	var player = collision_rectangle(x-2*sign(image_xscale), y-2, x+sprite_width+2*sign(image_xscale), y + sprite_height + 2, oPlayer, false, false) 
	
	if player && player.grounded && abs(player.gsp) >= 1 {
		if (hflip && player.x < x + (sprite_width/ 2) + 4  && sign(player.gsp) = -1) {
			with(player) {
				sig.Emit("ramped")
				vsp = gsp * -dsin(colangle)
				hsp = gsp * dcos(colangle)
				grounded = false
				colangle = 0
				colslope = 0
			}
		} else if (!hflip && player.x > x + (sprite_width/ 2) - 4 && sign(player.gsp) = 1) {
			with(player) {
				sig.Emit("ramped")
				vsp = gsp * -dsin(colangle)
				hsp = gsp * dcos(colangle)
				grounded = false
				colangle = 0
				colslope = 0
			}
		}
			
	}
	
}