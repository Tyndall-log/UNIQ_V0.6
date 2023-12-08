function LB_1() {
	var F=get_save_filename("uniQ(.uni)|*.uni|unipack(.zip)|*.zip","입력"),a,S;
	if F!=""
	{
		//현재 작업 저장
		var UNIQ=buffer_create(128,buffer_grow,1), P=ds_stack_create(), map, T; //P - 스텍 고려중...
		buffer_seek (UNIQ, buffer_seek_start, 0); //쓰기 위치 초기화
		buffer_write(UNIQ,buffer_text,"UNIQ"); //UNIQ - 파일 종류
		buffer_write(UNIQ,buffer_u32 ,0); //저장 크기
		ds_stack_push(P,buffer_tell(UNIQ));
		buffer_write(UNIQ,buffer_text,string_N(Version,4)); //버전 ex) 01.0 (항상 4자리)
		buffer_write(UNIQ,buffer_text,Version_Update); //업데이트 날짜
			buffer_write(UNIQ,buffer_text,"Pack"); //Pack - 종류
			buffer_write(UNIQ,buffer_u32 ,0); //저장 크기
			ds_stack_push(P,buffer_tell(UNIQ));
			//buffer_write(UNIQ,buffer_u32 ,ds_list_size(collection_list)); //모음집 개수
			for(a=0;a<ds_list_size(collection_list);a++)
			{
				buffer_write(UNIQ,buffer_text,"["+string_N(a,2)+"]");
				buffer_write(UNIQ,buffer_u32 ,0); //저장 크기
				ds_stack_push(P,buffer_tell(UNIQ));
				map=collection_list[|a]; //map_ID
					buffer_write(UNIQ,buffer_text,"name");
					buffer_write(UNIQ,buffer_u32 ,string_byte_length(map[?"name"])+1); //저장 크기
					buffer_write(UNIQ,buffer_string,map[?"name"]);
				
					buffer_write(UNIQ,buffer_text,"file");
					T=ds_list_write(map[?"file"]);
					buffer_write(UNIQ,buffer_u32 ,string_byte_length(T)+1); //저장 크기
					buffer_write(UNIQ,buffer_string,T);
				
					buffer_write(UNIQ,buffer_text,"sect");
					T=ds_list_write(map[?"sect"]);
					buffer_write(UNIQ,buffer_u32 ,string_byte_length(T)+1); //저장 크기
					buffer_write(UNIQ,buffer_string,T);
				
					buffer_write(UNIQ,buffer_text,"cut ");
					T=ds_list_write(map[?"cut" ]);
					buffer_write(UNIQ,buffer_u32 ,string_byte_length(T)+1); //저장 크기
					buffer_write(UNIQ,buffer_string,T);
				S=ds_stack_pop(P);
				buffer_poke(UNIQ,S-4,buffer_u32,buffer_tell(UNIQ)-S); //크기 수정
			}
			S=ds_stack_pop(P);
			buffer_poke(UNIQ,S-4,buffer_u32,buffer_tell(UNIQ)-S); //크기 수정
		S=ds_stack_pop(P);
		buffer_poke(UNIQ,S-4,buffer_u32,buffer_tell(UNIQ)-S); //크기 수정
	
		buffer_save(UNIQ,PJ_F_P+"\\UNIQ.UQF");
		//파일 압축
		zip_zip(PJ_F_P+"\\",F);
	}


}
