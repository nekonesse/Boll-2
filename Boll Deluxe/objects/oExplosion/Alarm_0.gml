var  
	objectlist = [oBrick, oItemBox, oFlipblock],       //register objects here
	soundlist = [snd_blockbreak],                      //register sounds here
	
	olistsize = array_length(objectlist),
	slistsize = array_length(soundlist),
	
	soundplayed = snd_checkpoint;

for (var i = 0; i < olistsize; i++) {
	
	instance_activate_object(objectlist[i])
	with (objectlist[i]) {
		if (distance_to_point(other.x, other.y) < other.radius) {     
			if soundplayed != soundlist[i % slistsize] {                          //check if the sound has been played
				soundplayed = soundlist[i % slistsize];
				VinylPlay(soundlist[i % slistsize])    //play if it hasn't
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

instance_activate_object(oHardBlock)
with (oHardBlock) {
	if (distance_to_point(other.x, other.y) < other.radius && !place_meeting(x,y-1,oFlagpole)) {
		if (soundplayed != snd_hardblockbreak) {
			VinylPlay(snd_hardblockbreak)
			soundplayed = snd_hardblockbreak;
		}
		
		var j = noone;
		j = instance_create(x-4,y+4,pDestruction) with (j) {image_index=0 hspeed=-1 vspeed=-2} //bottom left
		j = instance_create(x-4,y-4,pDestruction) with (j) {image_index=0 hspeed=1 vspeed=-2} //bottom right
		j = instance_create(x+4,y+4,pDestruction) with (j) {image_index=0 hspeed=-1 vspeed=-4} //top left
		j = instance_create(x+4,y-4,pDestruction) with (j) {image_index=0 hspeed=1 vspeed=-4} //top right
		
		instance_destroy();
	}
}

with (oPlayer) {
	if (distance_to_point(other.x, other.y) < other.radius) {
		sig.Emit("hurt_by_spike");
	}
}

with (oEnemy) {
	if (distance_to_object(other) <= other.radius) {
		enemyFireballed.Emit(id, other);
	}
}