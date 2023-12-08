/// @description Insert description here
// You can write your code in this editor

//var a=1;
//repeat(100)
//{
//	Midi_output_send(Midi_output_id[0],irandom(127) << 16 | a << 8 | 0x90);
//	a++;
//	//Midi_input_stamp();
//}

if PLAY_LOG
{
	PLAY_LOG=false;
	file_text_close(PLAY_LOG_file);
	PLAY_LOG_N++;
}
else
{
	if 0<Midi_input_id[0] or 0<Midi_output_id[0]
	{
		PLAY_LOG=true;
		PLAY_LOG_file=file_text_open_write("..\\Play["+string(PLAY_LOG_N)+"].log");
		file_text_write_string(PLAY_LOG_file,"Midi_output_name : "+string(Midi_output_name));
		file_text_writeln(PLAY_LOG_file);
		file_text_write_string(PLAY_LOG_file,"Midi_input_name : "+string(Midi_input_name));
		file_text_writeln(PLAY_LOG_file);
		PLAY_LOG_time=current_time;
	}
}