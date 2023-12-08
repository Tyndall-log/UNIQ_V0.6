function L1_step() {
	var LW=room_width,LH=room_height-90,LW_6=floor(LW/6),CW=LH*1/7,CY=45+LH*2/3,a,b;

	//오디오 자동 파기 (메모리 누수 방지)
	for(a=0;a<ds_list_size(audio_play_ID);a++)
	{
		if !audio_is_playing(ds_list_find_value(audio_play_ID,a))
		{
			audio_free_buffer_sound(ds_list_find_value(audio_ID,a));
			if 0<ds_list_find_value(audio_buffer_ID,a)
			{
				buffer_delete(ds_list_find_value(audio_buffer_ID,a));
			}
			ds_list_delete(audio_play_ID  ,a);
			ds_list_delete(audio_ID       ,a);
			ds_list_delete(audio_buffer_ID,a);
			a--;
		}
	}

	//마우스 위치 앞 - 노란줄 위치 검색
	//if music_cut_list_FN_1!=-1
	{
		var K=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4;
		ds_list_add(music_cut_list,K);
		ds_list_sort(music_cut_list,true);
		K=ds_list_find_index(music_cut_list,K);
		ds_list_delete(music_cut_list,K);
		music_cut_list_FM_A=K-1;
	}

	//커서 관리
	if (57<mouse_y and mouse_y<33+LH*1/3) or (57+LH*1/3<mouse_y and mouse_y<33+LH*2/3) //파형 드로우 영역일 경우
	{
		if 0<music_cut_list_replace
		{
			if window_get_cursor()!=cr_size_we
			{
				window_set_cursor(cr_size_we);
			}
		}
		else
		{
			var n=floor(music_wave_position+(mouse_x-6-LW_6)*power(2,music_wave_size))*4,
				m=floor(music_wave_position+(mouse_x+6-LW_6)*power(2,music_wave_size))*4;
			if (music_cut_list[|music_cut_list_FM_A]>=n   and  0<music_cut_list_FM_A and music_cut_list_FM_A<ds_list_size(music_cut_list)-1)
			{
				if window_get_cursor()!=cr_size_we
				{
					window_set_cursor(cr_size_we);
				}
				music_cut_list_FM_C=music_cut_list_FM_A; //마우스 근처 위치
			}
			else
			{
				if (music_cut_list[|music_cut_list_FM_A+1]<=m and -1<music_cut_list_FM_A and music_cut_list_FM_A<ds_list_size(music_cut_list)-2)
				{
					if window_get_cursor()!=cr_size_we
					{
						window_set_cursor(cr_size_we);
					}
					music_cut_list_FM_C=music_cut_list_FM_A+1; //마우스 근처 위치
				}
				else
				{
					if 0<music_wave_buffer_H
					{
						if window_get_cursor()!=cr_appstart
						{
							window_set_cursor(cr_appstart);
						}
					}
					else if window_get_cursor()!=cr_default
					{
						window_set_cursor(cr_default);
					}
					music_cut_list_FM_C=-1; //마우스 근처 위치(없음)
				}
			}
		}
	}
	else
	{
		if 0<music_wave_buffer_H
		{
			if window_get_cursor()!=cr_appstart
			{
				window_set_cursor(cr_appstart);
			}
		}
		else if window_get_cursor()!=cr_default
		{
			window_set_cursor(cr_default);
		}
	}

	if !audio_is_paused(music_cut_audio_play_ID)
	{
		if audio_is_playing(music_cut_audio_play_ID)
		{
			var K=floor(music_wave_position-LW_6*power(2,music_wave_size))*4;
			FNF(); //노란 줄 표시 다시 계산
			//while(music_cut_list[|music_cut_list_FN_1+1]<K)
			//{
			//	music_cut_list_FN_1++;
			//}
			//K=floor(music_wave_position-(LW_6-LW)*power(2,music_wave_size))*4;
			//while(music_cut_list[|music_cut_list_FN_2-1]<K)
			//{
			//	music_cut_list_FN_2++;
			//}
		}
	}

	if keyboard_check_pressed(vk_space)
	{
		if audio_is_paused(music_cut_audio_play_ID)
		{
			audio_resume_sound(music_cut_audio_play_ID);
			audio_sound_set_track_position(music_cut_audio_play_ID,min(music_wave_position/44100,music_wave_buffer_size/44100/4));
		}
		else
		{
			if audio_is_playing(music_cut_audio_play_ID)
			{
				audio_pause_sound(music_cut_audio_play_ID);
			}
			else
			{
				audio_free_buffer_sound(music_cut_all_audio_ID);
				music_cut_all_audio_ID=audio_create_buffer_sound(music_wave_buffer[0],buffer_s16, 44100, 0, music_wave_buffer_size, audio_stereo);
				music_cut_audio_play_ID=audio_play_sound(music_cut_all_audio_ID,0,0);
				audio_sound_set_track_position(music_cut_audio_play_ID,min(music_wave_position/44100,music_wave_buffer_size/44100/4));
				FNF(); //노란 줄 표시 다시 계산
			}
		}
	}

	if keyboard_check_pressed(vk_numpad4) or keyboard_check_pressed(vk_numpad5) or keyboard_check_pressed(vk_numpad6)
	{
		//YYY=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))/power(2,7)*4 //마우스 위치 버퍼 값 읽기
		//show_debug_message(YYY)
		//show_debug_message(buffer_peek(music_wave_buffer[7],YYY,buffer_u8));
		if !audio_is_paused(music_cut_audio_play_ID)
		{
			if audio_is_playing(music_cut_audio_play_ID)
			{
				//노란 줄 생성
				audio_play_sound(speak_sound,0,0);
				//var sou=audio_play_sound(speak_sound,0,0),PS=floor(music_wave_position+-LW_6*power(2,music_wave_size))/power(2,5);
				//audio_sound_gain(sou,max(0.1,buffer_peek(music_wave_buffer[7],PS,buffer_u8)/256),0);
				//// ^- 자동 소리크기 조절
				var k=round(audio_sound_get_track_position(music_cut_audio_play_ID)*44100)*4;
				ds_list_add(music_cut_list,k);
				ds_list_sort(music_cut_list,true);
				music_cut_list_FN_2++; //노란 줄 표시 계산(갯수 증가)
				ds_list_insert(music_cut_list_name,ds_list_find_index(music_cut_list,k)+1,"-"); //파일 이름 추가
			}
		}
	}

#region 왼쪽 마우스 클릭 시
	if mouse_check_button_pressed(mb_left)
	{
		if mb_R_menu>0
		{
			if (mb_R_menu_x < mouse_x) and (mouse_x < mb_R_menu_x+mb_R_menu_w)
			{
				if (mb_R_menu_y < mouse_y) and (mouse_y < mb_R_menu_y+mb_R_menu_h)
				{
					if mb_R_menu="2:1:2"
					{
						switch ((mouse_y-mb_R_menu_y-5) div 14)
						{
							case 0 : //2:1:2:0:0
								show_debug_message("2:1:2:0:0");
								var F;
								F=get_open_filename("WAV|*.wav","음악");
								if F!=""
								{
									window_set_cursor(cr_hourglass); //로딩 커서
									var map=ds_map_create(),new_F=filename_name(F),S=0;
									collection_list_n=ds_list_size(collection_list); //선택된 모음집
									ds_list_add(collection_list,map);
									map[?"name"]=filename_change_ext(new_F,""); //모음집 이름
									map[?"file"]=ds_list_create(); //음악 파일 이름 리스트
									map[?"sect"]=ds_list_create(); //구간 이름 리스트
									map[?"cut" ]=ds_list_create(); //음악 자른 위치 리스트
									ds_list_add(map[?"file"],new_F) //모음집 내용에 음악 파일 추가
									if ds_list_find_index(sounds_list,new_F)=-1
									{
										ds_list_add(sounds_list,new_F); //음악 파일 리스트에 음악 파일 추가
									}
									file_copy(F,working_directory+"Project\\sounds\\"+new_F); //파일 옮기기
								
									//음악 및 버퍼 청소
									audio_stop_all(); //audio_stop_sound(music_cut_audio_play_ID);
									audio_free_buffer_sound(music_cut_all_audio_ID);
									for(a=0;a<ds_list_size(audio_play_ID);a++)
									{
										audio_free_buffer_sound(ds_list_find_value(audio_ID,a));
										if 0<ds_list_find_value(audio_buffer_ID,a)
										{
											buffer_delete(ds_list_find_value(audio_buffer_ID,a));
										}
										ds_list_delete(audio_play_ID  ,a);
										ds_list_delete(audio_ID       ,a);
										ds_list_delete(audio_buffer_ID,a);
										a--;
									}
									buffer_delete(music_wave_buffer[0]);
								
									music_wave_buffer[0]=buffer_create(2,buffer_grow,2); //기본 음악 버퍼 생성
									music_cut_list_name=map[?"sect"]; //music_cut_list_name에 할당
									music_cut_list=map[?"cut"]; //music_cut_list에 할당
									ds_list_add(music_cut_list,0); //0초 추가
									ds_list_add(music_cut_list_name,"-"); //구간 음악 이름 추가
									var F_list=ds_map_find_value(map,"file"); //파일 이름 저장
									for(a=0;a<ds_list_size(F_list);a++)
									{
										show_debug_message(working_directory+"Project\\sounds\\"+string(F_list[|a]));
										FL=wav_load(working_directory+"Project\\sounds\\"+string(F_list[|a]));
										buffer_resize(music_wave_buffer[0],S+dSize+power(2,15)*4);
										buffer_copy(FL,Music_Pos,dSize,music_wave_buffer[0],S);
										buffer_delete(FL);
										S+=dSize;
										ds_list_add(music_cut_list,S); //노란 줄 추가
										ds_list_add(music_cut_list_name,"-"); //구간 음악 이름 추가
									}
									music_wave_buffer_size=S; //음악 파일 크기
									for(a=1;a<16;a++)
									{
										ds_list_clear(music_wave_buffer_list[a]);
										buffer_resize(music_wave_buffer[a],ceil(S/power(2,a)/4)*4);
										show_debug_message(ceil(S/power(2,a)/4)*4);
									}
									music_wave_position=0; //위치 초기화
									music_wave_buffer_H=0; //중간 파형 계산 시작
									window_set_cursor(cr_appstart); //비동기 로딩 커서
									FNF();
								}
								break;
							case 1 : //2:1:2:1:0
								show_debug_message("2:1:2:1:0");
								if file_exists(PJ_F_P+"\\autoPlay") and file_exists(PJ_F_P+"\\keySound")
								{
									window_set_cursor(cr_hourglass); //로딩 커서
									var F_autoPlay=file_text_open_read(PJ_F_P+"\\autoPlay"),S=0,map=ds_map_create(),tt,Y,X,FN,Chain=1;
									for (a=1;a<=8;a++)
									{
										for (b=1;b<=8;b++)
										{
											pad_T_N[a,b]=0; //클릭 횟수 초기화
										}
									}
									collection_list_n=ds_list_size(collection_list); //선택된 모음집
									ds_list_add(collection_list,map);
									map[?"name"]="AutoPlay"; //모음집 이름
									map[?"file"]=ds_list_create(); //음악 파일 이름 리스트
									map[?"sect"]=ds_list_create(); //구간 이름 리스트
									map[?"cut" ]=ds_list_create(); //음악 자른 위치 리스트
									music_cut_list_name=map[?"sect"]; //music_cut_list_name에 할당
									music_cut_list=map[?"cut"]; //music_cut_list에 할당
									ds_list_add(music_cut_list,0); //0초 추가
									ds_list_add(music_cut_list_name,"-"); //음악 이름 추가
									while(!file_text_eof(F_autoPlay))
									{
										tt=file_text_read_string(F_autoPlay);
										space(tt);
										if space_list[|0]="on" or space_list[|0]="o" or space_list[|0]="t"
										{
											Y=real(space_list[|1]);
											X=real(space_list[|2]);
											if ds_list_size(pad_KeySound[Chain,Y*8+X-9])!=0
											{
												FN=ds_list_find_value(pad_KeySound[Chain,Y*8+X-9],pad_T_N[Y,X] mod ds_list_size(pad_KeySound[Chain,Y*8+X-9]));
												FL=wav_load(working_directory+"Project\\sounds\\"+FN);
												buffer_resize(music_wave_buffer[0],S+dSize+power(2,15)*4);
												buffer_copy(FL,Music_Pos,dSize,music_wave_buffer[0],S);
												buffer_delete(FL);
												ds_list_add(map[?"file"],FN) //모음집 내용에 음악 파일 추가
												//ds_list_add(sounds_list,FN); //음악 파일 리스트에 음악 파일 추가
												S+=dSize;
												ds_list_add(music_cut_list_name,FN); //음악 이름 추가
												ds_list_add(music_cut_list,S); //노란 줄 추가
												pad_T_N[Y,X]++;
												show_debug_message(working_directory+"Project\\sounds\\"+FN+"크기 : "+string(dSize)+"누적 크기 :"+string(S));
											}
											music_wave_buffer_size=S; //음악 파일 크기
										}
										else if space_list[|0]="chain" or space_list[|0]="c"
										{
											Chain=real(space_list[|1]);
											for (a=1;a<=8;a++)
											{
												for (b=1;b<=8;b++)
												{
													pad_T_N[a,b]=0; //클릭 횟수 초기화
												}
											}
										}
										file_text_readln(F_autoPlay);
									}
									for(a=1;a<16;a++)
									{
										ds_list_clear(music_wave_buffer_list[a]);
										buffer_resize(music_wave_buffer[a],ceil(S/power(2,a)/4)*4);
										show_debug_message(ceil(S/power(2,a)/4)*4);
									}
									file_text_close(F_autoPlay);
									music_wave_position=0; //위치 초기화
									music_wave_buffer_H=0; //중간 파형 계산 시작
									window_set_cursor(cr_appstart); //비동기 로딩 커서
									FNF();
								}
								break;
							case 2 : //2:1:2:2:0
								show_debug_message("2:1:2:2:0");
								break;
							case 3 : //2:1:2:3:0
								show_debug_message("2:1:2:3:0");
								var K=((mb_R_menu_y-CY-5) div 20);
								if 0<=K and K<ds_list_size(collection_list)
								{
									var name=get_string(TL[?"2:1:2:3:1"],"");
									if name!=""
									{
										ds_map_replace(collection_list[|K],"name",name);
									}
								}
								break;
							case 4 : //2:1:2:4:0
								show_debug_message("2:1:2:4:0");
								var K=((mb_R_menu_y-CY-5) div 20);
								if 0<=K and K<ds_list_size(collection_list)
								{
									show_debug_message("!")
									//모음집 정보 삭제
									var map=collection_list[|K]
									ds_list_destroy(map[?"file"]);
									ds_map_destroy(map);
									ds_list_delete(collection_list,K);
								
									//음악 및 버퍼 청소
									audio_stop_all(); //audio_stop_sound(music_cut_audio_play_ID);
									audio_free_buffer_sound(music_cut_all_audio_ID);
									for(a=0;a<ds_list_size(audio_play_ID);a++)
									{
										audio_free_buffer_sound(ds_list_find_value(audio_ID,a));
										if 0<ds_list_find_value(audio_buffer_ID,a)
										{
											buffer_delete(ds_list_find_value(audio_buffer_ID,a));
										}
										ds_list_delete(audio_play_ID  ,a);
										ds_list_delete(audio_ID       ,a);
										ds_list_delete(audio_buffer_ID,a);
										a--;
									}
									buffer_delete(music_wave_buffer[0]);
								
									//나머지 부분 삭제
									music_wave_buffer[0]=buffer_create(2,buffer_grow,2); //음악 버퍼 생성
									ds_list_clear(music_cut_list); //노란 줄 초기화
									ds_list_clear(music_cut_list_name); //음악 파일 이름 초기화
									for(a=1;a<16;a++)
									{
										ds_list_clear(music_wave_buffer_list[a]); //최적화 유도 버퍼 초기화(계산 단축 유도)
										buffer_resize(music_wave_buffer[a],0); //축소 버퍼 초기화
									}
									music_wave_position=0; //위치 초기화
								}
								break;
							case 5 : //2:1:2:5:0
								show_debug_message("2:1:2:5:0");
								break;
						}
					}
					if mb_R_menu="2:1:1"
					{
						switch ((mouse_y-mb_R_menu_y-5) div 14)
						{
							case 0 : //2:1:1:0:0
								show_debug_message("2:1:1:0:0 - "+TL[? "2:1:1:0:0"]);
								music_cut_list_copy=ds_list_create();
								n_1=music_cut_section_1*4;
								n_2=music_cut_section_2*4;
								ds_list_add(music_cut_list,n_1);
								ds_list_add(music_cut_list,n_2);
								ds_list_sort(music_cut_list,true);
								n_1=ds_list_find_index(music_cut_list,n_1);
								n_2=ds_list_find_index(music_cut_list,n_2)-1;
								ds_list_delete(music_cut_list,n_1);
								ds_list_delete(music_cut_list,n_2);
								n_1=max(n_1,1);
								n_2=min(n_2,ds_list_size(music_cut_list)-1);
								for(b=n_2-n_1-1;b>=0;b--)
								{
									ds_list_add(music_cut_list_copy,music_cut_list[|n_1+b]-music_cut_list[|n_1]);
									ds_list_delete(music_cut_list,n_1+b);
									ds_list_delete(music_cut_list_name,n_1+b+1); //파일 이름 삭제
								}
								FNF(); //노란 줄 최적화 재계산
								music_cut_section=0; //비활성화
								break;
							case 1 : //2:1:1:1:0
								show_debug_message("2:1:1:1:0 - "+TL[? "2:1:1:1:0"]);
								music_cut_list_copy=ds_list_create();
								n_1=music_cut_section_1*4;
								n_2=music_cut_section_2*4;
								ds_list_add(music_cut_list,n_1);
								ds_list_add(music_cut_list,n_2);
								ds_list_sort(music_cut_list,true);
								n_1=ds_list_find_index(music_cut_list,n_1);
								n_2=ds_list_find_index(music_cut_list,n_2)-1;
								ds_list_delete(music_cut_list,n_1);
								ds_list_delete(music_cut_list,n_2);
								n_1=max(n_1,1);
								n_2=min(n_2,ds_list_size(music_cut_list)-1);
								for(b=0;b<n_2-n_1;b++)
								{
									ds_list_add(music_cut_list_copy,music_cut_list[|n_1+b]-music_cut_list[|n_1]);
								}
								music_cut_section=0; //비활성화
								break;
							case 2 : //2:1:1:2:0
								show_debug_message("2:1:1:2:0 - "+TL[? "2:1:1:2:0"]);
								music_cut_list_move=ds_list_create();
								n_1=music_cut_section_1*4;
								n_2=music_cut_section_2*4;
								ds_list_add(music_cut_list,n_1);
								ds_list_add(music_cut_list,n_2);
								ds_list_sort(music_cut_list,true);
								n_1=ds_list_find_index(music_cut_list,n_1);
								n_2=ds_list_find_index(music_cut_list,n_2)-1;
								ds_list_delete(music_cut_list,n_1);
								ds_list_delete(music_cut_list,n_2);
								n_1=max(n_1,1);
								n_2=min(n_2,ds_list_size(music_cut_list)-1);
								for(b=0;b<n_2-n_1;b++)
								{
									ds_list_add(music_cut_list_move,music_cut_list[|n_1+b]);
									//ds_list_delete(music_cut_list,n_1+b);
								}
								music_cut_list_move_1=n_1;
								music_cut_list_move_2=n_2;
								music_cut_list_move_R_x=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4;
								music_cut_section=0; //비활성화
								break;
							case 3 : //2:1:1:3:0
								show_debug_message("2:1:1:3:0 - "+TL[? "2:1:1:3:0"]);
								var n_1,n_2;
								n_1=music_cut_section_1*4;
								n_2=music_cut_section_2*4;
								ds_list_add(music_cut_list,n_1);
								ds_list_add(music_cut_list,n_2);
								ds_list_sort(music_cut_list,true);
								n_1=ds_list_find_index(music_cut_list,n_1);
								n_2=ds_list_find_index(music_cut_list,n_2)-1;
								ds_list_delete(music_cut_list,n_1);
								ds_list_delete(music_cut_list,n_2);
								show_debug_message(n_1);
								show_debug_message(n_2);
								a=floor((music_cut_list[|n_2-1]-music_cut_list[|n_1])/(n_2-n_1-1)/4)*4;
								for(b=1;b<n_2-n_1-1;b++)
								{
									ds_list_replace(music_cut_list,b+n_1,music_cut_list[|n_1]+a*b)
								}
								break;
							case 4 : //2:1:1:4:0
								show_debug_message("2:1:1:4:0 - "+TL[? "2:1:1:4:0"]);
								break;
						}
					}
				}
			}
		}
		else
		{
			if mouse_x<LW/6
			{
				if CY<mouse_y and mouse_y<LH+45
				{
					var a,K=((mouse_y-CY-5) div 20),FL,S=0;
					if 0<=K and K<ds_list_size(collection_list)
					{
						//모음집을 클릭했을 경우
						window_set_cursor(cr_hourglass); //로딩 커서
						show_debug_message(K);
						collection_list_n=K; //선택된 모음집
						audio_stop_all(); //audio_stop_sound(music_cut_audio_play_ID);
						audio_free_buffer_sound(music_cut_all_audio_ID);
						for(a=0;a<ds_list_size(audio_play_ID);a++)
						{
							audio_free_buffer_sound(ds_list_find_value(audio_ID,a));
							if 0<ds_list_find_value(audio_buffer_ID,a)
							{
								buffer_delete(ds_list_find_value(audio_buffer_ID,a));
							}
							ds_list_delete(audio_play_ID  ,a);
							ds_list_delete(audio_ID       ,a);
							ds_list_delete(audio_buffer_ID,a);
							a--;
						}
						buffer_delete(music_wave_buffer[0]);
						music_wave_buffer[0]=buffer_create(2,buffer_grow,2);
						music_cut_list_name=ds_map_find_value(collection_list[|K],"sect"); //music_cut_list_name에 할당
						music_cut_list=ds_map_find_value(collection_list[|K],"cut"); //music_cut_list에 할당
						var F_list=ds_map_find_value(collection_list[|K],"file");
						for(a=0;a<ds_list_size(F_list);a++)
						{
							show_debug_message(working_directory+"Project\\sounds\\"+string(F_list[|a]));
							FL=wav_load(working_directory+"Project\\sounds\\"+string(F_list[|a]));
							buffer_resize(music_wave_buffer[0],S+dSize+power(2,15)*4);
							buffer_copy(FL,Music_Pos,dSize,music_wave_buffer[0],S);
							buffer_delete(FL);
							S+=dSize;
						}
						music_wave_buffer_size=S; //음악 파일 크기
						for(a=1;a<16;a++)
						{
							ds_list_clear(music_wave_buffer_list[a]);
							buffer_resize(music_wave_buffer[a],ceil(S/power(2,a)/4)*4);
							show_debug_message(ceil(S/power(2,a)/4)*4);
						}
						music_wave_position=0; //위치 초기화
						music_wave_buffer_H=0; //중간 파형 계산 시작
						window_set_cursor(cr_appstart); //비동기 로딩 커서
						FNF();
					}
				}
			}
			if (57<mouse_y and mouse_y<33+LH*1/3) or (57+LH*1/3<mouse_y and mouse_y<33+LH*2/3) //파형 드로우 영역일 경우
			{
				if keyboard_check(vk_shift)
				{
					music_cut_section=1; //노란줄 선택 영역 활성화
					music_cut_section_1=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size));
					music_cut_section_2=0;
				}
				else
				{
					if keyboard_check(vk_control)
					{
						if -1<music_cut_list_FM_A and music_cut_list_FM_A<ds_list_size(music_cut_list)-1
						{
							var Music=audio_create_buffer_sound(music_wave_buffer[0],buffer_s16, 44100, music_cut_list[|music_cut_list_FM_A], music_cut_list[|music_cut_list_FM_A+1]-music_cut_list[|music_cut_list_FM_A], audio_stereo);
							ds_list_add(audio_play_ID  ,audio_play_sound(Music,0,0));
							ds_list_add(audio_ID       ,Music);
							ds_list_add(audio_buffer_ID,-music_cut_list_FM_A-1);
						}
					}
					else
					{
						if music_cut_list_FM_C=-1
						{
							if 0<floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4 and floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4<music_cut_list[|ds_list_size(music_cut_list)-1]
							{
								if 0<=music_cut_list_copy
								{
									var P;
									for(a=0;a<ds_list_size(music_cut_list_copy);a++)
									{
										P=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4+music_cut_list_copy[|a];
										ds_list_add(music_cut_list,P)
										ds_list_sort(music_cut_list,true);
										ds_list_insert(music_cut_list_name,ds_list_find_index(music_cut_list,P)+1,"-"); //파일 이름 추가
									}
									music_cut_list_FN_2+=ds_list_size(music_cut_list_copy); //노란 줄 표시 계산(갯수 증가)
								}
								else
								{
									if 0<=music_cut_list_move
									{
										//마우스 위치에 노란줄 이동
										var n_1=max(0,music_cut_list[|music_cut_list_move_1-1]-(music_cut_list_move[|0]-(music_cut_list_move_R_x-floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4))),
											n_2=min(0,music_cut_list[|music_cut_list_move_2]-(music_cut_list_move[|ds_list_size(music_cut_list_move)-1]-(music_cut_list_move_R_x-floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4)));
										for (a=0;a<ds_list_size(music_cut_list_move);a++)
										{
											ds_list_replace(music_cut_list,music_cut_list_move_1+a,music_cut_list_move[|a]-(music_cut_list_move_R_x-floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4)+n_1+n_2)
										}
										ds_list_destroy(music_cut_list_move);
										music_cut_list_move=-1;
									}
									else
									{
										//마우스 위치 노란줄 생성
										ds_list_add(music_cut_list,floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4);
										ds_list_sort(music_cut_list,true);
										music_cut_list_FN_2++; //노란 줄 표시 계산(갯수 증가)
										ds_list_insert(music_cut_list_name,music_cut_list_FM_A+2,"-"); //파일 이름 추가
										music_cut_section=0;
									}
								}
							}
						}
						else
						{
							music_cut_list_replace=music_cut_list_FM_C;
						}
					}
				}
			}
		
			//오른쪽 하단 버튼 관리
			var DX=(LW/12-64)/3,DY=(LH/6-64)/3;
			if (LW*5/6<mouse_x) and (45+LH*2/3<mouse_y and mouse_y<45+LH) //오른쪽 하단 구간일 경우
			{
				if 45+LH*5/6-DY-64<mouse_y and mouse_y<45+LH*5/6-DY
				{
					if LW*11/12-DX-64<mouse_x and mouse_x<LW*11/12-DX
					{
						if audio_is_paused(music_cut_audio_play_ID)
						{
							audio_resume_sound(music_cut_audio_play_ID);
							audio_sound_set_track_position(music_cut_audio_play_ID,min(music_wave_position/44100,music_wave_buffer_size/44100/4));
						}
						else
						{
							if audio_is_playing(music_cut_audio_play_ID)
							{
								audio_pause_sound(music_cut_audio_play_ID);
							}
							else
							{
								audio_free_buffer_sound(music_cut_all_audio_ID);
								music_cut_all_audio_ID=audio_create_buffer_sound(music_wave_buffer[0],buffer_s16, 44100, 0, music_wave_buffer_size, audio_stereo);
								music_cut_audio_play_ID=audio_play_sound(music_cut_all_audio_ID,0,0);
								audio_sound_set_track_position(music_cut_audio_play_ID,min(music_wave_position/44100,music_wave_buffer_size/44100/4));
								FNF(); //노란 줄 표시 다시 계산
							}
						}
					}
					if LW*11/12+DX<mouse_x and mouse_x<LW*11/12+DX+64
					{
						audio_pause_sound(music_cut_audio_play_ID);
						for(a=0;a<ds_list_size(audio_play_ID);a++)
						{
							audio_free_buffer_sound(ds_list_find_value(audio_ID,a));
							if 0<ds_list_find_value(audio_buffer_ID,a)
							{
								buffer_delete(ds_list_find_value(audio_buffer_ID,a));
							}
							ds_list_delete(audio_play_ID  ,a);
							ds_list_delete(audio_ID       ,a);
							ds_list_delete(audio_buffer_ID,a);
							a--;
						}
					}
				}
				//자른 음악 파일 저장
				if 45+LH*5/6+DY<mouse_y and mouse_y<45+LH*5/6+DY+64
				{
					if LW*11/12-DX-64<mouse_x and mouse_x<LW*11/12-DX
					{
						//ds_map_find_value(collection_list[|collection_list_n],"file")
						var list=ds_map_find_value(collection_list[|collection_list_n],"file");
						for(a=0;a<ds_list_size(list);a++)
						{
							file_delete(PJ_F_P+"\\sounds\\"+list[|a]);
							ds_list_delete(sounds_list,ds_list_find_index(sounds_list,list[|a]));
						}
						ds_list_clear(list);
						var CN=ds_map_find_value(collection_list[|collection_list_n],"name")+"_";
						for(a=1;a<ds_list_size(music_cut_list);a++)
						{
							show_debug_message(music_cut_list_name[|a]);
							if music_cut_list_name[|a]="-"
							{
								wav_save(PJ_F_P+"\\sounds\\"+CN+string_N(a,4)+".wav",music_wave_buffer[0],music_cut_list[|a-1],music_cut_list[|a]);
								if ds_list_find_index(sounds_list,CN+string_N(a,4)+".wav")<0
								{
									ds_list_add(sounds_list,CN+string_N(a,4)+".wav");
								}
								ds_list_add(list,CN+string_N(a,4)+".wav");
							}
							else
							{
								wav_save(PJ_F_P+"\\sounds\\"+music_cut_list_name[|a],music_wave_buffer[0],music_cut_list[|a-1],music_cut_list[|a]);
								if ds_list_find_index(sounds_list,music_cut_list_name[|a])<0
								{
									ds_list_add(sounds_list,music_cut_list_name[|a]);
								}
								ds_list_add(list,music_cut_list_name[|a]);
							}
						}
					}
					if LW*11/12+DX<mouse_x and mouse_x<LW*11/12+DX+64
					{
						show_debug_message(4);
					}
				}
			}
		}
		mouse_R_x=mouse_x; //마우스 이전 클릭 x좌표
		mouse_R_y=mouse_y; //마우스 이전 클릭 y좌표
		mb_R_menu=0;
	}
#endregion

#region 휠 마우스 클릭 시
	if mouse_check_button_pressed(mb_middle)
	{
		mouse_R_x=mouse_x; //마우스 이전 클릭 x좌표
		mouse_R_y=mouse_y; //마우스 이전 클릭 y좌표
		music_wave_R_position=music_wave_position; //음악 파형 이전 위치
	}
#endregion

#region 오른쪽 마우스 클릭 시
	if mouse_check_button_pressed(mb_right)
	{
		if mb_R_menu=0
		{
			if mouse_x<LW/6
			{
				if CY<mouse_y and mouse_y<LH+45
				{
					mb_R_menu="2:1:2";
					mb_R_menu_x=mouse_x; //메뉴 x좌표
					mb_R_menu_y=mouse_y; //메뉴 y좌표
					mb_R_menu_w=110;
					mb_R_menu_n=6;
					mb_R_menu_h=10+14*mb_R_menu_n;
					//색 결정 조건
					if file_exists(PJ_F_P+"\\autoPlay") and file_exists(PJ_F_P+"\\keySound")
					{
						mb_R_menu_c[1]=c_white;
					}
					else
					{
						mb_R_menu_c[1]=c_gray;
					}
					var K=((mouse_y-CY-5) div 20);
					if 0<=K and K<ds_list_size(collection_list)
					{
						mb_R_menu_c[3]=c_white; //버튼 활성화
						mb_R_menu_c[4]=c_white; //버튼 활성화
						mb_R_menu_c[5]=c_white; //버튼 활성화
					}
					else
					{
						mb_R_menu_c[3]=c_gray; //버튼 비활성화
						mb_R_menu_c[4]=c_gray; //버튼 비활성화
						mb_R_menu_c[5]=c_gray; //버튼 비활성화
					}
				}
			}
			if (57<mouse_y and mouse_y<33+LH*1/3) or (57+LH*1/3<mouse_y and mouse_y<33+LH*2/3) //파형 드로우 영역일 경우
			{
				var K=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size));
				//show_debug_message("K:"+string(K)+",1:"+string(music_cut_section_1)+",2:"+string(music_cut_section_2));
				if music_cut_section=2 and music_cut_section_1<K and K<music_cut_section_2
				{
					mb_R_menu="2:1:1";
					mb_R_menu_x=mouse_x; //메뉴 x좌표
					mb_R_menu_y=mouse_y; //메뉴 y좌표
					mb_R_menu_w=110;
					mb_R_menu_n=4;
					mb_R_menu_h=10+14*mb_R_menu_n;
					mb_R_menu_c[0]=c_white;
					mb_R_menu_c[1]=c_white;
					mb_R_menu_c[2]=c_white;
					mb_R_menu_c[3]=c_white;
				}
				else
				{
					if 0<music_cut_section
					{
						music_cut_section=-1; //선택 영역 제거 대기
					}
				}
				if 0<=music_cut_list_copy
				{
					ds_list_destroy(music_cut_list_copy);
					music_cut_list_copy=-1;
				}
				if 0<=music_cut_list_move
				{
					ds_list_destroy(music_cut_list_move);
					music_cut_list_move=-1;
				}
			}
		}
		else
		{
			mb_R_menu=0;
		}
	}
#endregion

#region 왼쪽 마우스 클릭 중
	if mouse_check_button(mb_left)
	{
		if LW/6<mouse_R_x and mouse_R_x<LW*5/6
		{
			if CY+CW*2<mouse_R_y and mouse_R_y<LH+45
			{
				sounds_list_draw_x=min(0,-(mouse_x-LW/6)/(LW/3*2)*(ceil(ds_list_size(sounds_list)/2)*CW-LW/3*2)); //리스트 표시 위치
			}
		}
		if 33+LH*1/3<mouse_R_y and mouse_R_y<57+LH*1/3
		{
			music_wave_position=floor(max(0,min(LW,mouse_x))/LW*(buffer_get_size(music_wave_buffer[2])));
			FNF(); //노란 줄 표시 다시 계산
		}
		if 0<music_cut_list_replace
		{
			var K=max(min(floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4,music_cut_list[|music_cut_list_replace+1]),music_cut_list[|music_cut_list_replace-1])
			ds_list_replace(music_cut_list,music_cut_list_replace,K);
		}
	}
#endregion

#region 휠 마우스 클릭 중
	if mouse_check_button(mb_middle)
	{
		music_wave_position=music_wave_R_position+floor((mouse_R_x-mouse_x)*power(2,music_wave_size));
		FNF(); //노란 줄 드로우 다시 계산
		//var K=floor(music_wave_position-LW_6*power(2,music_wave_size))*4;
		//while(0<music_cut_list_FN_1 and K<music_cut_list[|music_cut_list_FN_1-1])
		//{
		//	music_cut_list_FN_1--;
		//}
		//K=floor(music_wave_position-(LW_6-LW)*power(2,music_wave_size))*4;
		//while(K<music_cut_list[|music_cut_list_FN_2-1])
		//{
		//	music_cut_list_FN_2--;
		//}
		//K=floor(music_wave_position-LW_6*power(2,music_wave_size))*4;
		//while(music_cut_list[|music_cut_list_FN_1+1]<K)
		//{
		//	music_cut_list_FN_1++;
		//}
		//K=floor(music_wave_position-(LW_6-LW)*power(2,music_wave_size))*4;
		//while(music_cut_list[|music_cut_list_FN_2-1]<K)
		//{
		//	music_cut_list_FN_2++;
		//}
	}
#endregion

#region 오른쪽 마우스 클릭 중
	if mouse_check_button(mb_right)
	{
		if (57<mouse_y and mouse_y<33+LH*1/3) or (57+LH*1/3<mouse_y and mouse_y<33+LH*2/3) //파형 드로우 영역일 경우
		{
			if music_cut_list_FM_C!=-1 and music_cut_list_replace=-1
			{
				var K=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size));
				//show_debug_message("S:"+string(music_cut_section)+",K:"+string(K)+",1:"+string(music_cut_section_1)+",2:"+string(music_cut_section_2));
				if music_cut_section=0 or (music_cut_section=2 and (K<=music_cut_section_1 or music_cut_section_2<=K))
				{
					ds_list_delete(music_cut_list,music_cut_list_FM_C);
					show_debug_message("삭제 : "+string(music_cut_list_FM_C)+"번째");
					music_cut_list_FN_2--; //노란 줄 표시 계산(갯수 감소)
					ds_list_delete(music_cut_list_name,music_cut_list_FM_C+1); //파일 이름 삭제
				}
			}
		}
	}
#endregion

#region 왼쪽 마우스 뗌
	if mouse_check_button_released(mb_left)
	{
		music_cut_list_replace=-1;
		if music_cut_section=1
		{
			music_cut_section_2=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size));
			if floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))<music_cut_section_1
			{
				music_cut_section_2=music_cut_section_1;
				music_cut_section_1=floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size));
			}
			music_cut_section=2;
		}
	}
#endregion

#region 오른쪽 마우스 뗌
	if mouse_check_button_released(mb_right)
	{
		//show_debug_message("!!-1:0!!");
		if music_cut_section=-1
		{
			music_cut_section=0;
		}
	}
#endregion

	if mouse_wheel_up()
	{
		if keyboard_check(vk_control)
		{
			if 1<=music_wave_size
			{
				music_wave_size--;
				music_wave_position+=(mouse_x-LW_6)*power(2,music_wave_size) //마우스 위치에서 확대
				FNF(); //노란 줄 드로우 다시 계산
			}
		}
		else
		{
			if mouse_y<LH*2/3+45
			{
				music_wave_position-=20*power(2,music_wave_size);
				FNF(); //노란 줄 드로우 다시 계산
				////현재 위치에서 주변 노란 줄 검색
				//var K=floor(music_wave_position-LW_6*power(2,music_wave_size))*4;
				//while(0<music_cut_list_FN_1 and K<music_cut_list[|music_cut_list_FN_1-1])
				//{
				//	music_cut_list_FN_1--;
				//}
				//K=floor(music_wave_position-(LW_6-LW)*power(2,music_wave_size))*4;
				//while(0<music_cut_list_FN_2 and K<music_cut_list[|music_cut_list_FN_2-1])
				//{
				//	music_cut_list_FN_2--;
				//}
			}
		}
	}

	if mouse_wheel_down()
	{
		if keyboard_check(vk_control)
		{
			if music_wave_size<15
			{
				music_wave_position-=(mouse_x-LW_6)*power(2,music_wave_size) //마우스 위치에서 축소
				music_wave_size++;
				FNF(); //노란 줄 드로우 다시 계산
			}
		}
		else
		{
			if mouse_y<LH*2/3+45
			{
				music_wave_position+=20*power(2,music_wave_size);
				FNF(); //노란 줄 드로우 다시 계산
				////현재 위치에서 주변 노란 줄 검색
				//var K=floor(music_wave_position-LW_6*power(2,music_wave_size))*4;
				//while(music_cut_list[|music_cut_list_FN_1+1]<K)
				//{
				//	music_cut_list_FN_1++;
				//}
				//K=floor(music_wave_position-(LW_6-LW)*power(2,music_wave_size))*4;
				//while(music_cut_list[|music_cut_list_FN_2-1]<K)
				//{
				//	music_cut_list_FN_2++;
				//}
			}
		}
	}

	if keyboard_check_pressed(vk_enter)
	{
		if 0<=music_cut_list_FM_A and music_cut_list_FM_A<ds_list_size(music_cut_list)-1
		{
			var Music=audio_create_buffer_sound(music_wave_buffer[0],buffer_s16, 44100, music_cut_list[|music_cut_list_FM_A], music_cut_list[|music_cut_list_FM_A+1]-music_cut_list[|music_cut_list_FM_A], audio_stereo);
			ds_list_add(audio_play_ID  ,audio_play_sound(Music,0,0));
			ds_list_add(audio_ID       ,Music);
			ds_list_add(audio_buffer_ID,-music_cut_list_FM_A-1);
			if music_cut_list_FM_A<ds_list_size(music_cut_list)-2
			{
				music_wave_position=music_cut_list[|music_cut_list_FM_A+1]/4-(mouse_x-LW_6)*power(2,music_wave_size)+1;
				FNF();
			}
			//music_wave_position=floor((mouse_R_x-music_cut_list[|music_cut_list_FM_A+1])*power(2,music_wave_size))
		}
	}

	//음악 위치 조정
	if audio_is_playing(music_cut_audio_play_ID)
	{
		if !audio_is_paused(music_cut_audio_play_ID)
		{
			music_wave_position=audio_sound_get_track_position(music_cut_audio_play_ID)*44100;
		}
	}

	//파형계산
	var a,b,R,V_1_max,V_1_min,V_2_max,V_2_min,S=music_wave_size,P=floor(music_wave_position/power(2,S)),M=floor(LW/6),n,SW,SE;
	if 1<=S //and 0<=P-M and P+LW<=buffer_get_size(music_wave_buffer[S])
	{
		if S<7 or (7<S and music_wave_buffer_H<0)
		{
			//중복 방지 계산
			ds_list_add(music_wave_buffer_list[S],P-M);
			ds_list_add(music_wave_buffer_list[S],P-M+LW);
			ds_list_sort(music_wave_buffer_list[S],true);
			n=ds_list_find_index(music_wave_buffer_list[S],P-M);
			if (n mod 2)==1 //겹침 확인
			{
				//겹쳤을 경우
				ds_list_delete(music_wave_buffer_list[S],n);
				SW=ds_list_find_value(music_wave_buffer_list[S],n);
				if ds_list_find_value(music_wave_buffer_list[S],n)==P-M+LW
				{
					ds_list_delete(music_wave_buffer_list[S],n);
					SE=-1;
				}
				else
				{
					ds_list_delete(music_wave_buffer_list[S],n);
					SE=ds_list_find_value(music_wave_buffer_list[S],n);
					if ds_list_find_value(music_wave_buffer_list[S],n+1)==P-M+LW
					{
						ds_list_delete(music_wave_buffer_list[S],n);
						ds_list_delete(music_wave_buffer_list[S],n);
					}
				}
			}
			else
			{
				n++;
				if ds_list_find_value(music_wave_buffer_list[S],n)==P-M+LW
				{
					SW=P-M;
					SE=P-M+LW;
				}
				else
				{
					SW=P-M;
					SE=ds_list_find_value(music_wave_buffer_list[S],n);
					ds_list_delete(music_wave_buffer_list[S],n);
					ds_list_delete(music_wave_buffer_list[S],n);
				}
			}
		}
		if S<7
		{
			//파형 최대,최소 계산
			R=power(2,S);
			for(a=max(0,SW);a<min(buffer_get_size(music_wave_buffer[S])/4,SE);a++)
			{
				b=0;
				V_1_max=0;
				V_1_min=0;
				V_2_max=0;
				V_2_min=0;
				repeat(R)
				{
					V_1_max=max(V_1_max,buffer_peek(music_wave_buffer[0],(a*R+b)*4  ,buffer_s16));
					V_1_min=min(V_1_min,buffer_peek(music_wave_buffer[0],(a*R+b)*4  ,buffer_s16));
					V_2_max=max(V_2_max,buffer_peek(music_wave_buffer[0],(a*R+b)*4+2,buffer_s16));
					V_2_min=min(V_2_min,buffer_peek(music_wave_buffer[0],(a*R+b)*4+2,buffer_s16));
					b++;
				}
				buffer_poke(music_wave_buffer[S],a*4  ,buffer_u8, V_1_max/128  ); //<226
				buffer_poke(music_wave_buffer[S],a*4+1,buffer_u8,-V_1_min/128.1);
				buffer_poke(music_wave_buffer[S],a*4+2,buffer_u8, V_2_max/128  );
				buffer_poke(music_wave_buffer[S],a*4+3,buffer_u8,-V_2_min/128.1);
				//show_debug_message(string(V_1_max)+"|"+string(V_1_min)+"|"+string(V_2_max)+"|"+string(V_2_min));
			}
		}
		if 7<S and music_wave_buffer_H<0
		{
			//파형 최대,최소 계산
			R=power(2,S-7);
			for(a=max(0,SW);a<min(buffer_get_size(music_wave_buffer[S])/4,SE);a++)
			{
				b=0;
				V_1_max=0;
				V_1_min=0;
				V_2_max=0;
				V_2_min=0;
				repeat(R)
				{
					V_1_max=max(V_1_max,buffer_peek(music_wave_buffer[7],(a*R+b)*4  ,buffer_u8));
					V_1_min=max(V_1_min,buffer_peek(music_wave_buffer[7],(a*R+b)*4+1,buffer_u8));
					V_2_max=max(V_2_max,buffer_peek(music_wave_buffer[7],(a*R+b)*4+2,buffer_u8));
					V_2_min=max(V_2_min,buffer_peek(music_wave_buffer[7],(a*R+b)*4+3,buffer_u8));
					b++;
				}
				buffer_poke(music_wave_buffer[S],a*4  ,buffer_u8,V_1_max); //<226
				buffer_poke(music_wave_buffer[S],a*4+1,buffer_u8,V_1_min);
				buffer_poke(music_wave_buffer[S],a*4+2,buffer_u8,V_2_max);
				buffer_poke(music_wave_buffer[S],a*4+3,buffer_u8,V_2_min);
				//show_debug_message(string(V_1_max)+"|"+string(V_1_min)+"|"+string(V_2_max)+"|"+string(V_2_min));
			}
		}
	}

	if -1<music_wave_buffer_H and 0<buffer_get_size(music_wave_buffer[1])
	{
		//중간 파형 최대,최소 계산
		if !surface_exists(music_wave_mini_surface)
		{
			if 0<buffer_get_size(music_wave_mini_buffer)
			{
				music_wave_mini_surface=surface_create(room_width,48); //미니 파형
				buffer_set_surface(music_wave_mini_buffer,music_wave_mini_surface,0);
			}
		}
		surface_set_target(music_wave_mini_surface);
		if music_wave_buffer_H=0
		{
			draw_clear_alpha (c_black, 0);
		}
		draw_set_color(c_white);
		var R=128,H=music_wave_buffer_H;
		for(a=max(0,H);a<min(buffer_get_size(music_wave_buffer[7])/4,H+250);a++)
		{
			b=0;
			V_1_max=0;
			V_1_min=0;
			V_2_max=0;
			V_2_min=0;
			repeat(R)
			{
				V_1_max=max(V_1_max,buffer_peek(music_wave_buffer[0],(a*R+b)*4  ,buffer_s16));
				V_1_min=min(V_1_min,buffer_peek(music_wave_buffer[0],(a*R+b)*4  ,buffer_s16));
				V_2_max=max(V_2_max,buffer_peek(music_wave_buffer[0],(a*R+b)*4+2,buffer_s16));
				V_2_min=min(V_2_min,buffer_peek(music_wave_buffer[0],(a*R+b)*4+2,buffer_s16));
				b++;
			}
			buffer_poke(music_wave_buffer[7],a*4  ,buffer_u8, V_1_max/128  ); //<226
			buffer_poke(music_wave_buffer[7],a*4+1,buffer_u8,-V_1_min/128.1);
			buffer_poke(music_wave_buffer[7],a*4+2,buffer_u8, V_2_max/128  );
			buffer_poke(music_wave_buffer[7],a*4+3,buffer_u8,-V_2_min/128.1);
			b=floor(a*R/(buffer_get_size(music_wave_buffer[2]))*LW)
			draw_line(b,24-V_1_max/4096*3,b,24-V_1_min/4096*3);
			draw_line(b,24-V_2_max/4096*3,b,24-V_2_min/4096*3);
			//show_debug_message(string(V_1_max)+"|"+string(V_1_min)+"|"+string(V_2_max)+"|"+string(V_2_min));
		}
		//gpu_set_blendmode(bm_normal);
		surface_reset_target();
		buffer_get_surface(music_wave_mini_buffer,music_wave_mini_surface,0);
		music_wave_buffer_H+=250;
		if buffer_get_size(music_wave_buffer[7])/4<music_wave_buffer_H
		{
			music_wave_buffer_H=-1;
			window_set_cursor(cr_default); //일반 커서
		}
	}




}
