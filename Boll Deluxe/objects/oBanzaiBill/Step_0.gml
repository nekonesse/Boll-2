var _list = ds_list_create();
var coll = instance_place_list(x, y, oHardBlock, _list, false);

if coll > 0
{
    for (var i = 0; i < coll; i++)
    {
		with(_list[| i]) {
			instance_destroy();
			var j=instance_create(x+4,y+12,pDestruction) with(j){image_index=4 hspeed=-1 vspeed=-2} //bottom left
			var j=instance_create(x+12,y+12,pDestruction) with(j){image_index=4 hspeed=1 vspeed=-2} //bottom right
			var j=instance_create(x+4,y+4,pDestruction) with(j){image_index=4 hspeed=-1 vspeed=-4} //top left
			var j=instance_create(x+12,y+4,pDestruction) with(j){image_index=4 hspeed=1 vspeed=-4} //top right
		}
		VinylPlay(snd_hardblockbreak);
	}
}

ds_list_destroy(_list);

var coll=instance_place(x,y,oCollider)
if (coll) && !(coll.no_collide) && !(coll.semi) && (coll != spawn_object) {
	if on_screen() VinylPlay(snd_enemybigexplode);
	instance_destroy();
}

xsc=esign(-hsp,1)

x += hsp;
y += vsp;
vsp += grav;