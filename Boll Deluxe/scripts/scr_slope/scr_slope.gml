/// \file  scr_slope.gml
/// \brief Setup and handling of collision with slopes.

// chearii: YES, slopes need their own collision systems

#macro GAME_DEBUG_NAGGY false

#macro SLOPESENSOR_A 0
#macro SLOPESENSOR_B 1
#macro SLOPESENSOR_C 2

#macro BOTTOMCOLLOFFSET 2
#macro BBOXBTTMOFFSET 0

function instance_make_slopevars(obj)
{
	obj.slope_sensors = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
	obj.slope_colval = 1;
	obj.slope_ydist = 1;
}

function slope_set_rise_run(obj)
{
    var rs, rn;
	rn = (bbox_right - bbox_left);
	rs = (bbox_bottom - bbox_top);
	
	obj.rise = rs;
	obj.run = rn;
	obj.slope_factor = rs/rn;
}

function draw_slope(obj)
{
	var slope_len = (bbox_right - bbox_left) div 1;
	var j = 0;
	var dx = 0;
	
	// according to kaze this is faster
	for (var i = slope_len; i >= 0; i--)
	{
		dx = (bbox_left + j) div 1;
		draw_line(dx, bbox_bottom div 1,dx,(bbox_bottom - (obj.slope_factor * j)) div 1);
		j++;
	}
}

function slope_reset_sensors(obj)
{
	slope_sensors[SLOPESENSOR_A][0] = 0;
	slope_sensors[SLOPESENSOR_A][1] = 0;
	
	slope_sensors[SLOPESENSOR_B][0] = 0;
	slope_sensors[SLOPESENSOR_B][1] = 0;
	
	slope_sensors[SLOPESENSOR_C][0] = 0;
	slope_sensors[SLOPESENSOR_C][1] = 0;
}

function instance_handle_slope_collision(obj)
{
	obj.slope_colval = -1;
	obj.slope_ydist = obj.slope_colval;

	slope_reset_sensors(self);

	var colslope;
	var sensorfound = 0;
	var xdist = 0;
	var bbox_height = (obj.bbox_bottom - obj.bbox_top) div 1;
	var bbottom = (obj.bbox_bottom div 1) - BBOXBTTMOFFSET;
	var bbottom_check = (obj.bbox_bottom div 1) - BOTTOMCOLLOFFSET;

	// this is incredibly messy code but is UNIRONICALLY faster than doing a for loop

	// get data for sensor A
	colslope = instance_position(obj.bbox_left,bbottom_check,oSlopeCollider);
	if (colslope)
	{
		xdist = min(colslope.sprite_width div 1, max(0, obj.bbox_left - colslope.bbox_left));
		obj.slope_sensors[SLOPESENSOR_A][0] = intlib_make_u16(min(0, -((colslope.slope_factor * xdist) + 2) div 1));
	
		// get top and height
		obj.slope_sensors[SLOPESENSOR_A][1] = (intlib_make_u16(colslope.bbox_top) << 16);
		obj.slope_sensors[SLOPESENSOR_A][1] |= intlib_make_u16(colslope.sprite_height);
	
		// get bottom
		obj.slope_sensors[SLOPESENSOR_A][2] = colslope.bbox_bottom;
	}
	else
		obj.slope_sensors[SLOPESENSOR_A][0] = 0x00FF0003; // set "notile" flag
	
	// get data for sensor B
	colslope = instance_position(obj.x,bbottom_check,oSlopeCollider);
	if (colslope)
	{
		xdist = min(colslope.sprite_width div 1, max(0, obj.x - colslope.bbox_left));
		obj.slope_sensors[SLOPESENSOR_B][0] = intlib_make_u16(min(0, -((colslope.slope_factor * xdist) + 2) div 1));
	
		// get top and height
		obj.slope_sensors[SLOPESENSOR_B][1] = (intlib_make_u16(colslope.bbox_top) << 16);
		obj.slope_sensors[SLOPESENSOR_B][1] |= intlib_make_u16(colslope.sprite_height);
	
		// get bottom
		obj.slope_sensors[SLOPESENSOR_B][2] = colslope.bbox_bottom;
	}
	else
		obj.slope_sensors[SLOPESENSOR_B][0] = 0x00FF0003; // set "notile" flag
	
	// get data for sensor C
	colslope = instance_position(obj.bbox_right - 3,bbottom_check,oSlopeCollider);
	
	if (colslope)
	{
		xdist = min(colslope.sprite_width div 1, max(0, (obj.bbox_right - 3) - colslope.bbox_left));
		obj.slope_sensors[SLOPESENSOR_C][0] = intlib_make_u16(min(0, -((colslope.slope_factor * xdist) + 2) div 1));
	
		// get top and height
		obj.slope_sensors[SLOPESENSOR_C][1] = (intlib_make_u16(colslope.bbox_top) << 16);
		obj.slope_sensors[SLOPESENSOR_C][1] |= intlib_make_u16(colslope.sprite_height);
	
		// get bottom
		obj.slope_sensors[SLOPESENSOR_C][2] = colslope.bbox_bottom;
	}
	else
		obj.slope_sensors[SLOPESENSOR_C][0] = 0x00FF0003; // set "notile" flag
	
	// if we find a floor on either end, we've found at least one slope
	// "notile" is on the high row (0x00FF0000) so anything there will invalidate the sensor
	// angle will be stored at the topmost area (0xFF000000)
	if (((obj.slope_sensors[SLOPESENSOR_A][0] & 0xFFFF) && (!(obj.slope_sensors[SLOPESENSOR_A][0] & 0x00FF0000))) ||
	    ((obj.slope_sensors[SLOPESENSOR_B][0] & 0xFFFF) && (!(obj.slope_sensors[SLOPESENSOR_B][0] & 0x00FF0000))) ||
	    ((obj.slope_sensors[SLOPESENSOR_C][0] & 0xFFFF) && (!(obj.slope_sensors[SLOPESENSOR_C][0] & 0x00FF0000))))
	{
	    sensorfound = 1;
	}

	if (sensorfound)
	{	
	
		// make colval the TALLEST of the 3 sensors
		var sensor_a, sensor_b, sensor_c;
		var bottom_a, bottom_b, bottom_c;
		var slopetop = 0, slopeheight = 0;

		sensor_a = intlib_make_s16(obj.slope_sensors[SLOPESENSOR_A][0]);
		sensor_b = intlib_make_s16(obj.slope_sensors[SLOPESENSOR_B][0]);
		sensor_c = intlib_make_s16(obj.slope_sensors[SLOPESENSOR_C][0]);
	
		bottom_a = obj.slope_sensors[SLOPESENSOR_A][2];
		bottom_b = obj.slope_sensors[SLOPESENSOR_B][2];
		bottom_c = obj.slope_sensors[SLOPESENSOR_C][2];

		if ((sensor_a <= 0) || (sensor_b <= 0) || (sensor_c <= 0))
		{
			if (GAME_DEBUG_NAGGY)
			{
				show_debug_message("sensor A:");
			    show_debug_message(sensor_a);
			    show_debug_message("sensor B:");
			    show_debug_message(sensor_b);
			    show_debug_message("sensor C:");
			    show_debug_message(sensor_c);
			}
                
		    // sensor A is higher
		    if (((sensor_a + bottom_a) <= (sensor_b + bottom_b)))
		    {  
		        if (((sensor_a + bottom_a) <= (sensor_c + bottom_c)))
		        {
		            slopeheight = (obj.slope_sensors[SLOPESENSOR_A][1] & 0xFFFF);
					obj.slope_ydist = min(0, bbottom - obj.slope_sensors[SLOPESENSOR_A][2]);
				
					// if you go above the height limit, please do NOT clip up
		            if (sensor_a >= (-slopeheight))
					{
		                obj.slope_colval = sensor_a;
						slopetop = obj.slope_sensors[SLOPESENSOR_A][1] >> 16;
					}
		        }
		        else if (sensor_c <= 0)
		        {
		            slopeheight = (obj.slope_sensors[SLOPESENSOR_C][1] & 0xFFFF);
					obj.slope_ydist = min(0, bbottom - obj.slope_sensors[SLOPESENSOR_C][2]);
				
					if (sensor_c >= (-slopeheight))
					{
		                obj.slope_colval = sensor_c;
						slopetop = obj.slope_sensors[SLOPESENSOR_C][1] >> 16;
					}
		        }
				else
					return false;
		    }
		    else if (((sensor_b + bottom_b) <= (sensor_c + bottom_c))) // sensor B is higher
		    {   
		        slopeheight = (obj.slope_sensors[SLOPESENSOR_B][1] & 0xFFFF);
				obj.slope_ydist = min(0, bbottom - obj.slope_sensors[SLOPESENSOR_B][2]);
			
				if (sensor_b >= (-slopeheight))
				{
		            obj.slope_colval = sensor_b;
					slopetop = obj.slope_sensors[SLOPESENSOR_B][1] >> 16;
				}
		    }
		    else if (sensor_c <= 0) // sensor C is higher
			{
				slopeheight = (obj.slope_sensors[SLOPESENSOR_C][1] & 0xFFFF);
				obj.slope_ydist = min(0, bbottom - obj.slope_sensors[SLOPESENSOR_C][2]);
			
				if (sensor_c >= (-slopeheight))
				{
					obj.slope_colval = sensor_c;
					slopetop = obj.slope_sensors[SLOPESENSOR_C][1] >> 16;
				}
			}
			else
				return false;
			
			if (obj.slope_ydist >= obj.slope_colval)
			{
			    var clipdist = 0;
				
				var bboxvsheight = abs(obj.sprite_height - (abs(obj.bbox_bottom - obj.bbox_top) div 1));
				
				var newy = (( (slopetop - bboxvsheight) + slopeheight + obj.slope_colval) - (bbox_height - (obj.sprite_yoffset + 1)));
				var cliptile = instance_place(obj.x,newy div 1,oCollider);
				
				if (cliptile && (cliptile.cflags & CF_SOLID))
				{
					clipdist = (obj.bbox_bottom - cliptile.bbox_top);
					
					if (clipdist >= 0)
						return false;
				}
				
				
				obj.y_frac = (newy * 256) div 1;
				return true;
			}
		}
	}
	
	return false;
}