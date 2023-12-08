/// @description bin_read_string(bin, index, count, align)
/// @param bin
/// @param  index
/// @param  count
/// @param  align
function bin_read_string(argument0, argument1, argument2, argument3) {
	var _file = argument0, _ind = argument1, _cou = argument2, _ali = (argument3 != 0), _result = "";

	for(var i = 0; i < _cou; i++) {
	    file_bin_seek(_file, _ind + i);
	    if _ali
	        _result = chr(file_bin_read_byte(_file)) + _result;
	    else
	        _result += chr(file_bin_read_byte(_file));
	}

	return _result;


}
