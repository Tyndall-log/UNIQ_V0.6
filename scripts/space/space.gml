/// @description space(문자열) 
/// @param 문자열
function space(argument0) {
	ds_list_clear(space_list);
	var tt=argument0,n;
	while(string_count(" ",tt)>0)
	{
		n=string_pos(" ",tt);
		ds_list_add(space_list,string_copy(tt,1,n-1));
		//show_debug_message(tt);
		tt=string_copy(tt,n+1,string_length(tt)-n);
	}
	ds_list_add(space_list,tt);
	//show_debug_message(string_copy(tt,1,n-1));


}
