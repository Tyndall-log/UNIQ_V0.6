/// @description zip_zip(load-folder,save-file)
/// @param load-folder
/// @param save-file
function zip_zip(argument0, argument1) {
	var a,_ZIP=ds_map_create(),n,m;
	ds_map_add(_ZIP,"buf_1",buffer_create(30,buffer_grow,1));
	ds_map_add(_ZIP,"buf_2",buffer_create(30,buffer_grow,1));
	ds_map_add(_ZIP,"FL_N1",ds_list_create());
	ds_map_add(_ZIP,"CRC32",ds_list_create());
	ds_map_add(_ZIP,"size1",ds_list_create());
	ds_map_add(_ZIP,"size2",ds_list_create());
	ds_map_add(_ZIP,"off_S",ds_list_create());
	//파일 복사를 시작합니다.
	buffer_seek(_ZIP, buffer_seek_start, 0);
	zip_add_dir(_ZIP,argument0,"");
	var buf=_ZIP[?"buf_1"];
	//show_debug_message(_ZIP[?"buf_1"]);
	//show_debug_message(buffer_exists(_ZIP[?"buf_1"]));
	n=buffer_tell(buf);
	for(a=0;a<ds_list_size(_ZIP[?"FL_N1"]);a++)
	{
		//"리틀 엔디안" 형식임에 주의!
		var time = date_current_datetime();
		buffer_write(buf,buffer_u32,33639248); //시그니처(Signature)
		buffer_write(buf,buffer_u16,20); //압축 버전(Version)
		buffer_write(buf,buffer_u16,20); //압축 해제 시 필요 버전(Version needed)
		buffer_write(buf,buffer_u16,0); //바이트 식별자(Flags) - 일반적으로 0
		buffer_write(buf,buffer_u16,8); //압축유형(Compression method) - 일반적으로 8
		buffer_write(buf,buffer_u16,((date_get_hour(time) << 11) | (date_get_minute(time) << 5)) | (date_get_second(time) >> 1)); //파일 수정 시간(File modification time)
		buffer_write(buf,buffer_u16,((date_get_year(time) - 1980 << 9) | (date_get_month(time) - 1 + 1 << 5)) | date_get_day(time)); //파일 수정 날짜(File modification date)
		buffer_write(buf,buffer_u32,ds_list_find_value(_ZIP[?"CRC32"],a)); //파일 오류 체크(Crc-32 checksum)
		buffer_write(buf,buffer_u32,ds_list_find_value(_ZIP[?"size1"],a)); //압축된 데이터의 바이트 크기(Compressed size)
		buffer_write(buf,buffer_u32,ds_list_find_value(_ZIP[?"size2"],a)); //원본 데이터의 바이트 크기(Uncompressed size)
		buffer_write(buf,buffer_u16,string_byte_length(ds_list_find_value(_ZIP[?"FL_N1"],a))); //파일 이름의 길이(File name length)
		buffer_write(buf,buffer_u16,0); //추가 내용의 길이(Extra field length)
		buffer_write(buf,buffer_u16,0); //파일 코멘트 길이(File comm. len)
		buffer_write(buf,buffer_u16,0); //디스크 수(Disk # start)
		buffer_write(buf,buffer_u16,1); //파일 속성(Internal attr.)
		buffer_write(buf,buffer_u32,32); //확장 파일 속성(External attr.)
		buffer_write(buf,buffer_u32,ds_list_find_value(_ZIP[?"off_S"],a)); //개별 Local File Header 시작 주소(Offset of local header)
		buffer_write(buf,buffer_text,ds_list_find_value(_ZIP[?"FL_N1"],a)); //상대 경로를 포함하는 파일 이름(File name)
		//추가 내용의 정보(Extra field) - 없음
	}
	m=buffer_tell(buf);
	show_debug_message(n);
	show_debug_message(m);
	buffer_write(buf,buffer_u32,101010256); //시그니처(Signature)
	buffer_write(buf,buffer_u16,0); //디스크 갯수(Disk Number)
	buffer_write(buf,buffer_u16,0); //Central Directory가 시작되는 디스크 번호(Disk # w/cd)
	buffer_write(buf,buffer_u16,ds_list_size(_ZIP[?"FL_N1"])); //Central Directory에 있는 총 항목 수(Disk entries)
	buffer_write(buf,buffer_u16,ds_list_size(_ZIP[?"FL_N1"])); //모든 항목의 총 수(Total entries)
	buffer_write(buf,buffer_u32,m-n); //Central Directory의 바이트 크기(Central directory size)
	buffer_write(buf,buffer_u32,n); //Central Directory 가 시작되는 오프셋 주소(Offset of cd wrt to starting disk)
	buffer_write(buf,buffer_u16,0); //코멘트 필드의 길이(Comment len)
	//ZIP 파일 코멘트(ZIP file comment) - 없음
	buffer_save(_ZIP[?"buf_1"],argument1)
	ds_list_destroy(_ZIP[?"FL_N1"]);
	ds_list_destroy(_ZIP[?"CRC32"]);
	ds_list_destroy(_ZIP[?"size1"]);
	ds_list_destroy(_ZIP[?"size2"]);
	ds_list_destroy(_ZIP[?"off_S"]);
	buffer_delete(_ZIP[?"buf_1"])


}
