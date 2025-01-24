var _list = ds_list_create();
var coll = instance_place_list(x, y, [oHardBlock, oBrick, oItemBox, oFlipblock, oShootBlock], _list, false);

if (coll > 0) {
	var j=noone,i=0;
	while (i < coll) {
		with(_list[| i]) {
			instance_destroy();
		}
		i += 1
	}
}

ds_list_destroy(_list);

coll=instance_place(x,y,oCollider)
if (coll) && !(coll.no_collide) && !(coll.semi) && (coll != spawn_object) {
	with instance_create(x,y,oExplosion) {
		huge = true;
	}
	instance_destroy();
}

xsc=esign(-hsp,1)

x += hsp;
y += vsp;
vsp += grav;