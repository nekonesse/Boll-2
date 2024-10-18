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
		case oSemiSlope:
		case oSlopeCollider:
			properties = [
				["hflip", "Flip", 0, "checkbox", 0],
				["ramp", "Is Ramp", 0, "checkbox", 0]
			]
			break;
		case oPipe:
			properties = [
				["hflip", "Flip", 0, "checkbox", 0],
				["ramp", "Is Ramp", 0, "checkbox", 0]
			]
			break;
		case oBillBlaster:
			properties = [
				["timer_offset", "Timer Offset", 0, "numer_input", 0]
			]
			break;
		case oDirectionChanger:
		case oMovingPlatform:
		case oChainsaw:
			properties = [
				["dir", "Direction", "right", "dropdown", ["up", "left", "right", "down"]]
			]
			break;
		case oSwingingPlatform:
			properties = [
				["chain_length", "Chain Length", 4, "number_input", 0],
				["start_angle", "Start Angle", 0, "number_input", 0],
				["end_angle", "End Angle", 180, "number_input", 0],
				["offset_angle", "Offset Angle", 0, "number_input", 0],
				["swing_speed", "Swing Speed", 4, "number_input", 0],
				["reverse", "Reverse", 0, "checkbox", 0],
				["continuous", "Continuous", 0, "checkbox", 0],
				["is_blue", "Weighted", 0, "checkbox", 0]
			]
			break;
		default:
			properties = [
			]
			break;
	}
	return properties;
}