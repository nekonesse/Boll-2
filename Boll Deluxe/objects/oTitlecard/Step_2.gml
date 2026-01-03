counter ++

//global.titlebigFont

if (formated_text == false) {
	var arr = string_split(text, " ")
	var i = 0
	repeat(array_length(arr)){
		var org = arr[i]
		var _char = string_char_at(org, 0);
		var _upper = string_upper(_char) == _char
		if _upper {
			arr[i] = "[spr_titlebigfont]" + string_char_at(org, 0) + "[spr_titlesmallfont]" + string_copy(org, 2, string_length(org)-1)
			show_debug_message(arr[i])
		} else {
			arr[i] = "[spr_titlesmallfont]" + org
			show_debug_message(arr[i])
		}
		i++
	}
	//do it again to reconstruct
	i = 0
	text = ""
	repeat(array_length(arr)){
		text += arr[i] + " "
		i++
	}
	formated_text = true
}