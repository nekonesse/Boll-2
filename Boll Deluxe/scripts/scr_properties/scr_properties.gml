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
		case oRoundedSlope2x2:
		case oRoundedSlope1x1:
			properties = [
				["hflip", "Flip", 0, "checkbox", 0],
				["ramp", "Is Ramp", 0, "checkbox", 0]
			]
			break;
		case oPipe:
			properties = [
				["image_angle", "Rotation Angle", 0, "dropdown", [0, 90, 180, 270]],
				["warpname", "Warp Name:", "", "string_input", 0],
				["warptarget", "Warp Target:", "", "string_input", 0]
			]
			break;
		case oBillBlaster:
			properties = [
				["timer_offset", "Timer Offset", 0, "number_input", 0]
			]
			break;
		case oDirectionChanger:
			properties = [
				["dir", "Direction", 0, "number_input", 0],
				["revdir", "Reverse Direction", 0, "number_input", 0],
				["reverse", "Is Reverse", 0, "checkbox", 0],
				["is_break", "Is Cutoff", 0, "checkbox", 0],
			]
			break;
		case oMovingPlatform:
		case oChainsaw:
		case oAmp:
			properties = [
				["dir", "Starting Direction", 0, "number_input", 0],
				["spd", "Speed", 0, "number_input", 0]
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
		case oDonutBlock:
			properties = [
				["collapsing", "Collapsing", 0, "checkbox", 0]
			]
			break;
		case oSolidSpike:
			properties = [
				["dir", "Direction", "up", "dropdown", ["up", "left", "right", "down", "none"]]
			]
			break;
		case oZapper:
			properties = [
				["dir", "Direction", "right", "dropdown", ["up", "left", "right", "down"]]
			]
			break;
		default:
			properties = [
			]
			break;
	}
	return properties;
}