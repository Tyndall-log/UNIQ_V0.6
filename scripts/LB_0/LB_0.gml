function LB_0() {
	var F=get_open_filename("unipack|*.uni;*.zip","");
	if F!=""
	{
		//초기화
		var a,b;
		for (a=1;a<=8;a++)
		{
			for (b=1;b<=8;b++)
			{
				pad_T_N[a,b]=0;             //클릭 횟수
				pad_T_LED[a,b]=0;           //누른 키 표시
			}
			for (b=0;b<64;b++)
			{
				ds_list_clear(pad_KeySound[a,b]); //음악 파일 위치 리셋
				ds_list_clear(pad_keyLED[a,b]) //LED 리스트 초기화
			}
		}
		ds_list_clear(autoplay_time); //오토 플레이 시간 정보 리셋
		ds_list_clear(autoplay_info); //오토 플레이 누름 정보 리셋
		ds_list_clear(autoplay_list); //오토 플레이 리셋
		ds_list_clear(sounds_list); //음악 리스트 초기화
		var map;
		for(a=0;a<ds_list_size(collection_list);a++)
		{
			map=collection_list[|a];
			//map[?"name"]=""; //모음집 이름
			ds_list_destroy(map[?"file"]); //음악 파일 이름 리스트
			ds_list_destroy(map[?"sect"]); //구간 이름 리스트
			ds_list_destroy(map[?"cut" ]); //음악 자른 위치 리스트
			ds_map_destroy(map);
		}
		ds_list_clear(collection_list);
	
		if directory_exists(working_directory+"Project")
		{
			directory_destroy(working_directory+"Project");
		}
		PJ_F_P=working_directory+"Project";//filename_change_ext(filename_name(F),"");
		ds_list_add(Debug_Text,"경로-"+PJ_F_P);
		if zip_unzip(F,PJ_F_P)<=0
		{
			ds_list_add(Debug_Text,"압축 풀기 실패 - 다른 방법 시도중...")
			show_debug_message("풀기 실패 - 다른 방법 시도중...");
			file_copy(F,"C:\\UNIQ\\UNIPACK.zip")
			//file_rename_ue(F,filename_path(F)+"UNIQ.zip");
			if zip_unzip("C:\\UNIQ\\UNIPACK.zip",PJ_F_P)<=0
			{
				ds_list_add(Debug_Text,"최종 실패");
				show_message("죄송합니다. 압축 풀기에 실패했습니다.");
			}
			else
			{
				ds_list_add(Debug_Text,"다른 방법으로 압축풀기 성공");
			}
			//file_rename_ue(filename_path(F)+"UNIQ.zip",F);
		}
		
		if !file_exists(PJ_F_P+"\\info")
		{
			show_debug_message("복압축된 파일");
			PJ_F_P += "\\"+file_find_first(PJ_F_P+"\\*.*",fa_directory);
		}
		show_debug_message(PJ_F_P);
		
		//info
		if file_exists(PJ_F_P+"\\info")
		{
			show_debug_message("info");
			var F_info=file_text_open_read(PJ_F_P+"\\info"),tt,n;
			while(!file_text_eof(F_info))
			{
				tt=file_text_read_string(F_info);
				n=string_pos("=",tt);
				if (tt!="") and (0<n)
				{
					show_debug_message(string_copy(tt,1,n-1)+" | "+string_copy(tt,n+1,string_length(tt)-n));
					map_info[? string_replace_all(string_copy(tt,1,n-1)," ","")]=string_copy(tt,n+1,string_length(tt)-n);
					//string_copy(str,index,string_pos("=",tt)) string_pos("=",tt)
				}
				file_text_readln(F_info);
			}
			file_text_close(F_info);
		}
		else
		{
			ds_list_add(Debug_Text,"\"info\" 파일 열 수 없음.");
		}
	
		//keySound
		if file_exists(PJ_F_P+"\\keySound")
		{
			show_debug_message("keySound");
			var F_keySound=file_text_open_read(PJ_F_P+"\\keySound"),tt;
			while(!file_text_eof(F_keySound))
			{
				space(file_text_read_string(F_keySound));
				if space_list[|0]!=""
				{
					ds_list_add(pad_KeySound[space_list[|0],real(space_list[|1])*8+real(space_list[|2])-9],space_list[|3]);
				}
				file_text_readln(F_keySound);
			}
			file_text_close(F_keySound);
		}
		else
		{
			ds_list_add(Debug_Text,"\"keySound\" 파일 열 수 없음.");
		}
	
		//autoplay
		if file_exists(PJ_F_P+"\\autoPlay")
		{
			show_debug_message("autoPlay");
			var F_autoPlay=file_text_open_read(PJ_F_P+"\\autoPlay"),tt,key,n,V,time=0,chin=1,X,Y,Z;
			for(a=8;0<a;a--){for(b=8;0<b;b--){Z[a,b]=0;}}
			//array
			while(!file_text_eof(F_autoPlay))
			{
				//[time,chin,command,y,x,num]
				//Y=real(string_char_at(V,1)),X=real(string_char_at(V,3))
				tt=file_text_read_string(F_autoPlay);
				n=string_pos(" ",tt);
				key=string_copy(tt,1,n-1);
				V=string_copy(tt,n+1,string_length(tt)-n);
				if key=="t"
				{
					ds_list_add(autoplay_time,time);
					ds_list_add(autoplay_info,"t "+V);
				
					Y=real(string_char_at(V,1)); X=real(string_char_at(V,3));
					ds_list_add(autoplay_list,[time,chin,2,Y,X,Z[Y,X]]);
					Z[Y,X]++;
				}
				else if key=="on" or key=="o"
				{
					ds_list_add(autoplay_time,time);
					ds_list_add(autoplay_info,"o "+V);
				
					Y=real(string_char_at(V,1)); X=real(string_char_at(V,3));
					ds_list_add(autoplay_list,[time,chin,1,Y,X,Z[Y,X]]);
					Z[Y,X]++;
				}
				else if key=="off" or key=="f"
				{
					ds_list_add(autoplay_time,time);
					ds_list_add(autoplay_info,"f "+V);
				
					Y=real(string_char_at(V,1)); X=real(string_char_at(V,3));
					ds_list_add(autoplay_list,[time,chin,0,Y,X,Z[Y,X]]);
				}
				else if key=="delay" or key=="d"
				{
					time+=real(V);
				}
				else if key=="chain" or key=="c"
				{
					ds_list_add(autoplay_time,time);
					ds_list_add(autoplay_info,"c "+V);
					for(a=8;0<a;a--){for(b=8;0<b;b--){Z[a,b]=0;}}
					chin=real(V);
				}
				file_text_readln(F_autoPlay);
			}
			autoplay_max_time=time; //오토 플레이 최대 시간
			file_text_close(F_autoPlay);
		}
		else
		{
			ds_list_add(Debug_Text,"\"autoplay\" 파일 열 수 없음.");
		}
	
		//keyLED
		if directory_exists(PJ_F_P+"\\keyLED")
		{
			show_debug_message("keyLED");
		
			var tt,key,n,V,time=0,XX,YY;
			tt=file_find_first(PJ_F_P+"\\keyLED\\*.*",0)
			while(tt!="")
			{
				YY=real(string_char_at(tt,3))
				XX=real(string_char_at(tt,5))
				if 0<=XX and XX<10 and 0<=YY and YY<10
				{
					ds_list_add(pad_keyLED[real(string_char_at(tt,1)),YY*8+XX-9],tt);
				}
				tt=file_find_next();
			}
			file_find_close();
		}
		else
		{
			ds_list_add(Debug_Text,"\"keyLED\" 파일 열 수 없음.");
		}
	
		//sounds
		if directory_exists(PJ_F_P+"\\sounds")
		{
			show_debug_message("sounds");
		
			var tt,key,n,V,time=0;
			tt=file_find_first(PJ_F_P+"\\sounds\\*.wav",0)
			while(tt!="")
			{
				ds_list_add(sounds_list,tt);
				tt=file_find_next();
			}
			file_find_close();
		}
		else
		{
			ds_list_add(Debug_Text,"\"sounds\" 파일 열 수 없음.");
		}
	
	
		//UNIQ.UQF
		if file_exists(PJ_F_P+"\\UNIQ.UQF")
		{
			var UNIQ;
			UNIQ=buffer_load(PJ_F_P+"\\UNIQ.UQF");
			buffer_seek(UNIQ, buffer_seek_start, 0); //읽기 위치 초기화
			if buffer_rete(UNIQ,4)=="UNIQ" and buffer_read(UNIQ,buffer_u32)==(buffer_get_size(UNIQ)-8) //UNIQ 파일인지 확인
			{
				var V,VU,K1,K2,P=ds_stack_create();
				V=buffer_rete(UNIQ,4)
				show_debug_message(V);
				VU=buffer_rete(UNIQ,10);
				show_debug_message(VU);
				if real(Version)>real(V)
				{
					show_message_async("불러온 파일이 하위 버전이므로 오류가 발생할 수 있습니다.");
				}
				else if real(Version)<real(V)
				{
					show_message_async("불러온 파일이 상위 버전이므로 오류가 발생할 수 있습니다.\n업데이트를 진행해 주세요!");
				}
			
				while (buffer_tell(UNIQ)<buffer_get_size(UNIQ))
				{
					K1=buffer_rete(UNIQ,4); //이름
					show_debug_message(K1);
					K2=buffer_read(UNIQ,buffer_u32 ); //크기
					ds_stack_push(P,buffer_tell(UNIQ)+K2);
					switch(K1)
					{
						case "Pack":
							//변수 초기화
							collection_list_n=0 //모음집(꾸러미) 선택 번호
						
							while (buffer_tell(UNIQ)<ds_stack_top(P))
							{
								K1=buffer_rete(UNIQ,4); //이름 - [00],[01],[02], ... ,[99]
								show_debug_message(K1);
								K2=buffer_read(UNIQ,buffer_u32 ); //크기
								ds_stack_push(P,buffer_tell(UNIQ)+K2)
								var map=ds_map_create();
								ds_list_add(collection_list,map);
								while (buffer_tell(UNIQ)<ds_stack_top(P))
								{
									K1=buffer_rete(UNIQ,4); //이름
									show_debug_message(K1);
									K2=buffer_read(UNIQ,buffer_u32 ); //크기
									ds_stack_push(P,buffer_tell(UNIQ)+K2)
									switch(K1)
									{
										case "name":
											ds_map_add(map,"name",buffer_read(UNIQ,buffer_string));
											break;
										case "file":
											var list=ds_list_create();
											ds_list_read(list,buffer_read(UNIQ,buffer_string));
											ds_map_add(map,"file",list);
											break;
										case "sect":
											var list=ds_list_create();
											ds_list_read(list,buffer_read(UNIQ,buffer_string));
											ds_map_add(map,"sect",list);
											break;
										case "cut ":
											var list=ds_list_create();
											ds_list_read(list,buffer_read(UNIQ,buffer_string));
											ds_map_add(map,"cut" ,list);
											break;
									}
									buffer_seek(UNIQ, buffer_seek_start, ds_stack_pop(P));
								}
								buffer_seek(UNIQ, buffer_seek_start, ds_stack_pop(P));
							}
						break;
						
					}
					buffer_seek(UNIQ, buffer_seek_start, ds_stack_pop(P));
				}
			}
		}
		else
		{
			show_message_async("안내 : UNIQ 파일이 아니므로 오류가 발생할 수 있습니다.");
		}
		autoplay_list_ST=current_time; //오토 플레이 기준 시간
		autoplay_list_N=0; //오토 플레이 현재 번호
		autoplay_stop=false; //오토 플레이 일시정지
		autoplay_stop_ST=current_time; //오토 플레이 일시정지할 때 시간
	}


}
