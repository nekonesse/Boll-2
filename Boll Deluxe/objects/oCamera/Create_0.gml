width = RESOLUTION_X;
height = RESOLUTION_Y;
	
//offset the camera from whatever it's looking at
offset_x = 0;
offset_y = 0;
	
follow = noone;

spd = 1; //how fast the camera follows an instance from 0-1
	
//the camera bounding box, for the followed instance to leave before the camera starts moving
bounds_w = CAM_SENSOR_WIDTH;
bounds_h = CAM_SENSOR_HEIGHT;
bounds_dist_w = 0;
bounds_dist_h = 0;

target_region = noone;

bounds_x_side = -1;
bounds_x_max_move = CAM_SENSOR_WIDTH;
bounds_x_move = bounds_x_max_move*bounds_x_side;
bounds_y_side = 0;
bounds_y_max_move = CAM_SENSOR_HEIGHT/2;
bounds_y_move = -8 //bounds_y_max_move*bounds_y_side;

bounds_adjust_spd = 4;
	
//which animation curve to use for moving/zooming the camera
anim_curve = stanncam_ac_ease;
anim_curve_zoom = stanncam_ac_ease;
anim_curve_size = stanncam_ac_ease;
anim_curve_offset = stanncam_ac_ease;
	
//zone constrain
//last list added to array the active list of zones
__zone_lists_max = 4;
__zone_lists = [noone]; //noone means no list of zones, ie, not constrained
	
//how much strength each list of zones have
//previous ones gradually fall to 0 and then get removed
__zone_lists_strength = [1];
	
__constrain_offset_x = 0;
__constrain_offset_y = 0;
	
__constrain_frac_x = 0;
__constrain_frac_y = 0;
	
__constrain_spd = 0.1;
	
paused = false;
	
#region animation variables	
//moving
__moving = false;
__xStart = x;
__yStart = y;
__xTo = x;
__yTo = y;
__duration = 0;
__t = 0;
	
//width & height
__size_change = false;
__wStart = width;
__hStart = height;
__wTo = width;
__hTo = height;
__dimen_duration = 0;
__dimen_t = 0;
	
//offset
__offset = false;
__offset_xStart = 0;
__offset_yStart = 0;
__offset_xTo = 0;
__offset_yTo = 0;
__offset_duration = 0;
__offset_t = 0;
	
//zoom
zoom_amount = 1;
	
__zooming = false;
__t_zoom = 0;
__zoomStart = 0;
__zoomTo = 0;
__zoom_duration = 0;
	
//screen shake
__shake_length = 0;
__shake_magnitude = 0;
__shake_time = 0;
__shake_x = 0;
__shake_y = 0;
#endregion

move = function(_x, _y, _duration=0){
	if(_duration == 0 && follow == noone){
		//view position is updated immediately
		x = _x;
		y = _y;
        __moving = false;
		update_view_pos();
	} else {
		__moving = true;
		__t = 0;
		__xStart = x;
		__yStart = y;
			
		__xTo = _x;
		__yTo = _y;
		__duration = _duration;
	}
}

update_view_size = function(_force=false) {
	//if zooming out the surface is scaled up
	var _zoom = ceil(zoom_amount);
	var _new_width = width * _zoom;
	var _new_height = height * _zoom;
		
	//only runs if the size has changed (unless forced, used by __check_viewports to initialize)
	if(_force || width != _new_width || height != _new_height) {
		camera_set_view_size(view_camera[0], _new_width, _new_height);
	}
}
	
update_view_pos = function() {
	//update camera view
	var _new_x = x + bounds_x_move + offset_x - (width / 2) + __shake_x;
	var _new_y = y + bounds_y_move + offset_y - (height / 2) + __shake_y;
		
	var _zoom_whole = ceil(zoom_amount - 1);
	_new_x -= (width / 2) * _zoom_whole;
	_new_y -= (height / 2) * _zoom_whole;
		
	//round to nearest 0.01 decimal
	_new_x = floor(_new_x / 0.01 + 0.99) * 0.01;
	_new_y = floor(_new_y / 0.01 + 0.99) * 0.01;
	
	#region constraining
		
	var _constrain_offset_x = array_create(array_length(__zone_lists), 0);
	var _constrain_offset_y = array_create(array_length(__zone_lists), 0);
		
	var _view_left    = view_to_room_x(0) + 1;
	var _view_right   = view_to_room_x(width) + 1;
	var _view_top     = view_to_room_y(0) + 1;
	var _view_bottom  = view_to_room_y(height) + 1;
		
	_view_left += offset_x + bounds_x_move;
	_view_right += offset_x + bounds_x_move;
	_view_top += offset_y + bounds_y_move;
	_view_bottom += offset_y + bounds_y_move;
	
	_view_left = _view_left;
	_view_right = _view_right;
	_view_top = _view_top;
	_view_bottom = _view_bottom;
	
	//zone constricting
	for (var l = 0; l < array_length(__zone_lists); l++) {
			
		if(__zone_lists[l] != noone){
				
			var _zone_left   = undefined;
			var _zone_right  = undefined;
			var _zone_top    = undefined;
			var _zone_bottom = undefined;
				
			//needs to loop through every zone & room bounds, to find narrowest relative to camera position
			// eg zone.right zone.left ect
				
			for (var z = 0; z < ds_list_size(__zone_lists[l]); z++) {
				var _zone = __zone_lists[l][| z];
					
				if(_zone.left ){ // if dist from the zone edge to the center is shorter than previous it takes over
					if(_zone_left == undefined || _zone.bbox_left < _zone_left){
						_zone_left = _zone.bbox_left;
					}
				}
				if(_zone.right){
					if(_zone_right == undefined || _zone.bbox_right > _zone_right){
						_zone_right = _zone.bbox_right;
					}
				}
				if(_zone.top){
					if(_zone_top == undefined || _zone.bbox_top < _zone_top){
						_zone_top = _zone.bbox_top;
					}
				}
				if(_zone.bottom){
					if(_zone_bottom == undefined || _zone.bbox_bottom > _zone_bottom){
						_zone_bottom = _zone.bbox_bottom;
					}
				}
			}
				
			//Constrains camera to zones/room bounds
				
			#region horizontal constraint
			var _zone_center_h = false;
			if(_zone_left != undefined && _zone_right != undefined){
				//if width of zone is narrower than width of camera, constrain to center
				var _zone_width = (_zone_right - _zone_left);
				if((_view_right - _view_left) > _zone_width){
					var _middle = ((_zone_left + _zone_right) / 2) - 1;
					_constrain_offset_x[l] = _middle - x - offset_x - bounds_x_move;
					_zone_center_h = true;
				}
			}
				
			if(!_zone_center_h && (_zone_left != undefined || _zone_right != undefined)){
				if(_zone_left != undefined){ //left zone
					_constrain_offset_x[l] -= min(_view_left - _zone_left, 0);
				}
					
				if(_zone_right != undefined){ //right zone
					_constrain_offset_x[l] -= max(_view_right - _zone_right, 0);
				}
			}
				
			#endregion
				
			#region vertical constraint
			var _zone_center_v = false;
			if(_zone_top != undefined && _zone_bottom != undefined){
				//if height of zone is narrower than height of camera, constrain to center
				var _zone_height = (_zone_bottom - _zone_top);
				if((_view_bottom - _view_top) > _zone_height){
					var _middle = ((_zone_top + _zone_bottom) / 2) - 1;
					_constrain_offset_y[l] = _middle - y - offset_y - bounds_y_move;
					_zone_center_v = true;
				}
			}
				
			if(!_zone_center_v && (_zone_top != undefined || _zone_bottom != undefined)){
				if(_zone_top != undefined){ //top zone
					_constrain_offset_y[l] -= min(_view_top - _zone_top, 0);
				}
					
				if(_zone_bottom != undefined){ //bottom zone
					_constrain_offset_y[l] -= max(_view_bottom - _zone_bottom , 0);
				}
			}
			#endregion
		}
	}
		
	__constrain_offset_x = 0;
	__constrain_offset_y = 0;
		
	for (var i = 0; i < array_length(__zone_lists_strength); i++) {
		var _offset_x = _constrain_offset_x[i] * __zone_lists_strength[i];
		var _offset_y = _constrain_offset_y[i] * __zone_lists_strength[i];
			
		//with smooth draw on, it rounds the constraint transition
		if(__zone_lists_strength[i] < 0.999){
			_offset_x = round(_offset_x);
			_offset_y = round(_offset_y);
		}
		__constrain_offset_x += _offset_x;
		__constrain_offset_y += _offset_y;
	}
		
	//Horizontal
	__constrain_offset_x = clamp(__constrain_offset_x, -_view_left, room_width - _view_right);
			
	//Vertical
	__constrain_offset_y = clamp(__constrain_offset_y, -_view_top, room_height - _view_bottom);
		
	_new_x += __constrain_offset_x;
	_new_y += __constrain_offset_y;
	
	#endregion
		
	camera_set_view_pos(view_camera[0], floor(_new_x), floor(_new_y));
}
	
room_to_view_x = function(_x) {
	var _zoom = __get_zoom();
	var _zoom_offset = (width * (1 - _zoom)) / 2;
		
	_x -= _zoom_offset + (x - width / 2) - 1;
	_x /= _zoom;
		
	return _x;
}

view_to_room_x = function(_x) {
	var _zoom = __get_zoom();
	var _zoom_offset = (width * (1 - _zoom)) / 2;
		
	_x *= _zoom;
	_x += _zoom_offset + (x - width / 2) - 1;
		
	return _x;
}

room_to_view_y = function(_y) {
	var _zoom = __get_zoom();
	var _zoom_offset = (height * (1 - _zoom)) / 2;
		
	_y -= _zoom_offset + (y - height / 2) - 1;
	_y /= _zoom;
		
	return _y;
}

view_to_room_y = function(_y) {
	var _zoom = __get_zoom();
	var _zoom_offset = (height * (1 - _zoom)) / 2;
		
	_y *= _zoom;
	_y += _zoom_offset + (y - height / 2) - 1;
		
	return _y;
}

__get_zoom = function() {
	return zoom_amount;
}

offset = function(_offset_x, _offset_y, _duration=0){
	if(_duration == 0){ //if duration is 0 the view is updated immediately
		offset_x = _offset_x;
		offset_y = _offset_y;
		update_view_pos();
	} else {
		__offset = true;
		__offset_t = 0;
		__offset_xStart = offset_x;
		__offset_yStart = offset_y;
			
		__offset_xTo = _offset_x;
		__offset_yTo = _offset_y;
		__offset_duration = _duration;
	}
}

zoom_me = function(_zoom, _duration=0) {
	if(_duration == 0){ //if duration is 0 the view is updated immediately
		zoom_amount = _zoom;
			
		if(!get_paused()){
			update_view_size();
		}
	} else {
		__zooming = true;
		__t_zoom = 0;
		__zoomStart = zoom_amount;
		__zoomTo = _zoom;
		__zoom_duration = _duration;
	}
}

set_paused = function(_paused){
	paused = _paused;
}
	
get_paused = function(){
	return paused;
}
	
toggle_paused = function(){
	set_paused(!get_paused());
}

shake_screen = function(_magnitude, _duration){
	__shake_magnitude = _magnitude;
	__shake_length = _duration;
	__shake_time = 0;
}