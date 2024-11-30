var camx=camera_get_view_x(view_camera[0])-16
var camy=camera_get_view_y(view_camera[0])-16
var camwidth=camera_get_view_width(view_camera[0])+16
var camheight=camera_get_view_height(view_camera[0])+16
for (var i = 0; i < ds_list_size(objectNodesList); ++i) {
	var pathing=objectNodesList[| i][0]
	var length=array_length(pathing);
	var xoff=objectNodesList[| i][3];
	var yoff=objectNodesList[| i][4];
	if is_array(pathing) && length > 1 {
		for (var j = 0; j < length-1; ++j) {
		    var arr=pathing[j+1]
			var arr2=pathing[j]
			if point_in_rectangle(arr[0]+8-xoff,arr[1]+8-yoff,camx,camy,camx+camwidth,camy+camheight) || point_in_rectangle(arr2[0]+8-xoff,arr2[1]+8-xoff,camx,camy,camx+camwidth,camy+camheight) {
				var ysc=(point_direction(arr[0]+8-xoff,arr[1]+8-yoff,arr2[0]+8-xoff,arr2[1]+8-yoff) >= 180) ? -1 : 1
				draw_sprite_ext(spr_track,0,arr[0]+8-xoff,arr[1]+8-yoff,point_distance(arr[0],arr[1],arr2[0],arr2[1]),ysc,point_direction(arr[0],arr[1],arr2[0],arr2[1]),c_white,1);
			} else continue
		}
		
		if (objectNodesList[| i][1]) {
			if !(objectNodesList[| i][2]) && point_in_rectangle(pathing[length-1][0]+8-xoff,pathing[length-1][1]+8-yoff,camx,camy,camx+camwidth,camy+camheight) {
				draw_sprite(spr_trackstop,0,pathing[length-1][0]+8-xoff,pathing[length-1][1]+8-yoff)
			}
			if point_in_rectangle(pathing[0][0]+8-xoff,pathing[0][1]+8-yoff,camx,camy,camx+camwidth,camy+camheight) {
				draw_sprite(spr_trackstop,0,pathing[0][0]+8-xoff,pathing[0][1]+8-yoff)
			}
		} else {
			if !(objectNodesList[| i][2]) {
				var arr=pathing[length-1]
				var arr2=pathing[0]
				if point_in_rectangle(arr[0]+8-xoff,arr[1]+8-yoff,camx,camy,camx+camwidth,camy+camheight) || point_in_rectangle(arr2[0],arr2[1],camx,camy,camx+camwidth,camy+camheight) {
					var ysc=(point_direction(arr[0],arr[1],arr2[0],arr2[1]) >= 180) ? -1 : 1
					draw_sprite_ext(spr_track,0,arr[0]+8-xoff,arr[1]+8-yoff,point_distance(arr[0],arr[1],arr2[0],arr2[1]),ysc,point_direction(arr[0],arr[1],arr2[0],arr2[1]),c_white,1);
				}
			}
			if (objectNodesList[| i][2]) && point_in_rectangle(pathing[0][0]+8-xoff,pathing[0][1]+8-yoff,camx,camy,camx+camwidth,camy+camheight) {
				draw_sprite(spr_trackstop,0,pathing[0][0]+8-xoff,pathing[0][1]+8-yoff)
			}
		}
	}
}