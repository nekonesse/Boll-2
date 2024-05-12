var terrain = instance_place(x+hsp,y,oCollider)
if (terrain && object_get_parent(terrain.object_index) < 0) {
	hsp = 0
	//x = xprevious
}

terrain = instance_place(x,y+8,oSlopeCollider)
if (terrain) {
	var terrainway = sign(terrain.image_yscale)
	for (var i = 0 ; i < 16 ; i++) {
		if place_meeting(x,y,terrain) {
			break;
		}
		y += terrainway
	}
}

terrain = instance_place(x,y,oSlopeCollider)
if (terrain) {
	var terrainway = sign(terrain.image_yscale)
	for (var i = 0 ; i < 16 ; i++) {
		if !place_meeting(x,y,terrain) {
			break;
		}
		y -= terrainway
	}
}

terrain = instance_place(x,y+vsp,oCollider)
if (terrain && (object_index != oSemilider | (terrain.object_index == oSemilider & !place_meeting(x,y,terrain)))) {
	grounded = grounded | (place_meeting(x,y+1,oCollider) && !place_meeting(x,y,oCollider))
	if (grounded || vsp > 0) {vsp = 0}
}