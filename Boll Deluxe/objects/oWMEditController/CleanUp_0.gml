ds_map_destroy(obj_data)
ds_list_destroy(obj_name)
	
ds_list_destroy(cat_blocks)
ds_list_destroy(cat_node)
ds_list_destroy(object_list)

ds_list_destroy(object_layer_map)
ds_list_destroy(node_layer_map)

var i=0;
repeat (array_length(tile_layer)) {
	ds_list_destroy(tile_layer_map[i])
	i++
}

surface_free(object_list_area_surface)