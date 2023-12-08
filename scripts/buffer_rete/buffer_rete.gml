/// @description buffer_rete(buffer,size)
/// @param buffer
/// @param size
function buffer_rete(argument0, argument1) {
	var T="";
	repeat(argument1)
	{
		T+=chr(buffer_read(argument0,buffer_u8));
	}
	return T;


}
