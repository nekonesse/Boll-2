function directory_list(_directory){
	var _list      = ds_list_create();
	var _finished  = false

	var _firstFile = file_find_first(_directory+"\*", fa_directory);

	if string_length(_firstFile)==0{return _list}

	if directory_exists(_directory+@'\'+_firstFile){
	    ds_list_add(_list,_directory+@'\'+_firstFile);
	}

	while(!_finished){
	    var _file = file_find_next();
	    if string_length(_file)==0{
	        _finished = true;
	        break;
	    }else{
	        var _fullPath = _directory+@'\'+_file
	        if directory_exists(_fullPath){
	            ds_list_add(_list,_fullPath);
	        }
	    }
	}

	file_find_close()
}