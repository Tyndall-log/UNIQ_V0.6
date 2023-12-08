/// @description bin_read_real(bin, index, count, align)
/// @param bin
/// @param  index
/// @param  count
/// @param  align
function bin_read_real(argument0, argument1, argument2, argument3) {
	var _file = argument0, _ind = argument1, _cou = argument2, _ali = (argument3 != 0), _result = 0; //argument3=1 : _ali=true

	for(var _i = 0; _i < _cou; _i++) {
	    file_bin_seek(_file, _ind + _i);
    
	    if _ali
	    {
	        _result += file_bin_read_byte(_file) * power(256, _i);
	        //show_error(string(_result),0)
	    }
	    else
	    {
	        _result = file_bin_read_byte(_file) + _result * 256;
	    }
	}

	return _result;


}
