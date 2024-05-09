#define spritelist
sprite_list=[];
array_push(sprite_list,"stand","wait","lookup","pose","crouch","hurt","dead","walk","run","brake","jump","bonk","fall","runjump","longjump")

#define create
jump = 0;

#define step
player_movement();
player_collision();
//show_debug_message(test[3]);

// polygons!!!!!
// nekonesse: i beg of you turn this into a basic script/function for charm users....

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

// Pipes ??? (works now)
// if (grounded && down && place_meeting(x, y + 4, oPipeUp)) {  
    // with instance_place(x, y + 4, oPipeUp) {
        // if (canenter) {
            // with other {  
                // alarm[3] = 80;
                // piped = 1;
                // vsp = 1.5;
                // hsp = 0;
                // //x_frac = intlib_make_fixedpoint((other.x + (other.sprite_width / 2))) >> FRACBITS;
            // }
            // // sorry about the global variables here but the player object isnt
            // // persistent so im overpreparing for room reloads lol
            // global.exitlocation = target;  
            
            // global.exittype = warptypes.pipe;  
        // }
    // }
// }

coll = instance_place(x, y, oMushroom);

if (coll) {
    oldsize = size;

    if (size < 1)
        size = 1;

    //alarm[11] = 60;
    instance_destroy(coll);
}

#define sprmanager

if (vsp>0) sprite="fall"
else if (jump) sprite="jump"
else if (left || right) sprite="walk"
else sprite="stand"