//Functions for JADE object properties.
//Properties are formatted as a 2d array [[Property Name, Display Name, Default Value, Input Type, Bounds / List of Values]]
//TODO: Probably only save the third value of these to the object and just look up these arrays when changing / loading them lmao

function object_get_properties(obj){
	var properties = [["align", "Align", 0, "number_input", 0]]
	
	switch (asset_get_index(obj)){
		case oItemBox:
			properties = [
				["align", "Align", 0, "number_input", 0],
				["content", "Contents", "coin", "dropdown", ["coin", "multicoin", "mushroom", "fireflower", "thunderflower"]],
				["amount", "Amount", 0, "number_input", 50]
			]
			break;
		default:
			properties = [
				["align", "Align", 0, "number_input", 0]
			]
			break;
	}
	return properties;
}