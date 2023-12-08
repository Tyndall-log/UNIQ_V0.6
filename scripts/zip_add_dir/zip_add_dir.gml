/// @description zip_add_dir(zip_map,dir,find_dir)
/// @param zip_map
/// @param dir
/// @param find_dir
function zip_add_dir(argument0, argument1, argument2) {

	var file_list=ds_list_create(),map=argument0,buf=map[?"buf_1"],F=file_find_first(argument1+"*.*",fa_directory),tt,a;
	//var _0=argument0,_1=argument1,_2=argument2,_3=argument3;
	while(F!="")
	{
		ds_list_add(file_list,F);
		F=file_find_next();
	}
	file_find_close();
	//show_debug_message("ZAD- 0:"+string(argument0)+" 1:"+string(argument1)+" 2:"+string(argument2));
	for(a=0;a<ds_list_size(file_list);a++)
	{
		tt=argument1+ds_list_find_value(file_list,a);
		//if !file_attributes(tt,fa_directory) //폴더인지 확인합니다.
		if directory_exists(tt) //폴더인지 확인합니다.
		{
			show_debug_message(string(tt)+" [폴더]");
			zip_add_dir(map,tt+"\\",argument2+ds_list_find_value(file_list,a)+"\\");
		}
		else
		{
			var GG=current_time;
			var _ZIP_F=string_replace_all(argument2+ds_list_find_value(file_list,a),"\\","/"),B=buffer_load(tt),C=buffer_compress(B,0,buffer_get_size(B));
			var GG_1=current_time;
			var _CRC32=CRC32(B,0,buffer_get_size(B));
			show_debug_message(string(tt)+" [파일] | 로딩 시간 : "+string(GG_1-GG)+"	CRC32 계산 시간 : "+string(current_time-GG_1));
			ds_list_add(map[?"FL_N1"],_ZIP_F); //파일 이름 추가
			ds_list_add(map[?"CRC32"],_CRC32); //CRC32 추가
			ds_list_add(map[?"size1"],buffer_get_size(C)-6); //압축된 데이터의 바이트 크기 추가
			ds_list_add(map[?"size2"],buffer_get_size(B)); //원본 데이터의 바이트 크기 추가
			ds_list_add(map[?"off_S"],buffer_tell(buf)); //현재 위치 추가
			//"리틀 엔디안" 형식임에 주의!
			var time = date_current_datetime();
			buffer_write(buf,buffer_u32,67324752); //시그니처(Signature)
			buffer_write(buf,buffer_u16,20); //압축 버전(Version)
			buffer_write(buf,buffer_u16,0); //바이트 식별자(Flags) - 일반적으로 0
			buffer_write(buf,buffer_u16,8); //압축유형(Compression method) - 일반적으로 8
			buffer_write(buf,buffer_u16,((date_get_hour(time) << 11) | (date_get_minute(time) << 5)) | (date_get_second(time) >> 1)); //파일 수정 시간(File modification time)
			buffer_write(buf,buffer_u16,((date_get_year(time) - 1980 << 9) | (date_get_month(time) - 1 + 1 << 5)) | date_get_day(time)); //파일 수정 날짜(File modification date)
			buffer_write(buf,buffer_u32,_CRC32); //파일 오류 체크(Crc-32 checksum)
			buffer_write(buf,buffer_u32,buffer_get_size(C)-6); //압축된 데이터의 바이트 크기(Compressed size)
			buffer_write(buf,buffer_u32,buffer_get_size(B)); //원본 데이터의 바이트 크기(Uncompressed size)
			buffer_write(buf,buffer_u16,string_byte_length(_ZIP_F)); //파일 이름의 길이(File name length)
			buffer_write(buf,buffer_u16,0); //추가 내용의 길이(Extra field length)
			buffer_write(buf,buffer_text,_ZIP_F); //상대 경로를 포함하는 파일 이름(File name)
			//추가 내용의 정보(Extra field) - 없음
			buffer_copy(C,2,buffer_get_size(C)-6,buf,buffer_tell(buf)); //압축 파일 데이터
			buffer_seek(buf, buffer_seek_start,buffer_tell(buf)+buffer_get_size(C)-6);
			buffer_delete(B);
			buffer_delete(C);
		}
	}
	ds_list_destroy(file_list);


}
