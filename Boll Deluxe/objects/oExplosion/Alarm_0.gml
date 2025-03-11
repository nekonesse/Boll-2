var objectlist = [oBrick, oItemBox, oFlipblock, oHardBlock],       //register objects here
	olistsize = array_length(objectlist);

var i=0;
repeat (olistsize) {
	instance_activate_object(objectlist[i]) //this seems like a really bad idea
	with (objectlist[i]) {
		if (distance_to_point(other.x, other.y) < other.radius) {     
			instance_destroy();                        //destroy object
			//the blocks can handle being destroyed by themselves now
		}
	}
	i++;
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