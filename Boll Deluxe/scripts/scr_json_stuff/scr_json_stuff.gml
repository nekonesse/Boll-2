function LoadJSONFromFile(_fileName) {
    //@desc load json from file

    var buffer = buffer_load( _fileName );
    var _string = buffer_read(buffer,buffer_string);
    buffer_delete(buffer);

    var _json = json_parse(_string);
    return _json;

}

function SaveStringToFile(_fileName, _string) {
    //@description save string to file of choice
    
    var _buffer = buffer_create( string_byte_length(_string)+1, buffer_fixed, 1);
    buffer_write(_buffer,buffer_string,_string)
    buffer_save(_buffer,_fileName)
    buffer_delete(_buffer)

}