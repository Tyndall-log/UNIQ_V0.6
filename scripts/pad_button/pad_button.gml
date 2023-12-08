/// @description space(Y,X) 
/// @param X
/// @param 문자열
function pad_button(argument0, argument1) {
	//음악
	var B,Music,Y=argument0,X=argument1,MN=ds_list_size(pad_KeySound[play_chain,Y*8+X-9]),File;
	if MN>0
	{
		B=wav_load(PJ_F_P+"\\sounds\\"+ds_list_find_value(pad_KeySound[play_chain,Y*8+X-9],pad_T_N[Y,X] mod MN));
		show_debug_message(PJ_F_P+"\\sounds\\"+ds_list_find_value(pad_KeySound[play_chain,Y*8+X-9],pad_T_N[Y,X] mod MN))
		Music=audio_create_buffer_sound(B,buffer_s16, fSampleRate, Music_Pos, dSize, audio_stereo);
		ds_list_add(audio_play_ID  ,audio_play_sound(Music,0,0));
		ds_list_add(audio_ID       ,Music);
		ds_list_add(audio_buffer_ID,B);
	}

	//LED
	pad_LED_S_T[Y,X]=current_time;
	if ds_list_size(pad_keyLED[play_chain,Y*8+X-9])>0
	{
		File=PJ_F_P+"\\keyLED\\"+ds_list_find_value(pad_keyLED[play_chain,Y*8+X-9],pad_T_N[Y,X] mod ds_list_size(pad_keyLED[play_chain,Y*8+X-9]));
		show_debug_message(File);
		if file_exists(File)
		{
			var F_keyLED=file_text_open_read(File),tt;
			ds_list_clear(pad_LED_info[Y,X]);
			while(!file_text_eof(F_keyLED))
			{
				tt=file_text_read_string(F_keyLED);
				ds_list_add(pad_LED_info[Y,X],tt);
				file_text_readln(F_keyLED);
			}
			file_text_close(F_keyLED);
		}
	}

	//우선 순위 기록
	ds_list_delete(pad_LED_priority,ds_list_find_index(pad_LED_priority,Y*8+X-9));
	ds_list_add(pad_LED_priority,Y*8+X-9);

	//
	pad_T_N[Y,X]++;


}
