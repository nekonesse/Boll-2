node_path_movement();

if !grabbed {
    grab_delay = max(grab_delay--, 0)
    if !grounded { 
        vsp=min(vsp+grav,6);
    }
    
    if grounded {
        if bounce {
            grounded = false
            bounce = false
            hsp = gsp / 2
            vsp = -1
        }
        else {
            if (sign(hsp) = -1){
                hsp = min(0, hsp + 0.1)
            }else{
                hsp = max(0, hsp - 0.1)
            }
 
        }
    } 
    
    x += hsp
    y += vsp

    player_collision()
    
} else {
    grounded = false
}
