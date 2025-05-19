
if (grab_delay == 0) {
    no_collide = false
}

if grabbed{
    no_collide = true
    bounce = true
    grab_delay = 8
}

if vsp != 0 {
    bounce_speed = vsp
}