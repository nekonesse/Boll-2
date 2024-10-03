#define winmenu_preinit
//#init winmenu_preinit
//#global winmenu_bar_handler
//#global winmenu_system_handler
winmenu_bar_handler = -1;
winmenu_system_handler = -1;
global.__winmenu_target = window_handle();
global.__winmenu_orig_target = window_handle();
global.__winmenu_bar_menus = ds_map_create();
global.__winmenu_sys_menus = ds_map_create();
// GMS >= 1:
global.__ptrt_HMENU = ["HMENU"];
winmenu_preinit_raw(window_handle(), 0);
/*/
winmenu_preinit_raw("", window_handle());
//*/

#define winmenu_cleanup_for
/// (hwnd)
var _hwnd = argument0;
ds_map_delete(global.__winmenu_bar_menus, _hwnd);
ds_map_delete(global.__winmenu_sys_menus, _hwnd);
winmenu_cleanup_for_raw(_hwnd);

#define winmenu_set_target
/// (new_window_handle)
global.__winmenu_target = argument0;

#define winmenu_reset_target
/// ()
global.__winmenu_target = global.__winmenu_orig_target;

#define winmenu_update
/// ()
var _step, _handler, _count;
for (_step = 0; _step < 2; _step += 1) {
    if (_step) {
        _handler = winmenu_system_handler;
    } else {
        _handler = winmenu_bar_handler;
    }
    var _has_handler = _handler != -1;
    // GMS >= 2.3:
    var _is_method = _has_handler && is_method(_handler);
    //*/
    repeat (winmenu_queue_size(_step)) {
        var _cmd = winmenu_queue_pop(_step);
        var _hwnd = winmenu_queue_hwnd();
        // GMS >= 2.3:
        if (_is_method) {
            _handler(_cmd, _hwnd);
        } else // ->
        //*/
        if (_has_handler) {
            script_execute(_handler, _cmd, _hwnd);
        } else {
            var _cmd_str = string(_cmd);
            // GMS >= 1:
            var _cmd_hex;
            if (_cmd != 0) {
                _cmd_hex = string(ptr(_cmd));
                var i = 1;
                repeat (16) {
                    if (string_byte_at(_cmd_hex, i) == ord("0")) {
                        i += 1;
                    } else break;
                }
                if (i > 1) _cmd_hex = string_delete(_cmd_hex, 1, i - 1);
            } else _cmd_hex = "0";
            _cmd_str += " (0x" + _cmd_hex + ")";
            //*/
            if (_step) {
                show_debug_message("[winmenu] System item " + _cmd_str + " was clicked.");
            } else {
                show_debug_message("[winmenu] Item " + _cmd_str + " was clicked.");
            }
        }
    }
}

// GMS >= 1:
#define winmenu_prepare_buffer
/// (size:int)->buffer~
var _size = argument0;
gml_pragma("global", "global.__winmenu_buffer = undefined");
var _buf = global.__winmenu_buffer;
if (_buf == undefined) {
    _buf = buffer_create(_size, buffer_grow, 1);
    global.__winmenu_buffer = _buf;
} else if (buffer_get_size(_buf) < _size) {
    buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;

#define winmenu_prepare_buffer_alt
/// (size:int)->buffer~
var _size = argument0;
gml_pragma("global", "global.__winmenu_buffer_alt = undefined");
var _buf = global.__winmenu_buffer_alt;
if (_buf == undefined) {
    _buf = buffer_create(_size, buffer_grow, 1);
    global.__winmenu_buffer_alt = _buf;
} else if (buffer_get_size(_buf) < _size) {
    buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;
//*/

#define winmenu_bar_get
/// ()->
// GMS >= 1:
var _menu = global.__winmenu_bar_menus[?global.__winmenu_target];
if (_menu == undefined) {
    _menu = winmenu_bar_get_raw();
    global.__winmenu_bar_menus[?global.__winmenu_target] = _menu;
}
return _menu;
/*/
if (ds_map_exists(global.__winmenu_bar_menus, global.__winmenu_target)) {
    return ds_map_find_value(global.__winmenu_bar_menus, global.__winmenu_target);
} else {
    var _bar; _bar = winmenu_bar_get_raw();
    if (_bar != -1) ds_map_add(global.__winmenu_bar_menus, global.__winmenu_target, _bar);
    return _bar;
}
//*/

#define winmenu_bar_set
/// (menu)
var _menu = argument0;
// GMS >= 1:
global.__winmenu_bar_menus[?global.__winmenu_target] = _menu;
/*/
if (ds_map_exists(global.__winmenu_bar_menus, global.__winmenu_target)) {
    ds_map_replace(global.__winmenu_bar_menus, global.__winmenu_target, _menu);
} else {
    ds_map_add(global.__winmenu_bar_menus, global.__winmenu_target, _menu);
}
//*/
winmenu_bar_set_raw(_menu);

#define winmenu_bar_reset
/// ()
var _menu = argument0;
ds_map_delete(global.__winmenu_bar_menus, global.__winmenu_target);
winmenu_bar_reset_raw();

#define winmenu_sysmenu_get
/// (?revert)->
var _revert, _menu;
if (argument_count > 0) _revert = argument[0]; else _revert = false;
if (!_revert) {
    // GMS >= 1:
    _menu = global.__winmenu_sys_menus[?global.__winmenu_target];
    if (_menu != undefined) return _menu;
    /*/
    if (ds_map_exists(global.__winmenu_sys_menus, global.__winmenu_target)) {
        return ds_map_find_value(global.__winmenu_sys_menus, global.__winmenu_target);
    }
    //*/
}
_menu = winmenu_sysmenu_get_raw(_revert);
// GMS >= 1:
global.__winmenu_sys_menus[?global.__winmenu_target] = _menu;
/*/
if (ds_map_exists(global.__winmenu_sys_menus, global.__winmenu_target)) {
    winmenu_deref(ds_map_find_value(global.__winmenu_sys_menus, global.__winmenu_target));
    if (_menu != -1) {
        ds_map_replace(global.__winmenu_sys_menus, global.__winmenu_target, _menu);
    } else {
        ds_map_delete(global.__winmenu_sys_menus, global.__winmenu_target);
    }
}
//*/
return _menu;

#define winmenu_bitmap_create_from_surface
/// (surf)
// GMS >= 1:
var _surf = argument0;
var _width = surface_get_width(_surf);
var _height = surface_get_height(_surf);
var _buf = winmenu_prepare_buffer_alt(_width * _height * 4);
buffer_get_surface(_buf, _surf, 0);
return winmenu_bitmap_create_from_buffer(_buf, _width, _height, true);
/*/
var _temp = "winmenu_tmp.bmp";
surface_save(argument0, _temp);
var _result = winmenu_bitmap_add(_temp);
file_delete(_temp);
return _result;
//*/

#define winmenu_bitmap_create_from_sprite
/// (sprite, subimg)
// GMS >= 1:
var _sprite = argument0, _subimg = argument1;
var _width = sprite_get_width(_sprite);
var _height = sprite_get_height(_sprite);
var _surf = surface_create(_width, _height);
surface_set_target(_surf);
draw_clear_alpha(0, 0);
gpu_set_blendmode(bm_add);
draw_sprite(_sprite, _subimg, sprite_get_xoffset(_sprite), sprite_get_yoffset(_sprite));
gpu_set_blendmode(bm_normal);
surface_reset_target();
var _result = winmenu_bitmap_create_from_surface(_surf);
surface_free(_surf);
return _result;
/*/
var _temp = "winmenu_tmp.bmp";
sprite_save(argument0, argument1, _temp);
var _result = winmenu_bitmap_add(_temp);
file_delete(_temp);
return _result;
//*/
