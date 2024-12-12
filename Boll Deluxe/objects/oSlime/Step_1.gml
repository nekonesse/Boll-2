/// @description eye animation logic
if (!eyes_visible)
{
	return;
}

eye_opentime = max(0, eye_opentime - 1);

if (eye_opentime != 0)
{
    return;
}

if (eye_blinktime == 0)
{		
    if ((irandom(65535) & 0x1f) == 0) // randon number % 32
    {
		eye_blinktime = 4;
    }
    return;
}
	
if ((eye_blinktime & 1) == 0)
{
    // god I wish there was an easier way to truncate
	// Yes I Know Floor Exists, But The Nefarious Negative Number....
	eye_frame = int64(eye_frame - 1) % 3;

    if (eye_frame == 0)
    {
        eye_blinktime--;
    }
}
else
{
    eye_frame = int64(eye_frame + 1) % 3;

    if (eye_frame == 2)
    {
		eye_blinktime--;
    }
}

eye_opentime = 4;