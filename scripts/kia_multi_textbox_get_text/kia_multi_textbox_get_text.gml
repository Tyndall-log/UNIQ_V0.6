function kia_multi_textbox_get_text() {
	var _show_text = "";

	for(i=0;i<ds_list_size(kia_multi_textbox_list);i+=1)
	{
	    var find_value = ds_list_find_value(kia_multi_textbox_list,i);
	    if string_length(find_value)>0
	    {
	        _show_text += string_copy(find_value,2,string_length(find_value)-1) +"#"
	    }
	}

	if (global.kia_target_instance == id)
	{
	   _show_text += global.kia_text
	}

	return _show_text;


}
