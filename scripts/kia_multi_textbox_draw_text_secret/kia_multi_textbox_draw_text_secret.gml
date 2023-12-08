function kia_multi_textbox_draw_text_secret(argument0, argument1) {
	var _length = 0

	var _x = argument0;
	var _y = argument1;

	var _show_text = "";

	for(i=0;i<ds_list_size(kia_multi_textbox_list);i+=1)
	{
	    var find_value = ds_list_find_value(kia_multi_textbox_list,i);
	    if string_length(find_value)>0
	    {
	        _show_text += string_repeat("*",string_length(string_copy(find_value,2,string_length(find_value)-1))) +"#"
	    }
	}

	draw_text(_x,_y,_show_text)

	_y += string_height(_show_text)

	if (global.kia_target_instance == id)
	{
	    txt = global.kia_text
	    txt = string_repeat("*",string_length(txt))
	    draw_text(_x,_y,txt)
	    _length = string_width(txt)
	    if global.kia_type != ""
	    {
	        var _b_c = draw_get_color()
	        if global.blink > 20
	        {
	            draw_rectangle(_x+_length,_y,_x+_length+string_width(global.kia_type),_y+string_height(global.kia_type),false)
	            draw_set_color(c_white)
	        }
	        draw_text(_x+_length,_y,global.kia_type)
	        draw_set_color(_b_c)
	    }
	    else
	    {
	        if global.blink > 20
	        {
	            draw_line(_x+_length+2,_y,_x+_length+2,_y+string_height("가A"))
	        }
	    }
	}


}
