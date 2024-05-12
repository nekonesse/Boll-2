if !grounded {exit}
        
//fall
if (!check_collision_line(bbox_left,bbox_bottom,bbox_left,bbox_bottom + 16, COL_BOTTOM) 
and !check_collision_line(bbox_right,bbox_bottom,bbox_right,bbox_bottom + 16, COL_BOTTOM)) {
    grounded = false
    return;
}
        
        
//move down
for (var i = 0; i < 16; ++i) {
    if (!check_collision_dot(bbox_right,bbox_bottom, COL_BOTTOM)
    && !check_collision_dot(bbox_left,bbox_bottom, COL_BOTTOM)) {
        y++
    } else {
        break;    
    }
}
        
//move up
for (var i = 0; i < 16; ++i) {
    if (check_collision_dot(bbox_right,bbox_bottom, COL_BOTTOM)
    || check_collision_dot(bbox_left,bbox_bottom, COL_BOTTOM)) {
        y--
    } else {
        break;    
    }
}