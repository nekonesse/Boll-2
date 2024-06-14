obj="";
sprite=spr_collider
xscale=1;
yscale=1;
can_xscale=0;
can_yscale=0;
rot=0;
mode=1;

function get_values(uuid) {
	var arr=ds_map_find_value(oJADEController.obj_data,uuid)
	sprite=arr[0]
	x-=arr[2]
	y-=arr[3]
	image_xscale=arr[4]
	image_yscale=arr[5]
	can_xscale=arr[6]
	can_yscale=arr[7]
}