// this just makes sure that vsp and hsp actually work while in a pipe lol
if (piped)
{
    //y_frac += intlib_make_fixedpoint(vsp) >> FRACBITS;
    //x_frac += intlib_make_fixedpoint(hsp) >> FRACBITS;
	
	//x = x_frac >> FRACBITS;
	//y = y_frac >> FRACBITS;
    exit
}

// chearii: guessing these are a buncha quickvars
right = input_check("right");
left = input_check("left");
up = input_check("up");
down = input_check("down");
akey = input_check("a");
apress = input_check_pressed("a");
bkey = input_check("b");
bpress = input_check_pressed("b");
ckey = input_check("c");
cpress = input_check_pressed("c");

txr_exec(global.scripts[? $"{charmName}_step"]);