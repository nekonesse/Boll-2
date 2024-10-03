#pragma once
#include "stdafx.h"

#include <vector>
#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
#include <optional>
#endif
#include <stdint.h>
#include <cstring>
#include <tuple>

#define dllg /* tag */
#define dllgm /* tag;mangled */

#if defined(_WINDOWS)
#define dllx extern "C" __declspec(dllexport)
#define dllm __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default"))) 
#define dllm __attribute__ ((visibility("default"))) 
#else
#define dllx extern "C"
#define dllm /* */
#endif

#ifdef _WINDEF_
/// auto-generates a window_handle() on GML side
typedef HWND GAME_HWND;
#endif

/// auto-generates an asset_get_index("argument_name") on GML side
typedef int gml_asset_index_of;
/// Wraps a C++ pointer for GML.
template <typename T> using gml_ptr = T*;
/// Passes a modified struct back to GML
template <typename T> using gml_inout = T&;
/// Modifies an array of values that GML passed in
template <typename T> using gml_inout_vector = std::vector<T>&;

/// Same as gml_ptr, but replaces the GML-side pointer by a nullptr after passing it to C++
template <typename T> using gml_ptr_destroy = T*;
/// Wraps any ID (or anything that casts to int64, really) for GML.
template <typename T> using gml_id = T;
/// Same as gml_id, but replaces the GML-side ID by a 0 after passing it to C++
template <typename T> using gml_id_destroy = T;

class gml_buffer {
private:
	uint8_t* _data;
	int32_t _size;
	int32_t _tell;
public:
	gml_buffer() : _data(nullptr), _tell(0), _size(0) {}
	gml_buffer(uint8_t* data, int32_t size, int32_t tell) : _data(data), _size(size), _tell(tell) {}

	inline uint8_t* data() { return _data; }
	inline int32_t tell() { return _tell; }
	inline int32_t size() { return _size; }
};

class gml_istream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_istream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> T read() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		T result{};
		std::memcpy(&result, pos, sizeof(T));
		pos += sizeof(T);
		return result;
	}

	char* read_string() {
		char* r = (char*)pos;
		while (*pos != 0) pos++;
		pos++;
		return r;
	}

	gml_buffer read_gml_buffer() {
		auto _data = (uint8_t*)read<int64_t>();
		auto _size = read<int32_t>();
		auto _tell = read<int32_t>();
		return gml_buffer(_data, _size, _tell);
	}
};

class gml_ostream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_ostream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> void write(T val) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		memcpy(pos, &val, sizeof(T));
		pos += sizeof(T);
	}

	void write_string(const char* s) {
		for (int i = 0; s[i] != 0; i++) write<char>(s[i]);
		write<char>(0);
	}
};

class gmk_buffer {
	uint8_t* buf = 0;
	int pos = 0;
	int len = 0;
public:
	gmk_buffer() {}
	uint8_t* prepare(int size) {
		if (len < size) {
			auto nb = (uint8_t*)realloc(buf, size);
			if (nb == nullptr) {
				trace("Failed to reallocate %u bytes in gmk_buffer::prepare", size);
				return nullptr;
			}
			len = size;
			buf = nb;
		}
		pos = 0;
		return buf;
	}
	void init() {
		buf = 0;
		pos = 0;
		len = 0;
	}
	void rewind() { pos = 0; }
	inline uint8_t* data() { return buf; }
	//
	template<class T> void write(T val) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		int next = pos + sizeof(T);
		if (next > len) {
			auto nl = len;
			while (nl < next) nl *= 2;
			auto nb = (uint8_t*)realloc(buf, nl);
			if (nb == nullptr) {
				trace("Failed to reallocate %u bytes in gmk_buffer::write", nl);
				return;
			}
			len = nl;
			buf = nb;
		}
		memcpy(buf + pos, &val, sizeof(T));
		pos = next;
	}
	template<class T> T read() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		int next = pos + sizeof(T);
		T result{};
		if (next > len) return result;
		memcpy(&result, buf + pos, sizeof(T));
		pos = next;
		return result;
	}
	void write_string(const char* str) {
		int n = (int)strlen(str) + 1;
		int next = pos + n;
		if (next > len) {
			auto nl = len;
			while (nl < next) nl *= 2;
			auto nb = (uint8_t*)realloc(buf, nl);
			if (nb == nullptr) {
				trace("Failed to reallocate %u bytes in gmk_buffer::write", nl);
				return;
			}
			len = nl;
			buf = nb;
		}
		memcpy(buf + pos, str, n);
		pos = next;
	}
	const char* read_string() {
		if (pos >= len) return "";
		auto str = (const char*)(buf + pos);
		pos += (int)strlen(str) + 1;
		return str;
	}
};
//{{NO_DEPENDENCIES}}
// Microsoft Visual C++ generated include file.
// Used by winmenu.rc

// Next default values for new objects
// 
#ifdef APSTUDIO_INVOKED
#ifndef APSTUDIO_READONLY_SYMBOLS
#define _APS_NEXT_RESOURCE_VALUE        101
#define _APS_NEXT_COMMAND_VALUE         40001
#define _APS_NEXT_CONTROL_VALUE         1001
#define _APS_NEXT_SYMED_VALUE           101
#endif
#endif
// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#ifdef _WINDOWS
	#include "targetver.h"
	
	#define WIN32_LEAN_AND_MEAN // Exclude rarely-used stuff from Windows headers
	#include <windows.h>
#endif

#if defined(WIN32)
#define dllx extern "C" __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default"))) 
#else
#define dllx extern "C"
#endif

#define trace(...) { printf("[winmenu:%d] ", __LINE__); printf(__VA_ARGS__); printf("\n"); fflush(stdout); }

template<typename T> T* malloc_arr(size_t count) {
	return (T*)malloc(sizeof(T) * count);
}
template<typename T> T* realloc_arr(T* arr, size_t count) {
	return (T*)realloc(arr, sizeof(T) * count);
}
template<typename T> T* memcpy_arr(T* dst, const T* src, size_t count) {
	return (T*)memcpy(dst, src, sizeof(T) * count);
}
#pragma once
#include "stdafx.h"

class StringConv {
public:
    char* cbuf = NULL;
    size_t cbuf_size = 0;
    WCHAR* wbuf = NULL;
    size_t wbuf_size = 0;
    StringConv() {

    }
    LPWSTR wget(size_t size) {
        if (wbuf_size < size) {
            wbuf = realloc_arr(wbuf, size);
            wbuf_size = size;
        }
        return wbuf;
    }
    LPCWSTR proc(const char* src, int cp = CP_UTF8) {
        size_t size = MultiByteToWideChar(cp, 0, src, -1, NULL, 0);
        LPWSTR buf = wget(size);
        MultiByteToWideChar(cp, 0, src, -1, wbuf, (int)size);
        return wbuf;
    }
    char* get(size_t size) {
        if (cbuf_size < size) {
            cbuf = realloc_arr(cbuf, size);
            cbuf_size = size;
        }
        return cbuf;
    }
    const char* proc(LPCWSTR src, int cp = CP_UTF8) {
        size_t size = WideCharToMultiByte(cp, 0, src, -1, NULL, 0, NULL, NULL);
        char* buf = get(size);
        WideCharToMultiByte(cp, 0, src, -1, buf, (int)size, NULL, NULL);
        return buf;
    }
};
extern StringConv wm_c1, wm_c2;
#pragma once

// Including SDKDDKVer.h defines the highest available Windows platform.

// If you wish to build your application for a previous Windows platform, include WinSDKVer.h and
// set the _WIN32_WINNT macro to the platform you wish to support before including SDKDDKVer.h.

#include <SDKDDKVer.h>
#pragma once
#include "winmenu.h"
#include <Dbghelp.h>

#ifdef wm_hook_adj
BOOL InstallHook(LPCSTR module, LPCSTR function, void* hook, void** original);

template<typename T>
BOOL InstallHookPlus(LPCSTR module, LPCSTR function, T proto, T hook, T* out_orig) {
	return InstallHook(module, function, hook, (void**)out_orig);
}
#define HookPairDecl(ret, name, ...)\
	ret(__stdcall* name##_base)(##__VA_ARGS__);\
	__declspec(noinline) ret __stdcall  name##_hook(##__VA_ARGS__)

HMODULE hmFromAddress(void* addr);
#endif#pragma once
#include "gml_ext.h"
#include "StringConv.h"

using wm_flags = uint32_t;
using wm_item = uint32_t;
using wm_command = uint32_t;
using wm_index = uint32_t;
using wm_menu = gml_id<HMENU>;
using wm_handle = intptr_t;
using wm_bitmap = gml_id<HBITMAP>;

#define wm_p2f(bypos) ((bypos) ? MF_BYPOSITION : MF_BYCOMMAND)
#define wm_cc(str) (wm_c1.proc(str))
#define wm_setflag(val, flag, on) if (on) val |= (flag); else val &= ~(flag);

#define wmf_mft (MFT_RADIOCHECK | MFT_RIGHTJUSTIFY | MFT_RIGHTORDER | MFT_SEPARATOR | MFT_MENUBARBREAK | MFT_MENUBREAK)
inline void wmii_set_flags(MENUITEMINFOW& inf, wm_flags flags) {
	inf.fState = flags & ~wmf_mft;
	inf.fType = flags & wmf_mft;
}
inline wm_flags wmii_get_flags(MENUITEMINFOW& inf) {
	return (inf.fType & wmf_mft) | (inf.fState & ~wmf_mft);
}

#define wm_hook_adj#include "gml_ext.h"
#include "winmenu.h"
gmk_buffer gmk_buffer_args;
// Struct forward declarations:
// from winmenu_item.cpp:137:
struct winmenu_item_rect {
    int x, y, width, height;
    winmenu_item_rect(RECT rect) {
        x = rect.left;
        y = rect.top;
        width = rect.right - rect.left + 1;
        height = rect.bottom - rect.top + 1;
    }
};
// from winmenu_special.cpp:89:
struct wm_bar_info {
    int x, y, width, height;
    int flags;
};
extern bool winmenu_bitmap_destroy(gml_id_destroy<HBITMAP> bitmap);
dllx double winmenu_bitmap_destroy_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	gml_id_destroy<HBITMAP> _arg_bitmap = (gml_id_destroy<HBITMAP>)_in.read<int64_t>();;
	return winmenu_bitmap_destroy(_arg_bitmap);
}

extern bool winmenu_bitmap_deref(gml_id_destroy<HBITMAP> bitmap);
dllx double winmenu_bitmap_deref_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	gml_id_destroy<HBITMAP> _arg_bitmap = (gml_id_destroy<HBITMAP>)_in.read<int64_t>();;
	return winmenu_bitmap_deref(_arg_bitmap);
}

extern bool winmenu_bitmap_equals(wm_bitmap a, wm_bitmap b);
dllx double winmenu_bitmap_equals_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_bitmap _arg_a = (wm_bitmap)_in.read<int64_t>();;
	wm_bitmap _arg_b = (wm_bitmap)_in.read<int64_t>();;
	return winmenu_bitmap_equals(_arg_a, _arg_b);
}

extern wm_bitmap winmenu_bitmap_add(const char* fname);
dllx double winmenu_bitmap_add_raw(void* _inout_ptr, double _inout_ptr_size, const char* _arg_fname) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_bitmap _result = winmenu_bitmap_add(_arg_fname);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern wm_bitmap winmenu_bitmap_create_from_buffer(gml_buffer buffer, int width, int height, bool is_rgba);
dllx double winmenu_bitmap_create_from_buffer_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	gml_buffer _arg_buffer = _in.read_gml_buffer();
	int _arg_width = _in.read<int>();
	int _arg_height = _in.read<int>();
	bool _arg_is_rgba = _in.read<bool>();
	wm_bitmap _result = winmenu_bitmap_create_from_buffer(_arg_buffer, _arg_width, _arg_height, _arg_is_rgba);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern bool winmenu_set_bitmap(wm_menu menu, wm_item item, bool bypos, wm_bitmap bitmap);
dllx double winmenu_set_bitmap_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_bitmap _arg_bitmap = (wm_bitmap)_in.read<int64_t>();;
	return winmenu_set_bitmap(_arg_menu, _arg_item, _arg_bypos, _arg_bitmap);
}

extern bool winmenu_set_bitmap_sys(wm_menu menu, wm_item item, bool bypos, int bitmap_index);
dllx double winmenu_set_bitmap_sys_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	int _arg_bitmap_index = _in.read<int>();
	return winmenu_set_bitmap_sys(_arg_menu, _arg_item, _arg_bypos, _arg_bitmap_index);
}

extern bool winmenu_reset_bitmap(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_reset_bitmap_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	return winmenu_reset_bitmap(_arg_menu, _arg_item, _arg_bypos);
}

extern wm_bitmap winmenu_get_bitmap(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_bitmap_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_bitmap _result = winmenu_get_bitmap(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern std::optional<bool> winmenu_has_bitmap(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_has_bitmap_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<bool> _result = winmenu_has_bitmap(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern int winmenu_get_checkmark_width();
dllx double winmenu_get_checkmark_width_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	return winmenu_get_checkmark_width();
}

extern int winmenu_get_checkmark_height();
dllx double winmenu_get_checkmark_height_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	return winmenu_get_checkmark_height();
}

extern bool winmenu_set_checkmark_bitmaps(wm_menu menu, wm_item item, bool bypos, wm_bitmap bitmap_unchecked, wm_bitmap bitmap_checked);
dllx double winmenu_set_checkmark_bitmaps_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_bitmap _arg_bitmap_unchecked = (wm_bitmap)_in.read<int64_t>();;
	wm_bitmap _arg_bitmap_checked = (wm_bitmap)_in.read<int64_t>();;
	return winmenu_set_checkmark_bitmaps(_arg_menu, _arg_item, _arg_bypos, _arg_bitmap_unchecked, _arg_bitmap_checked);
}

extern bool winmenu_reset_checkmark_bitmaps(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_reset_checkmark_bitmaps_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	return winmenu_reset_checkmark_bitmaps(_arg_menu, _arg_item, _arg_bypos);
}

extern wm_bitmap winmenu_get_checkmark_bitmap(wm_menu menu, wm_item item, bool bypos, bool checked);
dllx double winmenu_get_checkmark_bitmap_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	bool _arg_checked = _in.read<bool>();
	wm_bitmap _result = winmenu_get_checkmark_bitmap(_arg_menu, _arg_item, _arg_bypos, _arg_checked);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern std::optional<bool> winmenu_has_checkmark_bitmap(wm_menu menu, wm_item item, bool bypos, bool checked);
dllx double winmenu_has_checkmark_bitmap_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	bool _arg_checked = _in.read<bool>();
	std::optional<bool> _result = winmenu_has_checkmark_bitmap(_arg_menu, _arg_item, _arg_bypos, _arg_checked);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern std::optional<wm_flags> winmenu_get_flags(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_flags_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<wm_flags> _result = winmenu_get_flags(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<wm_flags>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_flags(wm_menu menu, wm_item item, bool bypos, wm_flags flags);
dllx double winmenu_set_flags_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_flags _arg_flags = _in.read<wm_flags>();
	return winmenu_set_flags(_arg_menu, _arg_item, _arg_bypos, _arg_flags);
}

extern std::optional<wm_menu> winmenu_get_submenu(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_submenu_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<wm_menu> _result = winmenu_get_submenu(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<int64_t>((int64_t)_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_submenu(wm_menu menu, wm_item item, bool bypos, wm_menu submenu);
dllx double winmenu_set_submenu_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_menu _arg_submenu = (wm_menu)_in.read<int64_t>();;
	return winmenu_set_submenu(_arg_menu, _arg_item, _arg_bypos, _arg_submenu);
}

extern std::optional<bool> winmenu_has_submenu(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_has_submenu_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<bool> _result = winmenu_has_submenu(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern std::optional<wm_item> winmenu_get_command(wm_menu menu, wm_index index);
dllx double winmenu_get_command_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_index _arg_index = _in.read<wm_index>();
	std::optional<wm_item> _result = winmenu_get_command(_arg_menu, _arg_index);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<wm_item>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_command(wm_menu menu, wm_item item, bool bypos, wm_command new_command);
dllx double winmenu_set_command_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_command _arg_new_command = _in.read<wm_command>();
	return winmenu_set_command(_arg_menu, _arg_item, _arg_bypos, _arg_new_command);
}

extern std::optional<const char*> winmenu_get_text(wm_menu menu, wm_item item, bool bypos);
static std::optional<const char*> winmenu_get_text_raw_store_return;
dllx double winmenu_get_text_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	winmenu_get_text_raw_store_return = winmenu_get_text(_arg_menu, _arg_item, _arg_bypos);
	size_t _dyn_size = 1;
	auto& _sz_return = winmenu_get_text_raw_store_return;
	if (_sz_return.has_value()) {
		_dyn_size += strlen(winmenu_get_text_raw_store_return.value());
		_dyn_size += 1;
	}
	return (double)(_dyn_size);
}
dllx double winmenu_get_text_raw_post(void* _out_ptr, double _out_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _out_ptr = _gmkb;
	gml_ostream _out(_out_ptr);
	auto& _r = winmenu_get_text_raw_store_return;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write_string(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_text(wm_menu menu, wm_item item, bool bypos, const char* text);
dllx double winmenu_set_text_raw(void* _in_ptr, double _in_ptr_size, const char* _arg_text) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	return winmenu_set_text(_arg_menu, _arg_item, _arg_bypos, _arg_text);
}

extern std::optional<bool> winmenu_get_enabled(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_enabled_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<bool> _result = winmenu_get_enabled(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_enabled(wm_menu menu, wm_item item, bool bypos, bool enabled);
dllx double winmenu_set_enabled_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	bool _arg_enabled = _in.read<bool>();
	return winmenu_set_enabled(_arg_menu, _arg_item, _arg_bypos, _arg_enabled);
}

extern std::optional<bool> winmenu_get_hilite(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_hilite_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<bool> _result = winmenu_get_hilite(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_hilite(GAME_HWND hwnd, wm_menu menu, wm_item item, bool bypos, bool hilite);
dllx double winmenu_set_hilite_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	bool _arg_hilite = _in.read<bool>();
	return winmenu_set_hilite(_arg_hwnd, _arg_menu, _arg_item, _arg_bypos, _arg_hilite);
}

extern std::optional<bool> winmenu_get_checked(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_checked_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<bool> _result = winmenu_get_checked(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_checked(wm_menu menu, wm_item item, bool bypos, bool checked);
dllx double winmenu_set_checked_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	bool _arg_checked = _in.read<bool>();
	return winmenu_set_checked(_arg_menu, _arg_item, _arg_bypos, _arg_checked);
}

extern std::optional<bool> winmenu_get_radio(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_get_radio_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	std::optional<bool> _result = winmenu_get_radio(_arg_menu, _arg_item, _arg_bypos);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<bool>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_radio(wm_menu menu, wm_item item, bool bypos, bool show_as_radio);
dllx double winmenu_set_radio_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	bool _arg_show_as_radio = _in.read<bool>();
	return winmenu_set_radio(_arg_menu, _arg_item, _arg_bypos, _arg_show_as_radio);
}

extern bool winmenu_set_radio_group(wm_menu menu, wm_item first, wm_item last, wm_item selection, bool bypos);
dllx double winmenu_set_radio_group_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_first = _in.read<wm_item>();
	wm_item _arg_last = _in.read<wm_item>();
	wm_item _arg_selection = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	return winmenu_set_radio_group(_arg_menu, _arg_first, _arg_last, _arg_selection, _arg_bypos);
}

extern std::optional<winmenu_item_rect> winmenu_get_item_rect(GAME_HWND hwnd, bool use_hwnd, wm_menu menu, wm_index index);
dllx double winmenu_get_item_rect_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	bool _arg_use_hwnd = _in.read<bool>();
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_index _arg_index = _in.read<wm_index>();
	std::optional<winmenu_item_rect> _result = winmenu_get_item_rect(_arg_hwnd, _arg_use_hwnd, _arg_menu, _arg_index);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		auto& _r_v = _r.value();
		_out.write<int>(_r_v.x);
		_out.write<int>(_r_v.y);
		_out.write<int>(_r_v.width);
		_out.write<int>(_r_v.height);
	} else _out.write<bool>(false);
	return 1;
}

extern int winmenu_item_from_point(GAME_HWND hwnd, bool use_hwnd, wm_menu menu, int x, int y);
dllx double winmenu_item_from_point_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	bool _arg_use_hwnd = _in.read<bool>();
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	int _arg_x = _in.read<int>();
	int _arg_y = _in.read<int>();
	return winmenu_item_from_point(_arg_hwnd, _arg_use_hwnd, _arg_menu, _arg_x, _arg_y);
}

extern bool winmenu_add(wm_menu menu, wm_command command, const char* text, wm_flags flags);
dllx double winmenu_add_raw(void* _in_ptr, double _in_ptr_size, const char* _arg_text) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_command _arg_command = _in.read<wm_command>();
	wm_flags _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<wm_flags>();
	} else _arg_flags = 0;
	return winmenu_add(_arg_menu, _arg_command, _arg_text, _arg_flags);
}

extern bool winmenu_add_submenu(wm_menu menu, wm_command command, wm_menu submenu, const char* text, wm_flags flags);
dllx double winmenu_add_submenu_raw(void* _in_ptr, double _in_ptr_size, const char* _arg_text) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_command _arg_command = _in.read<wm_command>();
	wm_menu _arg_submenu = (wm_menu)_in.read<int64_t>();;
	wm_flags _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<wm_flags>();
	} else _arg_flags = 0;
	return winmenu_add_submenu(_arg_menu, _arg_command, _arg_submenu, _arg_text, _arg_flags);
}

extern bool winmenu_add_separator(wm_menu menu, wm_command command, wm_flags flags);
dllx double winmenu_add_separator_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_command _arg_command;
	if (_in.read<bool>()) {
		_arg_command = _in.read<wm_command>();
	} else _arg_command = 0;
	wm_flags _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<wm_flags>();
	} else _arg_flags = 0;
	return winmenu_add_separator(_arg_menu, _arg_command, _arg_flags);
}

extern bool winmenu_insert(wm_menu menu, wm_item item, bool bypos, wm_command command, const char* text, wm_flags flags);
dllx double winmenu_insert_raw(void* _in_ptr, double _in_ptr_size, const char* _arg_text) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_command _arg_command = _in.read<wm_command>();
	wm_flags _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<wm_flags>();
	} else _arg_flags = 0;
	return winmenu_insert(_arg_menu, _arg_item, _arg_bypos, _arg_command, _arg_text, _arg_flags);
}

extern bool winmenu_insert_submenu(wm_menu menu, wm_item item, bool bypos, wm_command command, wm_menu submenu, const char* text, wm_flags flags);
dllx double winmenu_insert_submenu_raw(void* _in_ptr, double _in_ptr_size, const char* _arg_text) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_command _arg_command = _in.read<wm_command>();
	wm_menu _arg_submenu = (wm_menu)_in.read<int64_t>();;
	wm_flags _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<wm_flags>();
	} else _arg_flags = 0;
	return winmenu_insert_submenu(_arg_menu, _arg_item, _arg_bypos, _arg_command, _arg_submenu, _arg_text, _arg_flags);
}

extern bool winmenu_insert_separator(wm_menu menu, wm_item item, bool bypos, wm_command command, wm_flags flags);
dllx double winmenu_insert_separator_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	wm_command _arg_command;
	if (_in.read<bool>()) {
		_arg_command = _in.read<wm_command>();
	} else _arg_command = 0;
	wm_flags _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<wm_flags>();
	} else _arg_flags = 0;
	return winmenu_insert_separator(_arg_menu, _arg_item, _arg_bypos, _arg_command, _arg_flags);
}

extern bool winmenu_delete(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_delete_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	return winmenu_delete(_arg_menu, _arg_item, _arg_bypos);
}

extern bool winmenu_delete_rec(wm_menu menu, wm_item item, bool bypos);
dllx double winmenu_delete_rec_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_bypos = _in.read<bool>();
	return winmenu_delete_rec(_arg_menu, _arg_item, _arg_bypos);
}

extern wm_menu winmenu_create_bar();
dllx double winmenu_create_bar_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _result = winmenu_create_bar();
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern wm_menu winmenu_create_popup();
dllx double winmenu_create_popup_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _result = winmenu_create_popup();
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern bool winmenu_destroy(gml_id_destroy<HMENU> menu);
dllx double winmenu_destroy_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	gml_id_destroy<HMENU> _arg_menu = (gml_id_destroy<HMENU>)_in.read<int64_t>();;
	return winmenu_destroy(_arg_menu);
}

extern wm_handle winmenu_get_handle(wm_menu menu);
dllx double winmenu_get_handle_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_handle _result = winmenu_get_handle(_arg_menu);
	gml_ostream _out(_inout_ptr);
	_out.write<wm_handle>(_result);
	return 1;
}

extern wm_menu winmenu_from_handle(wm_handle handle);
dllx double winmenu_from_handle_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_handle _arg_handle = _in.read<wm_handle>();
	wm_menu _result = winmenu_from_handle(_arg_handle);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern bool winmenu_deref(gml_id_destroy<HMENU> menu);
dllx double winmenu_deref_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	gml_id_destroy<HMENU> _arg_menu = (gml_id_destroy<HMENU>)_in.read<int64_t>();;
	return winmenu_deref(_arg_menu);
}

extern bool winmenu_handle_is_menu(wm_handle handle);
dllx double winmenu_handle_is_menu_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_handle _arg_handle = _in.read<wm_handle>();
	return winmenu_handle_is_menu(_arg_handle);
}

extern bool winmenu_equals(wm_menu menu1, wm_menu menu2);
dllx double winmenu_equals_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu1 = (wm_menu)_in.read<int64_t>();;
	wm_menu _arg_menu2 = (wm_menu)_in.read<int64_t>();;
	return winmenu_equals(_arg_menu1, _arg_menu2);
}

extern int winmenu_size(wm_menu menu);
dllx double winmenu_size_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	return winmenu_size(_arg_menu);
}

extern std::optional<wm_item> winmenu_get_default_item(wm_menu menu, bool want_pos, bool recursive, bool allow_disabled);
dllx double winmenu_get_default_item_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	bool _arg_want_pos = _in.read<bool>();
	bool _arg_recursive = _in.read<bool>();
	bool _arg_allow_disabled = _in.read<bool>();
	std::optional<wm_item> _result = winmenu_get_default_item(_arg_menu, _arg_want_pos, _arg_recursive, _arg_allow_disabled);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<wm_item>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_default_item(wm_menu menu, wm_item item, bool want_pos);
dllx double winmenu_set_default_item_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	wm_item _arg_item = _in.read<wm_item>();
	bool _arg_want_pos = _in.read<bool>();
	return winmenu_set_default_item(_arg_menu, _arg_item, _arg_want_pos);
}

extern std::optional<uint32_t> winmenu_get_max_height(wm_menu menu);
dllx double winmenu_get_max_height_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	std::optional<uint32_t> _result = winmenu_get_max_height(_arg_menu);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<uint32_t>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern bool winmenu_set_max_height(wm_menu menu, uint32_t max_height);
dllx double winmenu_set_max_height_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	uint32_t _arg_max_height = _in.read<uint32_t>();
	return winmenu_set_max_height(_arg_menu, _arg_max_height);
}

extern wm_item winmenu_show_popup(GAME_HWND hwnd, wm_menu menu, uint32_t flags, std::optional<int> x, std::optional<int> y);
dllx double winmenu_show_popup_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	uint32_t _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<uint32_t>();
	} else _arg_flags = 0;
	std::optional<int> _arg_x;
	if (_in.read<bool>()) {
		std::optional<int> _a_x;if (_in.read<bool>()) {
			_a_x = _in.read<int>();
		} else _a_x = {};
		_arg_x = _a_x;
	} else _arg_x = {};
	std::optional<int> _arg_y;
	if (_in.read<bool>()) {
		std::optional<int> _a_y;if (_in.read<bool>()) {
			_a_y = _in.read<int>();
		} else _a_y = {};
		_arg_y = _a_y;
	} else _arg_y = {};
	return winmenu_show_popup(_arg_hwnd, _arg_menu, _arg_flags, _arg_x, _arg_y);
}

extern wm_item winmenu_show_popup_outside(GAME_HWND hwnd, wm_menu menu, int exclude_x, int exclude_y, int exclude_width, int exclude_height, uint32_t flags, std::optional<int> x, std::optional<int> y);
dllx double winmenu_show_popup_outside_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	int _arg_exclude_x = _in.read<int>();
	int _arg_exclude_y = _in.read<int>();
	int _arg_exclude_width = _in.read<int>();
	int _arg_exclude_height = _in.read<int>();
	uint32_t _arg_flags;
	if (_in.read<bool>()) {
		_arg_flags = _in.read<uint32_t>();
	} else _arg_flags = 0;
	std::optional<int> _arg_x;
	if (_in.read<bool>()) {
		std::optional<int> _a_x;if (_in.read<bool>()) {
			_a_x = _in.read<int>();
		} else _a_x = {};
		_arg_x = _a_x;
	} else _arg_x = {};
	std::optional<int> _arg_y;
	if (_in.read<bool>()) {
		std::optional<int> _a_y;if (_in.read<bool>()) {
			_a_y = _in.read<int>();
		} else _a_y = {};
		_arg_y = _a_y;
	} else _arg_y = {};
	return winmenu_show_popup_outside(_arg_hwnd, _arg_menu, _arg_exclude_x, _arg_exclude_y, _arg_exclude_width, _arg_exclude_height, _arg_flags, _arg_x, _arg_y);
}

extern void winmenu_cleanup_for_raw(uintptr_t _hwnd);
dllx double winmenu_cleanup_for_raw_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	uintptr_t _arg__hwnd = _in.read<uintptr_t>();
	winmenu_cleanup_for_raw(_arg__hwnd);
	return 1;
}

extern uintptr_t winmenu_queue_hwnd();
dllx double winmenu_queue_hwnd_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	uintptr_t _result = winmenu_queue_hwnd();
	gml_ostream _out(_inout_ptr);
	_out.write<uintptr_t>(_result);
	return 1;
}

extern wm_menu winmenu_bar_get_raw(GAME_HWND hwnd);
dllx double winmenu_bar_get_raw_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	wm_menu _result = winmenu_bar_get_raw(_arg_hwnd);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern bool winmenu_bar_set_raw(GAME_HWND hwnd, wm_menu menu);
dllx double winmenu_bar_set_raw_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	wm_menu _arg_menu = (wm_menu)_in.read<int64_t>();;
	return winmenu_bar_set_raw(_arg_hwnd, _arg_menu);
}

extern bool winmenu_bar_reset_raw(GAME_HWND hwnd);
dllx double winmenu_bar_reset_raw_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	return winmenu_bar_reset_raw(_arg_hwnd);
}

extern bool winmenu_bar_redraw(GAME_HWND hwnd);
dllx double winmenu_bar_redraw_raw(void* _in_ptr, double _in_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _in_ptr = _gmkb;
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	return winmenu_bar_redraw(_arg_hwnd);
}

extern std::optional<wm_bar_info> winmenu_bar_get_info(GAME_HWND hwnd, std::optional<wm_index> index);
dllx double winmenu_bar_get_info_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	std::optional<wm_index> _arg_index;
	if (_in.read<bool>()) {
		std::optional<wm_index> _a_index;if (_in.read<bool>()) {
			_a_index = _in.read<wm_index>();
		} else _a_index = {};
		_arg_index = _a_index;
	} else _arg_index = {};
	std::optional<wm_bar_info> _result = winmenu_bar_get_info(_arg_hwnd, _arg_index);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		auto& _r_v = _r.value();
		_out.write<int>(_r_v.x);
		_out.write<int>(_r_v.y);
		_out.write<int>(_r_v.width);
		_out.write<int>(_r_v.height);
		_out.write<int>(_r_v.flags);
	} else _out.write<bool>(false);
	return 1;
}

extern std::optional<int> winmenu_bar_get_height(GAME_HWND hwnd);
dllx double winmenu_bar_get_height_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	std::optional<int> _result = winmenu_bar_get_height(_arg_hwnd);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		_out.write<int>(_r.value());
	} else _out.write<bool>(false);
	return 1;
}

extern wm_menu winmenu_sysmenu_get_raw(GAME_HWND hwnd, bool revert);
dllx double winmenu_sysmenu_get_raw_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	bool _arg_revert = _in.read<bool>();
	wm_menu _result = winmenu_sysmenu_get_raw(_arg_hwnd, _arg_revert);
	gml_ostream _out(_inout_ptr);
	_out.write<int64_t>((int64_t)_result);
	return 1;
}

extern std::optional<wm_bar_info> winmenu_sysmenu_get_info(GAME_HWND hwnd, std::optional<wm_index> index);
dllx double winmenu_sysmenu_get_info_raw(void* _inout_ptr, double _inout_ptr_size) {
	auto _gmkb = gmk_buffer_args.data();
	if (_gmkb) _inout_ptr = _gmkb;
	gml_istream _in(_inout_ptr);
	GAME_HWND _arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	std::optional<wm_index> _arg_index;
	if (_in.read<bool>()) {
		std::optional<wm_index> _a_index;if (_in.read<bool>()) {
			_a_index = _in.read<wm_index>();
		} else _a_index = {};
		_arg_index = _a_index;
	} else _arg_index = {};
	std::optional<wm_bar_info> _result = winmenu_sysmenu_get_info(_arg_hwnd, _arg_index);
	gml_ostream _out(_inout_ptr);
	auto& _r = _result;
	if (_r.has_value()) {
		_out.write<bool>(true);
		auto& _r_v = _r.value();
		_out.write<int>(_r_v.x);
		_out.write<int>(_r_v.y);
		_out.write<int>(_r_v.width);
		_out.write<int>(_r_v.height);
		_out.write<int>(_r_v.flags);
	} else _out.write<bool>(false);
	return 1;
}

// GM8.1 and earlier:
/// #gmki
dllx double winmenu_gmkb_prepare(double _size) {
	gmk_buffer_args.prepare((int)_size);
	return 1;
}
/// #gmki
dllx double winmenu_gmkb_rewind() {
	gmk_buffer_args.rewind();
	return 1;
}
// reads:
/// #gmki
dllx double winmenu_gmkb_read_bool() {
	return (double)gmk_buffer_args.read<bool>();
}
/// #gmki
dllx double winmenu_gmkb_read_u32() {
	return (double)gmk_buffer_args.read<uint32_t>();
}
/// #gmki
dllx double winmenu_gmkb_read_s32() {
	return (double)gmk_buffer_args.read<int32_t>();
}
/// #gmki
dllx double winmenu_gmkb_read_u64() {
	return (double)gmk_buffer_args.read<int64_t>();
}
/// #gmki
dllx const char* winmenu_gmkb_read_string() {
	return gmk_buffer_args.read_string();
}
// writes:
/// #gmki
dllx double winmenu_gmkb_write_ptr(double val) {
	gmk_buffer_args.write((int64_t)(int32_t)val);
	return 1;
}
/// #gmki
dllx double winmenu_gmkb_write_bool(double val) {
	gmk_buffer_args.write((bool)val);
	return 1;
}
/// #gmki
dllx double winmenu_gmkb_write_u32(double val) {
	gmk_buffer_args.write((uint32_t)val);
	return 1;
}
/// #gmki
dllx double winmenu_gmkb_write_s32(double val) {
	gmk_buffer_args.write((int32_t)val);
	return 1;
}
/// #gmki
dllx double winmenu_gmkb_write_u64(double val) {
	#if defined(TINY) && (INTPTR_MAX == INT32_MAX)
	int64_t result;
	__asm {
		fld val
		fistp result
	}
	gmk_buffer_args.write(result);
	#else
	gmk_buffer_args.write((int64_t)val);
	#endif
	return 1;
}
// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

// stdafx.cpp : source file that includes just the standard includes
// winmenu.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
#include "stdafx.h"
#include "winmenu.h"
#include <Dbghelp.h>

#ifdef wm_hook_adj
#pragma comment(lib, "dbghelp.lib")

// https://github.com/andreasjhkarlsson/winapi-hooking-demo

BOOL ModifyImportTable(IMAGE_IMPORT_DESCRIPTOR* iid, void* target, void* replacement)
{
	IMAGE_THUNK_DATA* itd = (IMAGE_THUNK_DATA*)(((char*)GetModuleHandle(NULL)) + iid->FirstThunk);

	while (itd->u1.Function)
	{
		if (((void*)itd->u1.Function) == target)
		{
			// Temporary change access to memory area to READWRITE
			MEMORY_BASIC_INFORMATION mbi;
			VirtualQuery(itd, &mbi, sizeof(MEMORY_BASIC_INFORMATION));
			VirtualProtect(mbi.BaseAddress, mbi.RegionSize, PAGE_READWRITE, &mbi.Protect);

			// Replace entry!!
			*((void**)itd) = replacement;

			// Restore memory permissions
			VirtualProtect(mbi.BaseAddress, mbi.RegionSize, mbi.Protect, &mbi.Protect);

			return TRUE;
		}

		itd += 1;
	}
	return FALSE;
}

template<typename T>
static bool fakestrieq(const T* s1, const T* s2) {
	for (size_t i = 0;; i++) {
		auto c1 = s1[i], c2 = s2[i];
		if (c1 >= 'a' && c1 <= 'z') c1 -= 'a' - 'A';
		if (c2 >= 'a' && c2 <= 'z') c2 -= 'a' - 'A';
		if (c1 != c2) return false;
		if (c1 == 0) return true;
	}
}

BOOL InstallHook(LPCSTR module, LPCSTR function, void* hook, void** original)
{
	HMODULE process = GetModuleHandle(NULL);

	// Save original address to function
	HMODULE _module = GetModuleHandleA(module);
	if (_module == NULL) return FALSE;
	*original = (void*)GetProcAddress(_module, function);

	ULONG entrySize;

	IMAGE_IMPORT_DESCRIPTOR* iid = (IMAGE_IMPORT_DESCRIPTOR*)ImageDirectoryEntryToData(process, 1, IMAGE_DIRECTORY_ENTRY_IMPORT, &entrySize);

	// Search for module
	while (iid->Name)
	{
		const char* name = ((char*)process) + iid->Name;

		if (fakestrieq(name, module))
		{
			return ModifyImportTable(iid, *original, hook);
		}
		iid += 1;
	}

	return FALSE;
}

HMODULE hmFromAddress(void* addr) {
	HMODULE hModule = NULL;
	GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS, (wchar_t*)addr, &hModule);
	return hModule;
}
#endif/// @author YellowAfterlife

#include "stdafx.h"
#include "winmenu.h"
#include <Windows.h>
#include "winapi_hook.h"
#include <intrin.h>

#ifdef wm_hook_adj

// ideally should be doing bMenu = GetMenu(hwnd) != NULL in the runner,
// but it doesn't, so let's install a little hook function

static HMODULE hmGame = 0;
static HWND main_hwnd = NULL;

HookPairDecl(BOOL, AdjustWindowRectEx, 
	_Inout_ LPRECT lpRect,
	_In_ DWORD dwStyle,
	_In_ BOOL bMenu,
	_In_ DWORD dwExStyle
) {
	auto hm = hmFromAddress(_ReturnAddress());

	#if 0
	char hmn[128] = "";
	GetModuleFileNameA(hm, hmn, std::size(hmn));
	trace("Is AdjustWindowRectEx being called from runner?: %d (%s)", hm == hmGame, hmn);
	#endif

	if (!bMenu && hmGame && hm == hmGame) {
		bMenu = GetMenu(main_hwnd) != NULL;
	}
	return AdjustWindowRectEx_base(lpRect, dwStyle, bMenu, dwExStyle);
}

#endif

dllx double winmenu_preinit_raw(void* pHwnd, double nHwnd) {
	#ifdef wm_hook_adj
	static bool hooked = false;
	if (hooked) return 1;
	//
	hmGame = hmFromAddress(_ReturnAddress());
	hooked = InstallHookPlus("User32.dll", "AdjustWindowRectEx", AdjustWindowRectEx, AdjustWindowRectEx_hook, &AdjustWindowRectEx_base);
	//
	if (nHwnd != 0) {
		main_hwnd = (HWND)(int32_t)nHwnd;
	} else {
		main_hwnd = (HWND)pHwnd;
	}
	#endif
	return 1;
}#include "stdafx.h"
#include "winmenu.h"
#define winmenu_parex

#ifdef winmenu_parex
#include <algorithm>
#include <execution>
#endif

dllg bool winmenu_bitmap_destroy(gml_id_destroy<HBITMAP> bitmap) {
    return DeleteObject(bitmap);
}
dllg bool winmenu_bitmap_deref(gml_id_destroy<HBITMAP> bitmap) {
    return bitmap != NULL;
}
dllg bool winmenu_bitmap_equals(wm_bitmap a, wm_bitmap b) {
    return a == b;
}

dllg wm_bitmap winmenu_bitmap_add(const char* fname) {
    return (HBITMAP)LoadImageW(NULL, wm_cc(fname), IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION | LR_LOADFROMFILE);
}
dllg wm_bitmap winmenu_bitmap_create_from_buffer(gml_buffer buffer, int width, int height, bool is_rgba) {
    if (buffer.size() < width * height * 4) return NULL;
    //return CreateBitmap(width, height, 1, 32, buffer.data()); // no alpha?
    BITMAPINFO bmi;
    ZeroMemory(&bmi, sizeof(bmi));
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = width;
    bmi.bmiHeader.biHeight = -height;
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    auto hdc = GetDC(NULL);
    if (!hdc) return NULL;

    void* pBits = nullptr;
    auto bmp = CreateDIBSection(hdc, &bmi, DIB_RGB_COLORS, &pBits, NULL, 0);

    if (!bmp) {
        // uh oh
    } else if (!is_rgba) {
        memcpy(pBits, buffer.data(), width * height * 4);
    } else {
        #ifdef winmenu_parex
        auto dest = (uint32_t*)pBits;
        auto src = (uint32_t*)(buffer.data());
        std::transform(std::execution::par_unseq, src, src + width * height, dest, [](uint32_t c) -> uint32_t {
            return (c & 0xFF00FF00) | ((c & 0xFF0000) >> 16) | ((c & 0xFF) << 16);
        });
        #else
        auto dest = (uint8_t*)pBits;
        auto src = (uint8_t*)buffer.data();
        for (int i = 0; i < width * height; ++i) {
            dest[0] = src[2];
            dest[1] = src[1];
            dest[2] = src[0];
            dest[3] = src[3];
            dest += 4;
            src += 4;
        }
        #endif
    }

    ReleaseDC(NULL, hdc);
    return bmp;
}

// regular:
dllg bool winmenu_set_bitmap(wm_menu menu, wm_item item, bool bypos, wm_bitmap bitmap) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_BITMAP;
    inf.hbmpItem = bitmap;
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}
dllg bool winmenu_set_bitmap_sys(wm_menu menu, wm_item item, bool bypos, int bitmap_index) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_BITMAP;
    inf.hbmpItem = (HBITMAP)(intptr_t)bitmap_index;
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}
dllg bool winmenu_reset_bitmap(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_BITMAP;
    inf.hbmpItem = NULL;
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}
dllg wm_bitmap winmenu_get_bitmap(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_BITMAP;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return NULL;
    return inf.hbmpItem;
}

dllg std::optional<bool> winmenu_has_bitmap(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_BITMAP;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return NULL;
    return inf.hbmpItem != NULL;
}


// checkmarks:
dllg int winmenu_get_checkmark_width() {
    return GetSystemMetrics(SM_CXMENUCHECK);
}
dllg int winmenu_get_checkmark_height() {
    return GetSystemMetrics(SM_CYMENUCHECK);
}
dllg bool winmenu_set_checkmark_bitmaps(wm_menu menu, wm_item item, bool bypos, wm_bitmap bitmap_unchecked, wm_bitmap bitmap_checked) {
    return SetMenuItemBitmaps(menu, item, wm_p2f(bypos), bitmap_unchecked, bitmap_checked);
}
dllg bool winmenu_reset_checkmark_bitmaps(wm_menu menu, wm_item item, bool bypos) {
    return SetMenuItemBitmaps(menu, item, wm_p2f(bypos), NULL, NULL);
}
dllg wm_bitmap winmenu_get_checkmark_bitmap(wm_menu menu, wm_item item, bool bypos, bool checked) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_CHECKMARKS;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return NULL;
    return checked ? inf.hbmpChecked : inf.hbmpUnchecked;
}
dllg std::optional<bool> winmenu_has_checkmark_bitmap(wm_menu menu, wm_item item, bool bypos, bool checked) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_CHECKMARKS;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return NULL;
    return (checked ? inf.hbmpChecked : inf.hbmpUnchecked) != NULL;
}#include "stdafx.h"
#include "winmenu.h"
#include <string>

StringConv wm_c1, wm_c2;

///
enum winmenu_flag {
    // states:
    wmf_enabled = 0x0,
    wmf_disabled = 0x3,
    //wmf_bitmap = 4,
    wmf_checked = 0x8,
    //wmf_submenu = 0x10,
    wmf_bar_break = 0x20,
    wmf_break = 0x40,
    wmf_hilite = 0x80,
    // types:
    wmf_radiocheck = 0x200,
    wmf_separator = 0x800,
    wmf_default = 0x1000,
    wmf_right_order = 0x2000,
    wmf_right_justify = 0x4000,
};
static void wmf_verify() {
    #define X(name, val) static_assert((uint32_t)name == (val), #name)
    X(wmf_disabled, MF_DISABLED | MF_GRAYED);
    X(wmf_checked, MF_CHECKED);
    //X(wmf_submenu, MF_POPUP);
    X(wmf_bar_break, MF_MENUBARBREAK);
    X(wmf_break, MF_MENUBREAK);
    //X(wmf_hilite, MF_HILITE);
    X(wmf_separator, MF_SEPARATOR);
    X(wmf_default, MF_DEFAULT);
    //
    X(wmf_checked, MFS_CHECKED);
    X(wmf_default, MFS_DEFAULT);
    X(wmf_disabled, MFS_DISABLED);
    X(wmf_enabled, MFS_ENABLED);
    X(wmf_hilite, MFS_HILITE);
    //
    X(wmf_bar_break, MF_MENUBARBREAK);
    X(wmf_break, MFT_MENUBREAK);
    X(wmf_separator, MFT_SEPARATOR);
    //
    X(wmf_right_justify, MFT_RIGHTJUSTIFY);
    X(wmf_right_order, MFT_RIGHTORDER);
    #undef X
}

///
enum class wmbm {
    mbar_close = 5,
    mbar_close_d = 6,
    mbar_minimize = 3,
    mbar_minimize_d = 7,
    mbar_restore = 2,
    popup_close = 8,
    popup_maximize = 10,
    popup_mimize = 11,
    popup_restore = 9,
};
static void wmbm_verify() {
    #define X(name, val) static_assert((HBITMAP)name == (val), #name)
    X(wmbm::mbar_close, HBMMENU_MBAR_CLOSE);
    X(wmbm::mbar_close_d, HBMMENU_MBAR_CLOSE_D);
    X(wmbm::mbar_minimize, HBMMENU_MBAR_MINIMIZE);
    X(wmbm::mbar_minimize_d, HBMMENU_MBAR_MINIMIZE_D);
    X(wmbm::mbar_restore, HBMMENU_MBAR_RESTORE);
    X(wmbm::popup_close, HBMMENU_POPUP_CLOSE);
    X(wmbm::popup_maximize, HBMMENU_POPUP_MAXIMIZE);
    X(wmbm::popup_mimize, HBMMENU_POPUP_MINIMIZE);
    X(wmbm::popup_restore, HBMMENU_POPUP_RESTORE);
    #undef X
}

///
dllx double winmenu_get_last_error() {
    return GetLastError();
}
///
dllx const char* winmenu_get_last_error_text() {
    auto id = GetLastError();
    if (id == 0) return "";

    wchar_t* msg = nullptr;
    auto size = FormatMessageW(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
        nullptr, id, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (wchar_t*)&msg, 0, nullptr
    );

    std::wstring result{};
    if (msg != nullptr) {
        result = msg;
        LocalFree(msg);
    } else result = L"Error " + std::to_wstring(id);

    return wm_c1.proc(result.c_str());
}#include "stdafx.h"
#include "winmenu.h"
#include <string>

// flags:
dllg std::optional<wm_flags> winmenu_get_flags(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return {};
    return wmii_get_flags(inf);
}
dllg bool winmenu_set_flags(wm_menu menu, wm_item item, bool bypos, wm_flags flags) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE;
    wmii_set_flags(inf, flags);
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}

// submenu:
dllg std::optional<wm_menu> winmenu_get_submenu(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_SUBMENU;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return {};
    return inf.hSubMenu;
}
dllg bool winmenu_set_submenu(wm_menu menu, wm_item item, bool bypos, wm_menu submenu) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_SUBMENU;
    inf.hSubMenu = submenu;
    return GetMenuItemInfoW(menu, item, bypos, &inf);
}
dllg std::optional<bool> winmenu_has_submenu(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_SUBMENU;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return {};
    return inf.hSubMenu != NULL;
}

// id
dllg std::optional<wm_item> winmenu_get_command(wm_menu menu, wm_index index) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_ID;
    if (!GetMenuItemInfoW(menu, index, true, &inf)) return {};
    return inf.wID;
}
dllg bool winmenu_set_command(wm_menu menu, wm_item item, bool bypos, wm_command new_command) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_ID;
    inf.wID = new_command;
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}

// text:
dllg std::optional<const char*> winmenu_get_text(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STRING;
    inf.dwTypeData = nullptr;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return {};

    static std::wstring tmp{};
    tmp.resize(inf.cch + 2); tmp[0] = 0;
    inf.cch += 1; // missing the last letter otherwise..?
    inf.dwTypeData = tmp.data();
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return {};

    return wm_cc(tmp.c_str());
}
dllg bool winmenu_set_text(wm_menu menu, wm_item item, bool bypos, const char* text) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STRING;
    inf.dwTypeData = (wchar_t*)wm_cc(text);
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}

// enabled:
dllg std::optional<bool> winmenu_get_enabled(wm_menu menu, wm_item item, bool bypos) {
    auto flags = winmenu_get_flags(menu, item, bypos);
    if (flags) {
        return (*flags & MFS_DISABLED) == 0;
    } else return {};
}
dllg bool winmenu_set_enabled(wm_menu menu, wm_item item, bool bypos, bool enabled) {
    return EnableMenuItem(menu, item, wm_p2f(bypos) | (enabled ? MF_ENABLED : MF_DISABLED));
}

// hilite:
dllg std::optional<bool> winmenu_get_hilite(wm_menu menu, wm_item item, bool bypos) {
    auto flags = winmenu_get_flags(menu, item, bypos);
    if (flags) {
        return (*flags & MFS_HILITE) != 0;
    } else return {};
}
dllg bool winmenu_set_hilite(GAME_HWND hwnd, wm_menu menu, wm_item item, bool bypos, bool hilite) {
    return HiliteMenuItem(hwnd, menu, item, wm_p2f(bypos) | (hilite ? MF_HILITE : MF_UNHILITE));
}

// checkmark:
dllg std::optional<bool> winmenu_get_checked(wm_menu menu, wm_item item, bool bypos) {
    auto flags = winmenu_get_flags(menu, item, bypos);
    if (flags) {
        return (*flags & MFS_CHECKED) != 0;
    } else return {};
}
dllg bool winmenu_set_checked(wm_menu menu, wm_item item, bool bypos, bool checked) {
    return CheckMenuItem(menu, item, wm_p2f(bypos) | (checked ? MF_CHECKED : MF_UNCHECKED));
}

// radio:
dllg std::optional<bool> winmenu_get_radio(wm_menu menu, wm_item item, bool bypos) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_FTYPE;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return {};
    return (inf.fType & MFT_RADIOCHECK) != 0;
}
dllg bool winmenu_set_radio(wm_menu menu, wm_item item, bool bypos, bool show_as_radio) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_FTYPE;
    if (!GetMenuItemInfoW(menu, item, bypos, &inf)) return false;
    wm_setflag(inf.fType, MFT_RADIOCHECK, show_as_radio);
    return SetMenuItemInfoW(menu, item, bypos, &inf);
}
dllg bool winmenu_set_radio_group(wm_menu menu, wm_item first, wm_item last, wm_item selection, bool bypos) {
    return CheckMenuRadioItem(menu, first, last, selection, wm_p2f(bypos));
}

struct winmenu_item_rect {
    int x, y, width, height;
    winmenu_item_rect(RECT rect) {
        x = rect.left;
        y = rect.top;
        width = rect.right - rect.left + 1;
        height = rect.bottom - rect.top + 1;
    }
};
dllg std::optional<winmenu_item_rect> winmenu_get_item_rect(GAME_HWND hwnd, bool use_hwnd, wm_menu menu, wm_index index) {
    RECT rect{};
    if (!GetMenuItemRect(use_hwnd ? hwnd : NULL, menu, index, &rect)) return {};
    return winmenu_item_rect(rect);
}

dllg int winmenu_item_from_point(GAME_HWND hwnd, bool use_hwnd, wm_menu menu, int x, int y) {
    POINT pt{};
    pt.x = x;
    pt.y = y;
    return MenuItemFromPoint(use_hwnd ? hwnd : NULL, menu, pt);
}
#include "stdafx.h"
#include "winmenu.h"

// add:
dllg bool winmenu_add(wm_menu menu, wm_command command, const char* text, wm_flags flags = 0) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE | MIIM_STRING | MIIM_ID;
    wmii_set_flags(inf, flags);
    inf.wID = command;
    inf.dwTypeData = (wchar_t*)wm_cc(text);
    return InsertMenuItemW(menu, GetMenuItemCount(menu), true, &inf);
}
dllg bool winmenu_add_submenu(wm_menu menu, wm_command command, wm_menu submenu, const char* text, wm_flags flags = 0) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE | MIIM_STRING | MIIM_ID | MIIM_SUBMENU;
    wmii_set_flags(inf, flags);
    inf.wID = command;
    inf.hSubMenu = submenu;
    inf.dwTypeData = (wchar_t*)wm_cc(text);
    return InsertMenuItemW(menu, GetMenuItemCount(menu), true, &inf);
}
dllg bool winmenu_add_separator(wm_menu menu, wm_command command = 0, wm_flags flags = 0) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE | MIIM_ID;
    wmii_set_flags(inf, flags | MFT_SEPARATOR);
    inf.wID = command;
    return InsertMenuItemW(menu, GetMenuItemCount(menu), true, &inf);
}

// insert:
dllg bool winmenu_insert(wm_menu menu, wm_item item, bool bypos, wm_command command, const char* text, wm_flags flags = 0) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE | MIIM_STRING | MIIM_ID;
    wmii_set_flags(inf, flags);
    inf.wID = command;
    inf.dwTypeData = (wchar_t*)wm_cc(text);
    return InsertMenuItemW(menu, item, bypos, &inf);
}
dllg bool winmenu_insert_submenu(wm_menu menu, wm_item item, bool bypos, wm_command command, wm_menu submenu, const char* text, wm_flags flags = 0) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE | MIIM_STRING | MIIM_SUBMENU | MIIM_ID;
    wmii_set_flags(inf, flags);
    inf.wID = command;
    inf.hSubMenu = submenu;
    inf.dwTypeData = (wchar_t*)wm_cc(text);
    return InsertMenuItemW(menu, item, bypos, &inf);
}
dllg bool winmenu_insert_separator(wm_menu menu, wm_item item, bool bypos, wm_command command = 0, wm_flags flags = 0) {
    MENUITEMINFOW inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIIM_STATE | MIIM_FTYPE | MIIM_ID;
    wmii_set_flags(inf, flags | MFT_SEPARATOR);
    inf.wID = command;
    return InsertMenuItemW(menu, item, bypos, &inf);
}

// delete:
dllg bool winmenu_delete(wm_menu menu, wm_item item, bool bypos) {
    return RemoveMenu(menu, item, wm_p2f(bypos));
}
dllg bool winmenu_delete_rec(wm_menu menu, wm_item item, bool bypos) {
    return DeleteMenu(menu, item, wm_p2f(bypos));
}#include "stdafx.h"
#include "winmenu.h"

// manage:
dllg wm_menu winmenu_create_bar() {
    return CreateMenu();
}
dllg wm_menu winmenu_create_popup() {
    return CreatePopupMenu();
}
dllg bool winmenu_destroy(gml_id_destroy<HMENU> menu) {
    return DestroyMenu(menu);
}

// refs:
dllg wm_handle winmenu_get_handle(wm_menu menu) {
    return (wm_handle)menu;
}
dllg wm_menu winmenu_from_handle(wm_handle handle) {
    return (HMENU)handle;
}
dllg bool winmenu_deref(gml_id_destroy<HMENU> menu) {
    return menu != NULL;
}

// misc:
dllg bool winmenu_handle_is_menu(wm_handle handle) {
    return IsMenu((HMENU)handle);
}
dllg bool winmenu_equals(wm_menu menu1, wm_menu menu2) {
    return menu1 == menu2;
}

//
dllg int winmenu_size(wm_menu menu) {
    return GetMenuItemCount(menu);
}

dllg std::optional<wm_item> winmenu_get_default_item(wm_menu menu, bool want_pos, bool recursive, bool allow_disabled) {
    UINT flags = 0;
    if (recursive) flags |= GMDI_GOINTOPOPUPS;
    if (allow_disabled) flags |= GMDI_USEDISABLED;
    auto item = GetMenuDefaultItem(menu, want_pos, flags);
    if (item == (UINT)-1) return {};
    return item;
}
dllg bool winmenu_set_default_item(wm_menu menu, wm_item item, bool want_pos) {
    return SetMenuDefaultItem(menu, item, want_pos);
}

dllg std::optional<uint32_t> winmenu_get_max_height(wm_menu menu) {
    MENUINFO inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIM_MAXHEIGHT;
    if (!GetMenuInfo(menu, &inf)) return {};
    return inf.cyMax;
}
dllg bool winmenu_set_max_height(wm_menu menu, uint32_t max_height) {
    MENUINFO inf{};
    inf.cbSize = sizeof(inf);
    inf.fMask = MIM_MAXHEIGHT;
    inf.cyMax = max_height;
    return SetMenuInfo(menu, &inf);
}#include "stdafx.h"
#include "winmenu.h"

///
enum class wmpf {
    can_right_click = 0x2,
    //
    halign_left = 0x0,
    halign_center = 0x4,
    halign_right = 0x8,
    //
    valign_top = 0x0,
    valign_middle = 0x10,
    valign_bottom = 0x20,
    //
    anim_to_right = 0x400,
    anim_to_left = 0x800,
    anim_to_bottom = 0x1000,
    anim_to_top = 0x2000,
    anim_none = 0x4000,
};
POINT wmGetCursorPosOpt(std::optional<int>& x, std::optional<int>& y) {
    POINT mp{};
    if (x && y) {
        mp.x = *x;
        mp.y = *y;
    } else {
        GetCursorPos(&mp);
        if (x) mp.x = *x;
        if (y) mp.y = *y;
    }
    return mp;
}
dllg wm_item winmenu_show_popup(GAME_HWND hwnd, wm_menu menu, uint32_t flags = 0, std::optional<int> x = {}, std::optional<int> y = {}) {
    #define X(name, val) static_assert((uint32_t)name == (val), #name)
    X(wmpf::can_right_click, TPM_RIGHTBUTTON);
    //
    X(wmpf::halign_left, TPM_LEFTALIGN);
    X(wmpf::halign_center, TPM_CENTERALIGN);
    X(wmpf::halign_right, TPM_RIGHTALIGN);
    //
    X(wmpf::valign_top, TPM_TOPALIGN);
    X(wmpf::valign_middle, TPM_VCENTERALIGN);
    X(wmpf::valign_bottom, TPM_BOTTOMALIGN);
    //
    X(wmpf::anim_none, TPM_NOANIMATION);
    X(wmpf::anim_to_left, TPM_HORNEGANIMATION);
    X(wmpf::anim_to_right, TPM_HORPOSANIMATION);
    X(wmpf::anim_to_bottom, TPM_VERPOSANIMATION);
    X(wmpf::anim_to_top, TPM_VERNEGANIMATION);
    #undef X
    flags |= TPM_RETURNCMD | TPM_NONOTIFY;
    auto mp = wmGetCursorPosOpt(x, y);
    return TrackPopupMenuEx(menu, flags, mp.x, mp.y, hwnd, nullptr);
}
dllg wm_item winmenu_show_popup_outside(GAME_HWND hwnd, wm_menu menu, int exclude_x, int exclude_y, int exclude_width, int exclude_height, uint32_t flags = 0, std::optional<int> x = {}, std::optional<int> y = {}) {
    flags |= TPM_RETURNCMD | TPM_NONOTIFY;
    TPMPARAMS tpmp{};
    tpmp.cbSize = sizeof(tpmp);
    tpmp.rcExclude.left = exclude_x;
    tpmp.rcExclude.top = exclude_y;
    tpmp.rcExclude.right = exclude_x + exclude_width - 1;
    tpmp.rcExclude.bottom = exclude_y + exclude_height - 1;
    auto mp = wmGetCursorPosOpt(x, y);
    return TrackPopupMenuEx(menu, flags, mp.x, mp.y, hwnd, &tpmp);
}#include "stdafx.h"
#include "winmenu.h"
#include <queue>
#include <unordered_map>

struct winmenu_queue_item {
    uint32_t command;
    HWND hwnd;
};
std::queue<winmenu_queue_item> winmenu_bar_queue{};
std::queue<winmenu_queue_item> winmenu_sys_queue{};
std::unordered_map<HWND, WNDPROC> winmenu_baseprocs{};

LRESULT wndproc_hook(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    if (msg == WM_COMMAND) {
        switch (HIWORD(wParam)) {
            case 0: case 1: // menu, accelerator
                winmenu_queue_item item{};
                item.command = LOWORD(wParam);
                item.hwnd = hwnd;
                winmenu_bar_queue.push(item);
                break;
        }
    } else if (msg == WM_SYSCOMMAND) {
        auto cmd = (uint32_t)wParam;
        if (cmd < 0xF000) {
            winmenu_queue_item item{};
            item.command = cmd;
            item.hwnd = hwnd;
            winmenu_sys_queue.push(item);
        }
    }
    auto pair = winmenu_baseprocs.find(hwnd);
    if (pair != winmenu_baseprocs.end()) {
        return CallWindowProc(pair->second, hwnd, msg, wParam, lParam);
    } else return 0;
}
void wndproc_ensure(HWND hwnd) {
    if (winmenu_baseprocs.find(hwnd) != winmenu_baseprocs.end()) return;
    winmenu_baseprocs[hwnd] = (WNDPROC)SetWindowLongPtr(hwnd, GWLP_WNDPROC, (LONG_PTR)wndproc_hook);
}

/// ~
dllg void winmenu_cleanup_for_raw(uintptr_t _hwnd) {
    auto hwnd = (HWND)_hwnd;
    auto pair = winmenu_baseprocs.find(hwnd);
    if (pair == winmenu_baseprocs.end()) return;
    // revert wndproc if it wasn't re-hooked:
    if (GetWindowLongPtr(hwnd, GWLP_WNDPROC) == (LONG_PTR)wndproc_hook) {
        SetWindowLongPtr(hwnd, GWLP_WNDPROC, (LONG_PTR)pair->second);
    }
    winmenu_baseprocs.erase(hwnd);
}

static winmenu_queue_item winmenu_queue_latest{};
dllx double winmenu_queue_size(double _kind) {
    if ((int)_kind > 0) {
        return (double)winmenu_sys_queue.size();
    } else return (double)winmenu_bar_queue.size();
}
dllx double winmenu_queue_pop(double _kind) {
    auto& q = (int)_kind > 0 ? winmenu_sys_queue : winmenu_bar_queue;
    if (q.empty()) return -1;
    winmenu_queue_latest = q.front();
    q.pop();
    return winmenu_queue_latest.command;
}
/// ~
dllg uintptr_t winmenu_queue_hwnd() {
    return (uintptr_t)winmenu_queue_latest.hwnd;
}

/// ~
dllg wm_menu winmenu_bar_get_raw(GAME_HWND hwnd) {
    return GetMenu(hwnd);
}
/// ~
dllg bool winmenu_bar_set_raw(GAME_HWND hwnd, wm_menu menu) {
    wndproc_ensure(hwnd);
    return SetMenu(hwnd, menu);
}
/// ~
dllg bool winmenu_bar_reset_raw(GAME_HWND hwnd) {
    return SetMenu(hwnd, NULL);
}
dllg bool winmenu_bar_redraw(GAME_HWND hwnd) {
    return DrawMenuBar(hwnd);
}
struct wm_bar_info {
    int x, y, width, height;
    int flags;
};
static std::optional<wm_bar_info> winmenu_bar_get_info_impl(HWND hwnd, int kind, std::optional<wm_index> index) {
    MENUBARINFO inf{};
    inf.cbSize = sizeof(inf);
    if (!GetMenuBarInfo(hwnd, kind, index.has_value() ? index.value() + 1 : 0, &inf)) return {};
    wm_bar_info result{};
    result.x = inf.rcBar.left;
    result.width = inf.rcBar.right - inf.rcBar.left + 1;
    result.y = inf.rcBar.top;
    result.height = inf.rcBar.bottom - inf.rcBar.top + 1;
    auto flags = 0;
    if (inf.fBarFocused) flags |= 1;
    if (inf.fFocused) flags |= 2;
    result.flags = flags;
    return result;
}
dllg std::optional<wm_bar_info> winmenu_bar_get_info(GAME_HWND hwnd, std::optional<wm_index> index = {}) {
    return winmenu_bar_get_info_impl(hwnd, OBJID_MENU, index);
}
dllg std::optional<int> winmenu_bar_get_height(GAME_HWND hwnd) {
    MENUBARINFO inf{};
    inf.cbSize = sizeof(inf);
    if (!GetMenuBarInfo(hwnd, OBJID_MENU, 0, &inf)) return {};
    return inf.rcBar.bottom - inf.rcBar.top + 1;
}
#pragma endregion

/// ~
dllg wm_menu winmenu_sysmenu_get_raw(GAME_HWND hwnd, bool revert) {
    wndproc_ensure(hwnd);
    return GetSystemMenu(hwnd, revert);
}
dllg std::optional<wm_bar_info> winmenu_sysmenu_get_info(GAME_HWND hwnd, std::optional<wm_index> index = {}) {
    return winmenu_bar_get_info_impl(hwnd, OBJID_SYSMENU, index);
}