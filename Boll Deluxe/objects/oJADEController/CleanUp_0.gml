ds_map_destroy(obj_data)
ds_list_destroy(obj_name)
	
ds_list_destroy(cat_blocks)
ds_list_destroy(cat_baddies)
ds_list_destroy(cat_items)
ds_list_destroy(cat_tech)
ds_list_destroy(cat_node)
ds_list_destroy(object_list)

var g=0;
repeat(4) {
	ds_list_destroy(object_layer_map[g])
	ds_list_destroy(node_layer_map[g])

	var i=0;
	repeat (array_length(tile_layer[g])) {
		ds_list_destroy(tile_layer_map[g][i])
		i++
	}
	g++;
}

surface_free(object_list_area_surface)
surface_free(GUIcanvas);