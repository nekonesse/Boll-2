// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function inview(){
	if (x > view_get_xport(view_current)-64) && (y > view_get_yport(view_current)-64) && (x < view_get_xport(view_current)+view_get_wport(view_current)+64) && (y < view_get_yport(view_current)+view_get_hport(view_current)+64) return 1

	return 0
}