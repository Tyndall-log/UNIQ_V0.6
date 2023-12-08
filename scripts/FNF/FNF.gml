function FNF() {
	var LW_6=floor(room_width/6),n_1,n_2;
	//노란 줄 드로우 할 위치 검색
	n_1=floor(music_wave_position- LW_6            *power(2,music_wave_size))*4;
	n_2=floor(music_wave_position-(LW_6-room_width)*power(2,music_wave_size))*4;
	ds_list_add(music_cut_list,n_1);
	ds_list_add(music_cut_list,n_2);
	ds_list_sort(music_cut_list,true);
	n_1=ds_list_find_index(music_cut_list,n_1);
	n_2=ds_list_find_index(music_cut_list,n_2);
	ds_list_delete(music_cut_list,n_2);
	ds_list_delete(music_cut_list,n_1);
	music_cut_list_FN_1=n_1;
	music_cut_list_FN_2=n_2-1;


}
