var radius = 44, 

	objectlist = [oBrick, oItemBox, oFlipblock],       //register objects here
	soundlist = [snd_blockbreak],                      //register sounds here
	
	olistsize = array_length(objectlist),
	slistsize = array_length(soundlist),
	
	soundplayed = snd_checkpoint;

for (var i = 0; i < olistsize; i++) {
	
	with (objectlist[i]) {
		if (distance_to_point(other.x, other.y) < radius) {     
			if soundplayed != soundlist[i % slistsize] {                          //check if the sound has been played
				soundplayed = soundlist[i % slistsize];
				VinylPlay(soundlist[i % slistsize])    //play if it hasnt
			}
			
			var j = noone;
			j = instance_create(x-4,y+4,pDestruction) with (j) {image_index=0 hspeed=-1 vspeed=-2} //bottom left
			j = instance_create(x-4,y-4,pDestruction) with (j) {image_index=0 hspeed=1 vspeed=-2} //bottom right
			j = instance_create(x+4,y+4,pDestruction) with (j) {image_index=0 hspeed=-1 vspeed=-4} //top left
			j = instance_create(x+4,y-4,pDestruction) with (j) {image_index=0 hspeed=1 vspeed=-4} //top right
			
			instance_destroy();                        //destroy object
		}
	}
	soundplayed = false
}

with (oHardBlock) {
	if (distance_to_point(other.x, other.y) < radius && !place_meeting(x,y-1,oFlagpole)) {
		var j = noone;
		j = instance_create(x-4,y+4,pDestruction) with (j) {image_index=0 hspeed=-1 vspeed=-2} //bottom left
		j = instance_create(x-4,y-4,pDestruction) with (j) {image_index=0 hspeed=1 vspeed=-2} //bottom right
		j = instance_create(x+4,y+4,pDestruction) with (j) {image_index=0 hspeed=-1 vspeed=-4} //top left
		j = instance_create(x+4,y-4,pDestruction) with (j) {image_index=0 hspeed=1 vspeed=-4} //top right
		
		if (soundplayed != snd_hardblockbreak) {
			VinylPlay(snd_hardblockbreak)
			soundplayed = snd_hardblockbreak;
		}
		
		instance_destroy();
	}
}

with (oPlayer) {
	if (distance_to_point(other.x, other.y) < radius) {
		sig.Emit("hurt_by_spike");
	}
}

with (oEnemy) {
	if (distance_to_object(other) <= radius) {
		enemyFireballed.Emit(id, other);
	}
}