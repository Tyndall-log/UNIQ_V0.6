/// @description string_N(숫자,자릿수)
/// @param 숫자
/// @param 자릿수
function string_N(argument0, argument1) {
	var T=""
	repeat(argument1-string_length(string(argument0)))
	{
		T+="0"
	}
	return T+string(argument0)


}
