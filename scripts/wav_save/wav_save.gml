/// @description wav_save(filename,buffer,offset,size)
/// @param filename
/// @param buffer
/// @param offset
/// @param size
function wav_save(argument0, argument1, argument2, argument3) {
	var BM=buffer_create(44,buffer_grow,2);
	buffer_poke (BM, 0 , buffer_text, "RIFF");
	buffer_poke (BM, 4 , buffer_u32 , argument3-argument2+36);
	buffer_poke (BM, 8 , buffer_text, "WAVE");
	buffer_poke (BM, 12, buffer_text, "fmt ");
	buffer_poke (BM, 16, buffer_u32 , 16);
	buffer_poke (BM, 20, buffer_u16 , 1);
	buffer_poke (BM, 22, buffer_u16 , 2);
	buffer_poke (BM, 24, buffer_u32 , 44100);
	buffer_poke (BM, 28, buffer_u32 , 176400);
	buffer_poke (BM, 32, buffer_u16 , 88200);
	buffer_poke (BM, 34, buffer_u16 , 16);
	buffer_poke (BM, 36, buffer_text, "data");
	buffer_poke (BM, 40, buffer_u32 , argument3-argument2);
	show_debug_message("size:"+string(buffer_get_size(argument1)));
	buffer_copy(argument1,argument2,argument3-argument2,BM,44);
	buffer_save(BM,argument0);
	buffer_delete(BM);


}
