function kia_multi_step() {
	if ime_get(real(window_handle())) {kor = !kor}
	if keyboard_string != ""
	{
	    while(string_length(keyboard_string))
	    {
	        var word = string_copy(keyboard_string,1,1)
	        var i = ord(string_lower(word))-97
	        if kor && i >= 0 && i <= 25
	        {
	            global.kia_text += kia_input(i)
	        }
	        else
	        {
	            global.kia_text += kia_type + word
	            kia_type = ""
	        }
	        keyboard_string = string_delete(keyboard_string,1,1)
	    }
	}

	if push != keyboard_key
	{
	    push = keyboard_key
	    pushtime = 0
	}
	else
	{
	    if keyboard_key { pushtime++ }
	}

	if global.kia_target_instance_before != global.kia_target_instance
	{
	    kti = global.kia_target_instance_before

	    if instance_exists(kti)
	    {
	        ds_list_add(kti.kia_multi_textbox_list,"L"+global.kia_text+global.kia_type)
	        kti.kia_multi_textbox_line_now += 1
	        global.kia_text = ""
	    }
	    else
	    {
	        global.kia_text = ""
	    }
    
	    kti = global.kia_target_instance

	    if instance_exists(kti)
	    {
	        if kti.kia_multi_textbox_line_now > 0
	        {
	            kti.kia_multi_textbox_line_now -= 1
	            find_value = ds_list_find_value(kti.kia_multi_textbox_list,kti.kia_multi_textbox_line_now)
	            global.kia_text = string_copy(find_value,2,string_length(find_value)-1)
	            ds_list_delete(kti.kia_multi_textbox_list, kti.kia_multi_textbox_line_now)
	        }
	    }
    
	    kia_type = ""
    
	    global.kia_target_instance_before = global.kia_target_instance
	}

	kti = global.kia_target_instance;
	if instance_exists(kti)
	{
	    var str_len = string_length(global.kia_text+kia_type)
	    while (kti.kia_multi_textbox_width<string_width(string_copy(global.kia_text+kia_type,1,str_len)))
	    {str_len -= 1}
	    if str_len<string_length(global.kia_text+kia_type)
	    {
	        if (kti.kia_multi_textbox_line_now+1<kti.kia_multi_textbox_line_num)
	        {
	            kia_text_1 = string_copy(global.kia_text,1,str_len)
	            kia_text_2 = string_copy(global.kia_text,str_len+1,string_length(global.kia_text+kia_type)-str_len)
            
	            ds_list_add(kti.kia_multi_textbox_list,"L"+kia_text_1)
            
	            global.kia_text = kia_text_2
            
	            kti.kia_multi_textbox_line_now += 1
	        }
	        else
	        {
	            global.kia_text = string_copy(global.kia_text,1,str_len)
	            kia_type = ""
	        }
	    }
	}

	if keyboard_check_pressed(vk_backspace) || (push = vk_backspace && pushtime > 20 && pushtime % 2 = 0)
	{
	    var kti = global.kia_target_instance;
	    if instance_exists(kti)
	    {
	        if kia_remove()
	        {
	            global.kia_text = string_delete(global.kia_text,string_length(global.kia_text),1)
	        }
	        if string_length(global.kia_text)<1
	        {
	            if 0<kti.kia_multi_textbox_line_now
	            {
	                kti.kia_multi_textbox_line_now -= 1
	                var _find_value = ds_list_find_value(kti.kia_multi_textbox_list,kti.kia_multi_textbox_line_now)
	                global.kia_text = string_copy(_find_value,2,string_length(_find_value)-1)
	                ds_list_delete(kti.kia_multi_textbox_list, kti.kia_multi_textbox_line_now)
                
	                kia_type = ""
	            }
	        }
	    }
	}


	if keyboard_check_pressed(vk_enter)
	{
	    var kti = global.kia_target_instance;
	    if instance_exists(kti)
	    {
	        if (kti.kia_multi_textbox_line_now+1<kti.kia_multi_textbox_line_num)
	        {
	            ds_list_add(kti.kia_multi_textbox_list,"L"+global.kia_text+kia_type)
            
	            global.kia_text = ""
	            kia_type = ""
            
	            kti.kia_multi_textbox_line_now += 1
	        }
	    }
	}

	global.blink++
	if global.blink >= 40 { global.blink = 0 }
	//if global.blink >= 40 { global.blink = 0 }

	global.kia_type = kia_type


}
