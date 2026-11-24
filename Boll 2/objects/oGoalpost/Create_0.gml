depth = 5;

onHit = new Signal();
onFinish = new Signal();

used = false;

signpost_angle = 0;
signpost_spd = 0;
signpost_player = noone;
signpost_sprite = -1;
signpost_y = bbox_bottom-24;
signpost_goto = signpost_y;
signpost_top_y = bbox_top+32;
signpost_bottom_y = bbox_bottom-24;
signpost_vsp = 0;
signpost_going = false;
belltimer = 0;
bellspeed = 0;
belltimer_max = 180;
hit_bell = false;

onHit.Connect( self, function(_y,_player) {
	signpost_spd = 10;
	signpost_angle = 0;
	signpost_player = _player;
	signpost_going = true;
	signpost_goto = clamp(_y,signpost_top_y,signpost_bottom_y);
	
	used = true;
	
	with(_player) {
		if within(y+vsp,other.bbox_top,other.bbox_top+28) || within(y+vsp-hit_sizey,other.bbox_top,other.bbox_top+28) || within(y+hit_sizey,other.bbox_top,other.bbox_top+28) {
			with(other) {
				//hit bell
				hit_bell = true;
				bellspeed = 0.5;
				belltimer = (belltimer_max / (60 * 0.05)) / (60 * 0.05)
				VinylPlay(snd_bellring);
			}
		}
	}
	
	if within(_y,signpost_top_y,signpost_bottom_y-8) {
		signpost_vsp = 1;
	}
	signpost_sprite=oGameManager.PlayerColl.GetImageInfo($"spr_{global._playerChars[_player.pNum]}_signposticon")
	VinylPlay(snd_goal);
});

onFinish.Connect( self, function() {
	with(signpost_player) {
		if (other.hit_bell) {
			sig.Emit("1up");
		}
		finish = 1;
	}
	VinylPlay(snd_signpost);
	a11y_speak("Level complete!", true);
});