if !is_array(pathing) {
    if (going!=0) {
        image_index=0
        y+=0.33*(going)
        if instance_exists(parentblock) {
            x+=parentblock.x_diff
            y+=parentblock.y_diff
            if !place_meeting(x,y-1*going,parentblock) {
                going=0
                hsp = 0.75*((nearestplayer().x > x) ? -1 : 1);
            }
        }
    }

    if (going!=0) exit;

    if !grounded {
        vsp = min(vsp+grav,4)
    } else {
        vsp = 0	
    }

    x += hsp;
    y += vsp;

    player_collision()

    if hsp != 0 xsc=-esign(hsp,-1)
} else {
    node_path_movement();
}

if (place_meeting(x,y,oPlayer)) {
    oPlayer.sig.Emit("1up")
    instance_destroy();
}

if place_meeting(x,y,oDeactivationRegion) && !on_screen_xy(sprite_width,sprite_height) {
    instance_destroy();
}
