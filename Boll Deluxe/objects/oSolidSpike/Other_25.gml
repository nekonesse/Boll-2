///@description update JADE variables
switch (dir) {
	case "up": image_index=0 break;
	case "down": image_index=1 break;
	case "left": image_index=2 break;
	case "right": image_index=3 break;
	case "none": image_index=4 break;
}
pathprenum=max(pathnum-1,0)