obj="";
sprite=spr_collider
xscale=1;
yscale=1;
can_xscale=0;
can_yscale=0;
rot=0;
mode=1;
properties_list=[["align", "Align", 0, "number_input", 0]];
properties_value=["no value"]

function get_values(uuid) {
	var arr=ds_map_find_value(oJADEController.obj_data,uuid)
	sprite=arr[0]
	x-=arr[2]
	y-=arr[3]
	image_xscale=arr[4]
	image_yscale=arr[5]
	can_xscale=arr[6]
	can_yscale=arr[7]
	properties_list=arr[9]
	if (properties_value[0] == "no value") {
		for (i = 0; i < array_length(properties_list); i += 1) {
			properties_value[i] = properties_list[i,2]
		}
	}
}