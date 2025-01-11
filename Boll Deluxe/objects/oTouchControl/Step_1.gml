if instance_exists(oCamera) {x=oCamera.x y=oCamera.y}


	if up {keyboard_key_release(vk_up) up-=1} 
	if down {keyboard_key_release(vk_down) down-=1}
	if left {keyboard_key_release(vk_left) left-=1}
	if right {keyboard_key_release(vk_right) right-=1}
	
	if akey {keyboard_key_release(ord("X")) akey-=1} 
