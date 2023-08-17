#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
var img;
img=get_open_filename("PNG|*.png", "")
if img != ""
{
    var is_transparent;
    global.bgcount+=1
    if string_pos("-t",img) != 0
    is_transparent=true;
    else
    is_transparent=false;

    global.bgimages[global.bgcount] = background_add(img,is_transparent,false);
}
