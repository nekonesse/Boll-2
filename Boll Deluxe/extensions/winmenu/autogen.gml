#define winmenu_bitmap_destroy
/// winmenu_bitmap_destroy(bitmap)->bool
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
_box_0.__id__ = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
_box_0[@1] = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
ds_grid_destroy(_box_0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_bitmap_destroy_raw(buffer_get_address(_buf), 8);

#define winmenu_bitmap_deref
/// winmenu_bitmap_deref(bitmap)->bool
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
_box_0.__id__ = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
_box_0[@1] = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
ds_grid_destroy(_box_0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_bitmap_deref_raw(buffer_get_address(_buf), 8);

#define winmenu_bitmap_equals
/// winmenu_bitmap_equals(a, b)->bool
var _buf; _buf = winmenu_prepare_buffer(16);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
var _box_0 = argument1;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
var _box_0 = argument1;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
var _box_0; _box_0 = argument1;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_bitmap_equals_raw(buffer_get_address(_buf), 16);

#define winmenu_bitmap_add
/// winmenu_bitmap_add(fname:string)->
var _buf; _buf = winmenu_prepare_buffer(8);
if (winmenu_bitmap_add_raw(buffer_get_address(_buf), 8, argument0)) {
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HBITMAP(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HBITMAP;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HBITMAP");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_bitmap_create_from_buffer
/// winmenu_bitmap_create_from_buffer(buffer:buffer, width:int, height:int, is_rgba:bool)->
var _buf; _buf = winmenu_prepare_buffer(25);
var _val_0 = argument0;
if (buffer_exists(_val_0)) {
	buffer_write(_buf, buffer_u64, int64(buffer_get_address(_val_0)));
	buffer_write(_buf, buffer_s32, buffer_get_size(_val_0));
	buffer_write(_buf, buffer_s32, buffer_tell(_val_0));
} else {
	buffer_write(_buf, buffer_u64, 0);
	buffer_write(_buf, buffer_s32, 0);
	buffer_write(_buf, buffer_s32, 0);
}
buffer_write(_buf, buffer_s32, argument1);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_bool, argument3);
if (winmenu_bitmap_create_from_buffer_raw(buffer_get_address(_buf), 25)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HBITMAP(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HBITMAP;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HBITMAP");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_set_bitmap
/// winmenu_set_bitmap(menu, item:int, bypos:bool, bitmap)->bool
var _buf; _buf = winmenu_prepare_buffer(21);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
var _box_0 = argument3;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
var _box_0 = argument3;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
var _box_0; _box_0 = argument3;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_set_bitmap_raw(buffer_get_address(_buf), 21);

#define winmenu_set_bitmap_sys
/// winmenu_set_bitmap_sys(menu, item:int, bypos:bool, bitmap_index:int)->bool
var _buf; _buf = winmenu_prepare_buffer(17);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_s32, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_s32, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_s32, argument3);
//*/
return winmenu_set_bitmap_sys_raw(buffer_get_address(_buf), 17);

#define winmenu_reset_bitmap
/// winmenu_reset_bitmap(menu, item:int, bypos:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
return winmenu_reset_bitmap_raw(buffer_get_address(_buf), 13);

#define winmenu_get_bitmap
/// winmenu_get_bitmap(menu, item:int, bypos:bool)->
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_bitmap_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HBITMAP(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HBITMAP;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HBITMAP");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_has_bitmap
/// winmenu_has_bitmap(menu, item:int, bypos:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_has_bitmap_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_get_checkmark_width
/// winmenu_get_checkmark_width()->int
var _buf; _buf = winmenu_prepare_buffer(1);
return winmenu_get_checkmark_width_raw(buffer_get_address(_buf), 1);

#define winmenu_get_checkmark_height
/// winmenu_get_checkmark_height()->int
var _buf; _buf = winmenu_prepare_buffer(1);
return winmenu_get_checkmark_height_raw(buffer_get_address(_buf), 1);

#define winmenu_set_checkmark_bitmaps
/// winmenu_set_checkmark_bitmaps(menu, item:int, bypos:bool, bitmap_unchecked, bitmap_checked)->bool
var _buf; _buf = winmenu_prepare_buffer(29);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
var _box_0 = argument3;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
var _box_0 = argument4;
if (instanceof(_box_0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
var _box_0 = argument3;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
var _box_0 = argument4;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HBITMAP) { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HBITMAP is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
var _box_0; _box_0 = argument3;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
var _box_0; _box_0 = argument4;
if (ds_grid_get(_box_0, 0, 0) != "HBITMAP") { show_error("Expected a HBITMAP, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_set_checkmark_bitmaps_raw(buffer_get_address(_buf), 29);

#define winmenu_reset_checkmark_bitmaps
/// winmenu_reset_checkmark_bitmaps(menu, item:int, bypos:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
return winmenu_reset_checkmark_bitmaps_raw(buffer_get_address(_buf), 13);

#define winmenu_get_checkmark_bitmap
/// winmenu_get_checkmark_bitmap(menu, item:int, bypos:bool, checked:bool)->
var _buf; _buf = winmenu_prepare_buffer(14);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
if (winmenu_get_checkmark_bitmap_raw(buffer_get_address(_buf), 14)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HBITMAP(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HBITMAP;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HBITMAP");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_has_checkmark_bitmap
/// winmenu_has_checkmark_bitmap(menu, item:int, bypos:bool, checked:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(14);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
if (winmenu_has_checkmark_bitmap_raw(buffer_get_address(_buf), 14)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_get_flags
/// winmenu_get_flags(menu, item:int, bypos:bool)->int?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_flags_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_flags
/// winmenu_set_flags(menu, item:int, bypos:bool, flags:int)->bool
var _buf; _buf = winmenu_prepare_buffer(17);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_u32, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_u32, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_u32, argument3);
//*/
return winmenu_set_flags_raw(buffer_get_address(_buf), 17);

#define winmenu_get_submenu
/// winmenu_get_submenu(menu, item:int, bypos:bool)->
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_submenu_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _id_1 = buffer_read(_buf, buffer_u64);
		var _box_1;
		if (_id_1 != 0) {
			_box_1 = new HMENU(_id_1);
		} else _box_1 = undefined;
		_val_0 = _box_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _id_1 = buffer_read(_buf, buffer_u64);
		var _box_1;
		if (_id_1 != 0) {
			_box_1 = array_create(2);
			_box_1[0] = global.__ptrt_HMENU;
			_box_1[1] = _id_1;
		} else _box_1 = undefined;
		_val_0 = _box_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS < 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _id_1; _id_1 = buffer_read(_buf, buffer_u64);
		var _box_1;
		if (_id_1 != 0) {
			_box_1 = ds_grid_create(2, 1);
			ds_grid_set(_box_1, 0, 0, "HMENU");
			ds_grid_set(_box_1, 1, 0, _id_1);
		} else _box_1 = -1;
		_val_0 = _box_1;
	} else _val_0 = -1;
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_set_submenu
/// winmenu_set_submenu(menu, item:int, bypos:bool, submenu)->bool
var _buf; _buf = winmenu_prepare_buffer(21);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
var _box_0 = argument3;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
var _box_0 = argument3;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
var _box_0; _box_0 = argument3;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_set_submenu_raw(buffer_get_address(_buf), 21);

#define winmenu_has_submenu
/// winmenu_has_submenu(menu, item:int, bypos:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_has_submenu_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_get_command
/// winmenu_get_command(menu, index:int)->int?
var _buf; _buf = winmenu_prepare_buffer(12);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
//*/
if (winmenu_get_command_raw(buffer_get_address(_buf), 12)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_command
/// winmenu_set_command(menu, item:int, bypos:bool, new_command:int)->bool
var _buf; _buf = winmenu_prepare_buffer(17);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_u32, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_u32, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_u32, argument3);
//*/
return winmenu_set_command_raw(buffer_get_address(_buf), 17);

#define winmenu_get_text
/// winmenu_get_text(menu, item:int, bypos:bool)->string?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
var __size__; __size__ = winmenu_get_text_raw(buffer_get_address(_buf), 13);
if (__size__ == 0) {
	// GMS >= 1:
	return undefined;
	/*/
	return (0);
	//*/
}
if (buffer_get_size(_buf) < __size__) buffer_resize(_buf, __size__);
// GMS >= 2.3:
buffer_set_used_size(_buf, __size__);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_poke(_buf, __size__ - 1, buffer_u8, 0);
//*/
winmenu_get_text_raw_post(buffer_get_address(_buf), __size__);
buffer_seek(_buf, buffer_seek_start, 0);
// GMS >= 1:
var _val_0;
if (buffer_read(_buf, buffer_bool)) {
	_val_0 = buffer_read(_buf, buffer_string);
} else _val_0 = undefined;
return _val_0;
/*/
var _val_0;
if (buffer_read(_buf, buffer_bool)) {
	_val_0 = buffer_read(_buf, buffer_string);
} else _val_0 = (0);
return _val_0;
//*/

#define winmenu_set_text
/// winmenu_set_text(menu, item:int, bypos:bool, text:string)->bool
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
return winmenu_set_text_raw(buffer_get_address(_buf), 13, argument3);

#define winmenu_get_enabled
/// winmenu_get_enabled(menu, item:int, bypos:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_enabled_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_enabled
/// winmenu_set_enabled(menu, item:int, bypos:bool, enabled:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(14);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
return winmenu_set_enabled_raw(buffer_get_address(_buf), 14);

#define winmenu_get_hilite
/// winmenu_get_hilite(menu, item:int, bypos:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_hilite_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_hilite
/// winmenu_set_hilite(menu, item:int, bypos:bool, hilite:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(22);
// GMS >= 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
return winmenu_set_hilite_raw(buffer_get_address(_buf), 22);

#define winmenu_get_checked
/// winmenu_get_checked(menu, item:int, bypos:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_checked_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_checked
/// winmenu_set_checked(menu, item:int, bypos:bool, checked:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(14);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
return winmenu_set_checked_raw(buffer_get_address(_buf), 14);

#define winmenu_get_radio
/// winmenu_get_radio(menu, item:int, bypos:bool)->bool?
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
if (winmenu_get_radio_raw(buffer_get_address(_buf), 13)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_bool);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_radio
/// winmenu_set_radio(menu, item:int, bypos:bool, show_as_radio:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(14);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
return winmenu_set_radio_raw(buffer_get_address(_buf), 14);

#define winmenu_set_radio_group
/// winmenu_set_radio_group(menu, first:int, last:int, selection:int, bypos:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(21);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_u32, argument2);
buffer_write(_buf, buffer_u32, argument3);
buffer_write(_buf, buffer_bool, argument4);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_u32, argument2);
buffer_write(_buf, buffer_u32, argument3);
buffer_write(_buf, buffer_bool, argument4);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_u32, argument2);
external_call(global.f_winmenu_gmkb_write_u32, argument3);
external_call(global.f_winmenu_gmkb_write_bool, argument4);
//*/
return winmenu_set_radio_group_raw(buffer_get_address(_buf), 21);

#define winmenu_get_item_rect
/// winmenu_get_item_rect(use_hwnd:bool, menu, index:int)->
var _buf; _buf = winmenu_prepare_buffer(21);
// GMS >= 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
buffer_write(_buf, buffer_bool, argument0);
var _box_0 = argument1;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
buffer_write(_buf, buffer_bool, argument0);
var _box_0 = argument1;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument2);
//*/
/* GMS < 1:
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
external_call(global.f_winmenu_gmkb_write_bool, argument0);
var _box_0; _box_0 = argument1;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument2);
//*/
if (winmenu_get_item_rect_raw(buffer_get_address(_buf), 21)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1 = {}; // winmenu_item_rect
		_struct_1.x = buffer_read(_buf, buffer_s32);
		_struct_1.y = buffer_read(_buf, buffer_s32);
		_struct_1.width = buffer_read(_buf, buffer_s32);
		_struct_1.height = buffer_read(_buf, buffer_s32);
		_val_0 = _struct_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1 = array_create(4); // winmenu_item_rect
		_struct_1[0] = buffer_read(_buf, buffer_s32); // x
		_struct_1[1] = buffer_read(_buf, buffer_s32); // y
		_struct_1[2] = buffer_read(_buf, buffer_s32); // width
		_struct_1[3] = buffer_read(_buf, buffer_s32); // height
		_val_0 = _struct_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS < 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1; _struct_1 = ds_map_create(); // winmenu_item_rect
		ds_map_add(_struct_1, "x", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "y", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "width", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "height", buffer_read(_buf, buffer_s32));
		_val_0 = _struct_1;
	} else _val_0 = -1;
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_item_from_point
/// winmenu_item_from_point(use_hwnd:bool, menu, x:int, y:int)->int
var _buf; _buf = winmenu_prepare_buffer(25);
// GMS >= 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
buffer_write(_buf, buffer_bool, argument0);
var _box_0 = argument1;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
buffer_write(_buf, buffer_bool, argument0);
var _box_0 = argument1;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
//*/
/* GMS < 1:
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
external_call(global.f_winmenu_gmkb_write_bool, argument0);
var _box_0; _box_0 = argument1;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_s32, argument2);
external_call(global.f_winmenu_gmkb_write_s32, argument3);
//*/
return winmenu_item_from_point_raw(buffer_get_address(_buf), 25);

#define winmenu_add
/// winmenu_add(menu, command:int, text:string, flags:int = 0)->bool
var _buf; _buf = winmenu_prepare_buffer(17);
// GMS >= 2.3:
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
if (argument_count >= 4) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[3]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
if (argument_count >= 4) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[3]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
if (argument_count >= 4) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[3]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_add_raw(buffer_get_address(_buf), 17, argument[2]);

#define winmenu_add_submenu
/// winmenu_add_submenu(menu, command:int, submenu, text:string, flags:int = 0)->bool
var _buf; _buf = winmenu_prepare_buffer(25);
// GMS >= 2.3:
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
var _box_0 = argument[2];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 5) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[4]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
var _box_0 = argument[2];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 5) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[4]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
var _box_0; _box_0 = argument[2];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
if (argument_count >= 5) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[4]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_add_submenu_raw(buffer_get_address(_buf), 25, argument[3]);

#define winmenu_add_separator
/// winmenu_add_separator(menu, command:int = 0, flags:int = 0)->bool
var _buf; _buf = winmenu_prepare_buffer(18);
// GMS >= 2.3:
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 2) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[1]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 3) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[2]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 2) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[1]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 3) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[2]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
if (argument_count >= 2) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
if (argument_count >= 3) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[2]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_add_separator_raw(buffer_get_address(_buf), 18);

#define winmenu_insert
/// winmenu_insert(menu, item:int, bypos:bool, command:int, text:string, flags:int = 0)->bool
var _buf; _buf = winmenu_prepare_buffer(22);
// GMS >= 2.3:
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
buffer_write(_buf, buffer_bool, argument[2]);
buffer_write(_buf, buffer_u32, argument[3]);
if (argument_count >= 6) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[5]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
buffer_write(_buf, buffer_bool, argument[2]);
buffer_write(_buf, buffer_u32, argument[3]);
if (argument_count >= 6) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[5]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
external_call(global.f_winmenu_gmkb_write_bool, argument[2]);
external_call(global.f_winmenu_gmkb_write_u32, argument[3]);
if (argument_count >= 6) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[5]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_insert_raw(buffer_get_address(_buf), 22, argument[4]);

#define winmenu_insert_submenu
/// winmenu_insert_submenu(menu, item:int, bypos:bool, command:int, submenu, text:string, flags:int = 0)->bool
var _buf; _buf = winmenu_prepare_buffer(30);
// GMS >= 2.3:
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
buffer_write(_buf, buffer_bool, argument[2]);
buffer_write(_buf, buffer_u32, argument[3]);
var _box_0 = argument[4];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 7) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[6]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
buffer_write(_buf, buffer_bool, argument[2]);
buffer_write(_buf, buffer_u32, argument[3]);
var _box_0 = argument[4];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 7) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[6]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
external_call(global.f_winmenu_gmkb_write_bool, argument[2]);
external_call(global.f_winmenu_gmkb_write_u32, argument[3]);
var _box_0; _box_0 = argument[4];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
if (argument_count >= 7) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[6]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_insert_submenu_raw(buffer_get_address(_buf), 30, argument[5]);

#define winmenu_insert_separator
/// winmenu_insert_separator(menu, item:int, bypos:bool, command:int = 0, flags:int = 0)->bool
var _buf; _buf = winmenu_prepare_buffer(23);
// GMS >= 2.3:
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
buffer_write(_buf, buffer_bool, argument[2]);
if (argument_count >= 4) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[3]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 5) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[4]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument[1]);
buffer_write(_buf, buffer_bool, argument[2]);
if (argument_count >= 4) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[3]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 5) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[4]);
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
external_call(global.f_winmenu_gmkb_write_bool, argument[2]);
if (argument_count >= 4) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[3]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
if (argument_count >= 5) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[4]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_insert_separator_raw(buffer_get_address(_buf), 23);

#define winmenu_delete
/// winmenu_delete(menu, item:int, bypos:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
return winmenu_delete_raw(buffer_get_address(_buf), 13);

#define winmenu_delete_rec
/// winmenu_delete_rec(menu, item:int, bypos:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
return winmenu_delete_rec_raw(buffer_get_address(_buf), 13);

#define winmenu_create_bar
/// winmenu_create_bar()->
var _buf; _buf = winmenu_prepare_buffer(8);
if (winmenu_create_bar_raw(buffer_get_address(_buf), 8)) {
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HMENU(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HMENU;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HMENU");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_create_popup
/// winmenu_create_popup()->
var _buf; _buf = winmenu_prepare_buffer(8);
if (winmenu_create_popup_raw(buffer_get_address(_buf), 8)) {
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HMENU(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HMENU;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HMENU");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_destroy
/// winmenu_destroy(menu)->bool
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
_box_0.__id__ = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
_box_0[@1] = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
ds_grid_destroy(_box_0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_destroy_raw(buffer_get_address(_buf), 8);

#define winmenu_get_handle
/// winmenu_get_handle(menu)->int
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
if (winmenu_get_handle_raw(buffer_get_address(_buf), 8)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	return ptr(buffer_read(_buf, buffer_u64));
	/*/
	return buffer_read(_buf, buffer_s32);
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_from_handle
/// winmenu_from_handle(handle:int)->
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, argument0);
/*/
external_call(global.f_winmenu_gmkb_write_s32, argument0);
//*/
if (winmenu_from_handle_raw(buffer_get_address(_buf), 8)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HMENU(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HMENU;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HMENU");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_deref
/// winmenu_deref(menu)->bool
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
_box_0.__id__ = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
_box_0[@1] = 0;
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
ds_grid_destroy(_box_0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_deref_raw(buffer_get_address(_buf), 8);

#define winmenu_handle_is_menu
/// winmenu_handle_is_menu(handle:int)->bool
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, argument0);
/*/
external_call(global.f_winmenu_gmkb_write_s32, argument0);
//*/
return winmenu_handle_is_menu_raw(buffer_get_address(_buf), 8);

#define winmenu_equals
/// winmenu_equals(menu1, menu2)->bool
var _buf; _buf = winmenu_prepare_buffer(16);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
var _box_0 = argument1;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
var _box_0 = argument1;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
var _box_0; _box_0 = argument1;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_equals_raw(buffer_get_address(_buf), 16);

#define winmenu_size
/// winmenu_size(menu)->int
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_size_raw(buffer_get_address(_buf), 8);

#define winmenu_get_default_item
/// winmenu_get_default_item(menu, want_pos:bool, recursive:bool, allow_disabled:bool)->int?
var _buf; _buf = winmenu_prepare_buffer(11);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_bool, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_bool, argument1);
buffer_write(_buf, buffer_bool, argument2);
buffer_write(_buf, buffer_bool, argument3);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_bool, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
external_call(global.f_winmenu_gmkb_write_bool, argument3);
//*/
if (winmenu_get_default_item_raw(buffer_get_address(_buf), 11)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_default_item
/// winmenu_set_default_item(menu, item:int, want_pos:bool)->bool
var _buf; _buf = winmenu_prepare_buffer(13);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
buffer_write(_buf, buffer_bool, argument2);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
external_call(global.f_winmenu_gmkb_write_bool, argument2);
//*/
return winmenu_set_default_item_raw(buffer_get_address(_buf), 13);

#define winmenu_get_max_height
/// winmenu_get_max_height(menu)->int?
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
if (winmenu_get_max_height_raw(buffer_get_address(_buf), 8)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_u32);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_set_max_height
/// winmenu_set_max_height(menu, max_height:int)->bool
var _buf; _buf = winmenu_prepare_buffer(12);
// GMS >= 2.3:
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
//*/
/* GMS >= 1 && GMS < 2.3:
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_u32, argument1);
//*/
/* GMS < 1:
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_u32, argument1);
//*/
return winmenu_set_max_height_raw(buffer_get_address(_buf), 12);

#define winmenu_show_popup
/// winmenu_show_popup(menu, flags:int = 0, ?x:int?, ?y:int?)->int
var _buf; _buf = winmenu_prepare_buffer(33);
// GMS >= 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 2) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[1]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 3) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[2];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 4) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[3];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
if (argument_count >= 2) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[1]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 3) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[2];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 4) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[3];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
if (argument_count >= 2) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[1]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
if (argument_count >= 3) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	var _val_0; _val_0 = argument[2];
	var _flag_0; _flag_0 = is_real(_val_0);
	external_call(global.f_winmenu_gmkb_write_bool, _flag_0);
	if (_flag_0) {
		external_call(global.f_winmenu_gmkb_write_s32, _val_0);
	}
} else external_call(global.f_winmenu_gmkb_write_bool, false);
if (argument_count >= 4) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	var _val_0; _val_0 = argument[3];
	var _flag_0; _flag_0 = is_real(_val_0);
	external_call(global.f_winmenu_gmkb_write_bool, _flag_0);
	if (_flag_0) {
		external_call(global.f_winmenu_gmkb_write_s32, _val_0);
	}
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_show_popup_raw(buffer_get_address(_buf), 33);

#define winmenu_show_popup_outside
/// winmenu_show_popup_outside(menu, exclude_x:int, exclude_y:int, exclude_width:int, exclude_height:int, flags:int = 0, ?x:int?, ?y:int?)->int
var _buf; _buf = winmenu_prepare_buffer(49);
// GMS >= 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument[0];
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_s32, argument[1]);
buffer_write(_buf, buffer_s32, argument[2]);
buffer_write(_buf, buffer_s32, argument[3]);
buffer_write(_buf, buffer_s32, argument[4]);
if (argument_count >= 6) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[5]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 7) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[6];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 8) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[7];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument[0];
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
buffer_write(_buf, buffer_s32, argument[1]);
buffer_write(_buf, buffer_s32, argument[2]);
buffer_write(_buf, buffer_s32, argument[3]);
buffer_write(_buf, buffer_s32, argument[4]);
if (argument_count >= 6) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_u32, argument[5]);
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 7) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[6];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
if (argument_count >= 8) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[7];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_s32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
//*/
/* GMS < 1:
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
var _box_0; _box_0 = argument[0];
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
external_call(global.f_winmenu_gmkb_write_s32, argument[1]);
external_call(global.f_winmenu_gmkb_write_s32, argument[2]);
external_call(global.f_winmenu_gmkb_write_s32, argument[3]);
external_call(global.f_winmenu_gmkb_write_s32, argument[4]);
if (argument_count >= 6) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	external_call(global.f_winmenu_gmkb_write_u32, argument[5]);
} else external_call(global.f_winmenu_gmkb_write_bool, false);
if (argument_count >= 7) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	var _val_0; _val_0 = argument[6];
	var _flag_0; _flag_0 = is_real(_val_0);
	external_call(global.f_winmenu_gmkb_write_bool, _flag_0);
	if (_flag_0) {
		external_call(global.f_winmenu_gmkb_write_s32, _val_0);
	}
} else external_call(global.f_winmenu_gmkb_write_bool, false);
if (argument_count >= 8) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	var _val_0; _val_0 = argument[7];
	var _flag_0; _flag_0 = is_real(_val_0);
	external_call(global.f_winmenu_gmkb_write_bool, _flag_0);
	if (_flag_0) {
		external_call(global.f_winmenu_gmkb_write_s32, _val_0);
	}
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
return winmenu_show_popup_outside_raw(buffer_get_address(_buf), 49);

#define winmenu_cleanup_for_raw
/// winmenu_cleanup_for_raw(_hwnd:int) ~
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, argument0);
/*/
external_call(global.f_winmenu_gmkb_write_s32, argument0);
//*/
winmenu_cleanup_for_raw_raw(buffer_get_address(_buf), 8);

#define winmenu_queue_hwnd
/// winmenu_queue_hwnd()->int ~
var _buf; _buf = winmenu_prepare_buffer(8);
if (winmenu_queue_hwnd_raw(buffer_get_address(_buf), 8)) {
	// GMS >= 1:
	return ptr(buffer_read(_buf, buffer_u64));
	/*/
	return buffer_read(_buf, buffer_s32);
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_bar_get_raw
/// winmenu_bar_get_raw()-> ~
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
//*/
if (winmenu_bar_get_raw_raw(buffer_get_address(_buf), 8)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HMENU(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HMENU;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HMENU");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_bar_set_raw
/// winmenu_bar_set_raw(menu)->bool ~
var _buf; _buf = winmenu_prepare_buffer(16);
// GMS >= 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument0;
if (instanceof(_box_0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0.__id__;
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS >= 1 && GMS < 2.3:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
var _box_0 = argument0;
if (!is_array(_box_0) || _box_0[0] != global.__ptrt_HMENU) { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0 = _box_0[1];
if (_id_0 == 0) { show_error("This HMENU is destroyed.", true); exit; }
buffer_write(_buf, buffer_u64, _id_0);
//*/
/* GMS < 1:
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
var _box_0; _box_0 = argument0;
if (ds_grid_get(_box_0, 0, 0) != "HMENU") { show_error("Expected a HMENU, got " + string(_box_0), true); exit }
var _id_0; _id_0 = ds_grid_get(_box_0, 1, 0);
external_call(global.f_winmenu_gmkb_write_ptr, _id_0);
//*/
return winmenu_bar_set_raw_raw(buffer_get_address(_buf), 16);

#define winmenu_bar_reset_raw
/// winmenu_bar_reset_raw()->bool ~
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
//*/
return winmenu_bar_reset_raw_raw(buffer_get_address(_buf), 8);

#define winmenu_bar_redraw
/// winmenu_bar_redraw()->bool
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
//*/
return winmenu_bar_redraw_raw(buffer_get_address(_buf), 8);

#define winmenu_bar_get_info
/// winmenu_bar_get_info(?index:int?)->
var _buf; _buf = winmenu_prepare_buffer(21);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
if (argument_count >= 1) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[0];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_u32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
if (argument_count >= 1) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	var _val_0; _val_0 = argument[0];
	var _flag_0; _flag_0 = is_real(_val_0);
	external_call(global.f_winmenu_gmkb_write_bool, _flag_0);
	if (_flag_0) {
		external_call(global.f_winmenu_gmkb_write_u32, _val_0);
	}
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
if (winmenu_bar_get_info_raw(buffer_get_address(_buf), 21)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1 = {}; // wm_bar_info
		_struct_1.x = buffer_read(_buf, buffer_s32);
		_struct_1.y = buffer_read(_buf, buffer_s32);
		_struct_1.width = buffer_read(_buf, buffer_s32);
		_struct_1.height = buffer_read(_buf, buffer_s32);
		_struct_1.flags = buffer_read(_buf, buffer_s32);
		_val_0 = _struct_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1 = array_create(5); // wm_bar_info
		_struct_1[0] = buffer_read(_buf, buffer_s32); // x
		_struct_1[1] = buffer_read(_buf, buffer_s32); // y
		_struct_1[2] = buffer_read(_buf, buffer_s32); // width
		_struct_1[3] = buffer_read(_buf, buffer_s32); // height
		_struct_1[4] = buffer_read(_buf, buffer_s32); // flags
		_val_0 = _struct_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS < 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1; _struct_1 = ds_map_create(); // wm_bar_info
		ds_map_add(_struct_1, "x", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "y", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "width", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "height", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "flags", buffer_read(_buf, buffer_s32));
		_val_0 = _struct_1;
	} else _val_0 = -1;
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_bar_get_height
/// winmenu_bar_get_height()->int?
var _buf; _buf = winmenu_prepare_buffer(8);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
//*/
if (winmenu_bar_get_height_raw(buffer_get_address(_buf), 8)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_s32);
	} else _val_0 = undefined;
	return _val_0;
	/*/
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		_val_0 = buffer_read(_buf, buffer_s32);
	} else _val_0 = "";
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return "";
	//*/
}

#define winmenu_sysmenu_get_raw
/// winmenu_sysmenu_get_raw(revert:bool)-> ~
var _buf; _buf = winmenu_prepare_buffer(9);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
buffer_write(_buf, buffer_bool, argument0);
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
external_call(global.f_winmenu_gmkb_write_bool, argument0);
//*/
if (winmenu_sysmenu_get_raw_raw(buffer_get_address(_buf), 9)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = new HMENU(_id_0);
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = array_create(2);
		_box_0[0] = global.__ptrt_HMENU;
		_box_0[1] = _id_0;
	} else _box_0 = undefined;
	return _box_0;
	//*/
	/* GMS < 1:
	var _id_0; _id_0 = buffer_read(_buf, buffer_u64);
	var _box_0;
	if (_id_0 != 0) {
		_box_0 = ds_grid_create(2, 1);
		ds_grid_set(_box_0, 0, 0, "HMENU");
		ds_grid_set(_box_0, 1, 0, _id_0);
	} else _box_0 = -1;
	return _box_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

#define winmenu_sysmenu_get_info
/// winmenu_sysmenu_get_info(?index:int?)->
var _buf; _buf = winmenu_prepare_buffer(21);
// GMS >= 1:
buffer_write(_buf, buffer_u64, int64(global.__winmenu_target));
if (argument_count >= 1) {
	buffer_write(_buf, buffer_bool, true);
	var _val_0 = argument[0];
	var _flag_0 = _val_0 != undefined;
	buffer_write(_buf, buffer_bool, _flag_0);
	if (_flag_0) {
		buffer_write(_buf, buffer_u32, _val_0);
	}
} else buffer_write(_buf, buffer_bool, false);
/*/
external_call(global.f_winmenu_gmkb_write_ptr, global.__winmenu_target);
if (argument_count >= 1) {
	external_call(global.f_winmenu_gmkb_write_bool, true);
	var _val_0; _val_0 = argument[0];
	var _flag_0; _flag_0 = is_real(_val_0);
	external_call(global.f_winmenu_gmkb_write_bool, _flag_0);
	if (_flag_0) {
		external_call(global.f_winmenu_gmkb_write_u32, _val_0);
	}
} else external_call(global.f_winmenu_gmkb_write_bool, false);
//*/
if (winmenu_sysmenu_get_info_raw(buffer_get_address(_buf), 21)) {
	buffer_seek(_buf, buffer_seek_start, 0);
	// GMS >= 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1 = {}; // wm_bar_info
		_struct_1.x = buffer_read(_buf, buffer_s32);
		_struct_1.y = buffer_read(_buf, buffer_s32);
		_struct_1.width = buffer_read(_buf, buffer_s32);
		_struct_1.height = buffer_read(_buf, buffer_s32);
		_struct_1.flags = buffer_read(_buf, buffer_s32);
		_val_0 = _struct_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS >= 1 && GMS < 2.3:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1 = array_create(5); // wm_bar_info
		_struct_1[0] = buffer_read(_buf, buffer_s32); // x
		_struct_1[1] = buffer_read(_buf, buffer_s32); // y
		_struct_1[2] = buffer_read(_buf, buffer_s32); // width
		_struct_1[3] = buffer_read(_buf, buffer_s32); // height
		_struct_1[4] = buffer_read(_buf, buffer_s32); // flags
		_val_0 = _struct_1;
	} else _val_0 = undefined;
	return _val_0;
	//*/
	/* GMS < 1:
	var _val_0;
	if (buffer_read(_buf, buffer_bool)) {
		var _struct_1; _struct_1 = ds_map_create(); // wm_bar_info
		ds_map_add(_struct_1, "x", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "y", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "width", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "height", buffer_read(_buf, buffer_s32));
		ds_map_add(_struct_1, "flags", buffer_read(_buf, buffer_s32));
		_val_0 = _struct_1;
	} else _val_0 = -1;
	return _val_0;
	//*/
} else {
	// GMS >= 1:
	return undefined;
	/*/
	return -1;
	//*/
}

