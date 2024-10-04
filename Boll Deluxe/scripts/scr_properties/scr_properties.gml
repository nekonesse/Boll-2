//Functions for JADE object properties.
//Properties are formatted as a 2d array [[Property Name, Display Name, Default Value, Input Type, Bounds / List of Values]]
//TODO: Probably only save the third value of these to the object and just look up these arrays when changing / loading them lmao

function object_get_properties(obj){
	var properties = []
	
	switch (asset_get_index(obj)){
		case oItemBox:
			properties = [
				["content", "Contents", "coin", "dropdown", ["coin", "multicoins", "mushroom", "fireflower", "thunderflower"]],
				["amount", "Amount", 1, "number_input", 50],
				["bricked", "Is Brick", 0, "checkbox", 0]
			]
			break;
		default:
			properties = [
			]
			break;
	}
	return properties;
}