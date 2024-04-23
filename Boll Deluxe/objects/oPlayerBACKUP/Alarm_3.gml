/// @description Pipes
if global.exittype==warptypes.pipe {
	with oPipeUp {
		if (name == global.exitlocation) {
		    with oPlayer { //this assumes that either all players travel together or theres no other players cuz im lazy
				x = (other.x + (other.sprite_width / 2))
				y = (other.y + 120)
				
				hsp=0
				vsp=-1.5
				global.exittype="none"
				alarm[3]=80
			}
		}
	}
}
else if global.exittype=="none" {
	piped=0
	vsp=0
	hsp=0
}