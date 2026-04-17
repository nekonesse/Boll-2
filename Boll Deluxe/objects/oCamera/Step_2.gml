if(instance_exists(follow) && !get_paused()){
	if (follow.object_index == oPlayer) {
		if (follow.dead || follow.finish) exit;
	}
	
	var region = instance_position(follow.x,follow.y,oCameraRegion)
	if (region && target_region != region) {
		target_region = region;
		zoom_me(target_region.zoom,30);
		offset(target_region.nudge_x,target_region.nudge_y,30);
	} else if (!region && target_region!=noone) {
		target_region = noone;
		zoom_me(1,30);
		offset(0,0,30);
	}
	
	//update destination
	__xTo = follow.x;
	__yTo = follow.y;
			
	var _x_dist = __xTo - x;
	var _y_dist = __yTo - y;
	
	if (abs(_x_dist) >= bounds_w) {
		bounds_x_side = sign(_x_dist);
	}
	
	/*if (abs(_y_dist) >= bounds_h) {
		bounds_y_side = sign(_y_dist);
	}*/
	
	bounds_x_move = approach_val(bounds_x_move,bounds_x_max_move*bounds_x_side,bounds_adjust_spd);
	//bounds_y_move = approach_val(bounds_y_move,bounds_y_max_move*bounds_y_side,bounds_adjust_spd);
	
	bounds_dist_w = (max(bounds_w, abs(_x_dist)) - bounds_w) * sign(_x_dist);
	
	bounds_dist_h = (max(bounds_h, abs(_y_dist)) - bounds_h) * sign(_y_dist);
			
	//update camera position
	x += bounds_dist_w * spd;
	y += bounds_dist_h * spd;
	
} else if(__moving){
	//gradually moves camera into position based on duration
	x = stanncam_animcurve(__t, __xStart, __xTo, __duration, anim_curve);
	y = stanncam_animcurve(__t, __yStart, __yTo, __duration, anim_curve);

	__t = min(__t + 1, __duration);
			
	if(__t >= __duration){
		__moving = false;
		x = __xTo;
		y = __yTo;
	}
}

x = floor(x);
y = floor(y);
		
#region zone constrain
if(instance_exists(follow) && !get_paused()){
	if (follow.object_index == oPlayer) {
		if (follow.dead || follow.finish) exit;
	}
			
	var _zone_list = ds_list_create();
	var _zone_count = instance_position_list(follow.x, follow.y, oCameraRegion, _zone_list, false);
	if !(_zone_count) {
		ds_list_destroy(_zone_list);
		_zone_list = noone;
	}
			
	var _active_list = array_last(__zone_lists);
			
	var _active_list_compare = noone;
	if(ds_exists(_active_list, ds_type_list)){
		_active_list_compare = ds_list_write(_active_list);
	}
			
	var _zone_list_compare = noone;
	if(ds_exists(_zone_list, ds_type_list)){
		_zone_list_compare = ds_list_write(_zone_list);
	}
			
	//if entering a new list of zones, it gets added to the zone_lists array. and the previous ones fade out over time
	if(_active_list_compare != _zone_list_compare){
		array_push(__zone_lists_strength, 0);
		array_push(__zone_lists, _zone_list);

		//ensures that the zone lists array has a max size
		if(array_length(__zone_lists) > __zone_lists_max){
			array_shift(__zone_lists_strength);
					
			//if the index being removed is a DS list, destroy it to prevent leaks
			if(ds_exists(__zone_lists[0], ds_type_list)){
				ds_list_destroy(__zone_lists[0]);
			}
			array_shift(__zone_lists);
		}
	}
			
	var _len = array_length(__zone_lists_strength) - 1;
	for (var k = 0; k <= _len; k++) {
		if(k != _len){
			__zone_lists_strength[k] = lerp(__zone_lists_strength[k], 0, __constrain_spd);
		} else {
			__zone_lists_strength[k] = lerp(__zone_lists_strength[k], 1, __constrain_spd);
		}
				
		if(__zone_lists_strength[k] == 0){
			array_delete(__zone_lists_strength, k, 1);
					
			//if the index being removed is a DS list, destroy it to prevent leaks
			if(ds_exists(__zone_lists[k], ds_type_list)){
				ds_list_destroy(__zone_lists[k]);
			}
			array_delete(__zone_lists, k, 1);
					
			_len = array_length(__zone_lists_strength) - 1;
			k--;
		}
	}
}
		
#endregion
		
#region offset
if(__offset){
	//gradually offsets camera based on duration
	offset_x = stanncam_animcurve(__offset_t, __offset_xStart, __offset_xTo, __offset_duration, anim_curve_offset);
	offset_y = stanncam_animcurve(__offset_t, __offset_yStart, __offset_yTo, __offset_duration, anim_curve_offset);
			
	__offset_t = min(__offset_t + 1, __offset_duration);

	if(__offset_t >= __offset_duration){
		__offset = false;
		offset_x = __offset_xTo;
		offset_y = __offset_yTo;
	}
}
#endregion
		
#region screen-shake
var _stanncam_shake_x = stanncam_shake(__shake_time, __shake_magnitude, __shake_length);
var _stanncam_shake_y = stanncam_shake(__shake_time, __shake_magnitude, __shake_length);
__shake_x = _stanncam_shake_x;
__shake_y = _stanncam_shake_y;
__shake_time++;
#endregion
		
#region zooming
if (__zooming) {
	//gradually zooms camera
	zoom_amount = stanncam_animcurve(__t_zoom, __zoomStart, __zoomTo, __zoom_duration, anim_curve_zoom);
				
	__t_zoom = min(__t_zoom + 1, __zoom_duration);

	if (__t_zoom >= __zoom_duration) {
		__zooming = false;
		zoom_amount = __zoomTo;
	}
}
#endregion

update_view_pos();
update_view_size();

with(oBackgroundManager) {
	event_user(0);
}