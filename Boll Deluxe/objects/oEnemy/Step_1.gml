if hp <= 0{
    instance_destroy();
}

if (phaseid) && !check_hitbox_on_hitbox(phaseid,id) phaseid=0