function L0_step() {
	
	function Midi_output_push(p, v)
	{
		var a = (p div 10)
		var b = p % 10
		midi_output_velocity_set(Midi_output_id[0], b, a, v)
	}
	//function Midi_output_send()
	//{
	//}
	
	var LW=room_width,LH=room_height-90*DPI;

	//오디오 자동 파기 (메모리 누수 방지)
	var a;
	for(a=0;a<ds_list_size(audio_play_ID);a++)
	{
		if !audio_is_playing(ds_list_find_value(audio_play_ID,a))
		{
			audio_free_buffer_sound(ds_list_find_value(audio_ID,a));
			if 0<=ds_list_find_value(audio_buffer_ID,a)
			{
				buffer_delete(ds_list_find_value(audio_buffer_ID,a));
			}
			ds_list_delete(audio_play_ID  ,a);
			ds_list_delete(audio_ID       ,a);
			ds_list_delete(audio_buffer_ID,a);
			show_debug_message("누수 방지!")
		}
	}

	//자동재생
	if ds_list_find_value(pad_S,2)
	{
		//스크롤 부분
		if autoplay_bar_click
		{
			if mouse_check_button_released(mb_left)
			{
				var time=max(0,min(1,(mouse_x-LW*0.04)/(LW*0.2)))*autoplay_max_time;
				if time<(autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST
				{
					if autoplay_stop
					{
						autoplay_stop_ST=time+autoplay_list_ST;
					}
					else
					{
						autoplay_list_ST=current_time-time;
					}
		
					autoplay_list_N=min(ds_list_size(autoplay_list)-1,autoplay_list_N)
					while(0<autoplay_list_N and (autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST<=array_get(autoplay_list[|autoplay_list_N],0))
					{
						var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
						pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
						autoplay_list_N--;
					}
					for(a=1;a<=8;a++){for(b=0;b<=8;b++){pad_T_LED[a,b]=0;Midi_output_push((9-a)*10+b,0);}}
				}
				else
				{
					if autoplay_stop
					{
						autoplay_stop_ST=time+autoplay_list_ST;
					}
					else
					{
						autoplay_list_ST=current_time-time;
					}
		
					while(autoplay_list_N<ds_list_size(autoplay_list) and (autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST>=array_get(autoplay_list[|autoplay_list_N],0))
					{
						if autoplay_list_N<ds_list_size(autoplay_list)
						{
							var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
							pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
						}
						autoplay_list_N++;
					}
					for(a=1;a<=8;a++){for(b=0;b<=8;b++){pad_T_LED[a,b]=0;Midi_output_push((9-a)*10+b,0);}}
				}
				autoplay_bar_click=false;
			}
		}
		else
		{
			if mouse_check_button_pressed(mb_left)
			{
				if (LW*0.04<=mouse_x and mouse_x<=LW*0.24) and (45*DPI+LH*0.31-3*DPI<=mouse_y and mouse_y<=45*DPI+LH*0.31+3*DPI)
				{
					autoplay_bar_click=true;
				}
			}
		}
	
		if keyboard_check_pressed(vk_space)
		{
			if autoplay_stop
			{
				autoplay_list_ST+=current_time-autoplay_stop_ST;
				autoplay_stop=false;
			}
			else
			{
				autoplay_stop_ST=current_time;
				autoplay_stop=true;
			}
		}
		if keyboard_check_pressed(vk_left) and 0<ds_list_size(autoplay_list)
		{
			if autoplay_stop
			{
				autoplay_stop_ST=max(autoplay_stop_ST-3000,autoplay_list_ST);
			}
			else
			{
				autoplay_list_ST=min(current_time,max(autoplay_list_ST,current_time-array_get(autoplay_list[|ds_list_size(autoplay_list)-1],0))+3000);
			}
		
			autoplay_list_N=min(ds_list_size(autoplay_list)-1,autoplay_list_N)
			while(0<autoplay_list_N and (autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST<=array_get(autoplay_list[|autoplay_list_N],0))
			{
				var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
				pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
				var N=max(0,min(ds_list_size(autoplay_list)-1,autoplay_list_N+1));
				Midi_output_push((9-array_get(autoplay_list[|N],3))*10+array_get(autoplay_list[|N],4),0);
				autoplay_list_N--;
			}
			for(a=1;a<=8;a++){for(b=0;b<=8;b++){pad_T_LED[a,b]=0;}}
		}
		if keyboard_check_pressed(vk_right) and 0<ds_list_size(autoplay_list)
		{
			if autoplay_stop
			{
				autoplay_stop_ST+=3000;
			}
			else
			{
				autoplay_list_ST-=3000;
			}
		
			while(autoplay_list_N<ds_list_size(autoplay_list) and (autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST>=array_get(autoplay_list[|autoplay_list_N],0))
			{
				Midi_output_push((9-array_get(autoplay_list[|autoplay_list_N],3))*10+array_get(autoplay_list[|autoplay_list_N],4),0);
				if autoplay_list_N<ds_list_size(autoplay_list)
				{
					var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
					pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
				}
				autoplay_list_N++;
			}
			for(a=1;a<=8;a++){for(b=0;b<=8;b++){pad_T_LED[a,b]=0;}}
		}
		if autoplay_stop=false
		{
			while(autoplay_list_N<ds_list_size(autoplay_list) and current_time-autoplay_list_ST>=array_get(autoplay_list[|autoplay_list_N],0))
			{
				//[time,chin,command,y,x,num]
				play_chain=array_get(autoplay_list[|autoplay_list_N],1);
				switch(array_get(autoplay_list[|autoplay_list_N],2))
				{
					case 0:
						pad_T_LED[array_get(autoplay_list[|autoplay_list_N],3),array_get(autoplay_list[|autoplay_list_N],4)]=0;
						break;
					case 1:
						var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
						pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
						pad_button(Y,X);
						pad_T_LED[Y,X]=-1;
						break;
					case 2:
						var Y=array_get(autoplay_list[|autoplay_list_N],3),X=array_get(autoplay_list[|autoplay_list_N],4);
						pad_T_N[Y,X]=array_get(autoplay_list[|autoplay_list_N],5);
						pad_button(Y,X);
						if pad_T_LED[Y,X]<=0 or 100<pad_T_LED[Y,X]
						{
							pad_T_LED[Y,X]=40; //50*5(ms)
						}
						else
						{
							pad_T_LED[Y,X]=140; //(150-100)*5(ms)(red)
						}
						break;
				}
				autoplay_list_N++;
			}
		}
	}
	else
	{
		if keyboard_check_pressed(vk_space)
		{
			pad_S[|2]=true;
			autoplay_CT=current_time;
			autoplay_N=0;
		
			autoplay_list_ST=current_time;
			autoplay_list_N=0;
			autoplay_stop=false;
		}
	}
	
	//pad LED 계산 부분 (pad_LED_info[a,b]->pad_LED[a,b])
	var time=current_time,Loop,a,Y,X;
	for (a=0;a<ds_list_size(pad_LED_priority);a++)
	{
		X=(pad_LED_priority[|a] mod 8)+1;
		Y=(pad_LED_priority[|a] div 8)+1;
		Loop=true;
		if (0<ds_list_size(pad_LED_info[Y,X]))
		{
			while(Loop)
			{
				space(ds_list_find_value(pad_LED_info[Y,X],0));
				if space_list[|0]=="on" or space_list[|0]=="o"
				{
					if space_list[|1]=="mc" or space_list[|1]=="m"
					{
						var N=real(space_list[|2]);
						pad_MCLED[N]=V_list[|space_list[|4]];
					
						//midi
						if 0<Midi_output_id[0]
						{
							if N <= 8       N=90+N        ;
							else if N <= 16 N=99-(N-8 )*10;
							else if N <= 24 N=   (N-16)   ;
							else            N=10+(N-24)*10;
							//Midi_output_send(Midi_output_id[0],space_list[|4] << 16 | N << 8 | 0x90);
							Midi_output_push(N,real(space_list[|4]));
						}
					}
					else if space_list[|1]=="all" or space_list[|1]=="l"
					{
						var k=V_list[|space_list[|3]];
						for(var i=0;i<10;i++)
						{
							for(var j=0;j<10;j++)
							{
								pad_LED[i,j]=k;
								
							}
						}
						for(var i=1;i<=32;i++)
						{
							pad_MCLED[i]=k;
						}
							
						//midi
						if 0<Midi_output_id[0]
						{
							for(var i=0;i<100;i++)
							Midi_output_push(i,real(k));
						}
					}
					else
					{
						if 0<=space_list[|1] and space_list[|1]<10 and 0<=space_list[|2] and space_list[|2]<10
						{
							if space_list[|1]==0 or space_list[|1]==9 or space_list[|2]==0 or space_list[|2]==9
							{
								if      space_list[|2]==0 pad_MCLED[33-space_list[|1]]=V_list[|space_list[|4]];
								else if space_list[|2]==9 pad_MCLED[ 8+space_list[|1]]=V_list[|space_list[|4]];
								else if space_list[|1]==0 pad_MCLED[   space_list[|2]]=V_list[|space_list[|4]];
								else if space_list[|1]==9 pad_MCLED[25-space_list[|2]]=V_list[|space_list[|4]];
							}
							else
							{
								pad_LED[space_list[|1],space_list[|2]]=V_list[|space_list[|4]];
							}
							
							//midi
							if 0<Midi_output_id[0]
							{
								Midi_output_push((9-space_list[|1])*10+space_list[|2],real(space_list[|4]));
							}
						}
					}
				}
				else if space_list[|0]=="delay" or space_list[|0]=="d"
				{
					if pad_LED_S_T[Y,X]+real(space_list[|1])<=time
					{
						pad_LED_S_T[Y,X]+=real(space_list[|1]);
					}
					else
					{
						Loop=false;
					}
				}
				else if space_list[|0]=="off" or space_list[|0]=="f"
				{
					
					if space_list[|1]=="mc" or space_list[|1]=="m"
					{
						var N=real(space_list[|2]);
						pad_MCLED[N]=V_list[|0];
					
						//midi
						if 0<Midi_output_id[0]
						{
							if N <= 8       N=90+N        ;
							else if N <= 16 N=99-(N-8 )*10;
							else if N <= 24 N=   (N-16)   ;
							else            N=10+(N-24)*10;
							Midi_output_push(N,0);
						}
					}
					else
					{
						if 0<=space_list[|1] and space_list[|1]<10 and 0<=space_list[|2] and space_list[|2]<10
						{
							if space_list[|1]==0 or space_list[|1]==9 or space_list[|2]==0 or space_list[|2]==9
							{
								if      space_list[|2]==0 pad_MCLED[33-space_list[|1]]=V_list[|0];
								else if space_list[|2]==9 pad_MCLED[ 8+space_list[|1]]=V_list[|0];
								else if space_list[|1]==0 pad_MCLED[   space_list[|2]]=V_list[|0];
								else if space_list[|1]==9 pad_MCLED[25-space_list[|2]]=V_list[|0];
							}
							else
							{
								pad_LED[space_list[|1],space_list[|2]]=V_list[|0];
							}
							
							//midi
							if 0<Midi_output_id[0]
							{
								Midi_output_push((9-space_list[|1])*10+space_list[|2],0);
							}
						}
					}
				}
				if Loop
				{
					ds_list_delete(pad_LED_info[Y,X],0);
					if 0=ds_list_size(pad_LED_info[Y,X])
					{
						Loop=false;
					}
				}
			}
		}
	}

	if mouse_check_button_pressed(mb_left)
	{
		//패드 및 체인 클릭
		var PX=(mouse_x-room_sx) div M,PY=(mouse_y-room_sy) div M;
		if (0<PX and PX<=9) and (0<PY and PY<9)
		{
			show_debug_message(string(PY)+","+string(PX));
			if PX=9
			{
				//체인 결정
				play_chain=PY;
			
				//초기화
				var a,b;
				for (a=1;a<=8;a++)
				{
					for (b=1;b<=8;b++)
					{
						pad_T_N[a,b]=0;             //클릭 횟수
						//pad_T_LED[a,b]=0;           //누른 키 표시
					}
				}
			}
			else
			{
				pad_button(PY,PX);
			}
		}
	
		//패드 스위치 클릭
		//draw_rectangle(LW*0.04-10,45+LH*0.24-10,LW*0.04+10,45+LH*0.24+10,true);
		if (LW*0.04-10*DPI<mouse_x) and (mouse_x<LW*0.04+10*DPI)
		{
			if (45*DPI+LH*0.10-10*DPI<mouse_y) and (mouse_y<45*DPI+LH*0.10+10*DPI)
			{
				ds_list_replace(pad_S,0,!ds_list_find_value(pad_S,0));
				for (a=1;a<=8;a++)
				{
					for (b=1;b<=8;b++)
					{
						pad_T_LED[a,b]=0;
					}
				}
			}
			if (45*DPI+LH*0.17-10*DPI<mouse_y) and (mouse_y<45*DPI+LH*0.17+10*DPI)
			{
				ds_list_replace(pad_S,1,!ds_list_find_value(pad_S,1));
			}
			if (45*DPI+LH*0.24-10*DPI<mouse_y) and (mouse_y<45*DPI+LH*0.24+10*DPI)
			{
				pad_S[|2]=!pad_S[|2];
				autoplay_CT=current_time;
				autoplay_N=0;
			
				autoplay_list_ST=current_time;
				autoplay_list_N=0;
				autoplay_stop=false;
			}
		}
	}

	//입력 받기
	if 0<Midi_input_id[0]
	{
		while(true)
		{
			var _num = midi_input_num(Midi_input_id[0])
			if _num <= 0 break;
			show_debug_message("midi_input_array: "+string(midi_input_array(Midi_input_id[0], 0)))
			var A=midi_input_array(Midi_input_id[0], 1);
			if string_count("MIDIHub Port",Midi_input_name)
			{
				PY=max(0,floor(A/16)+1);
				PX=(A)%16+1
			}
			else
			{
				PY=max(0,9-floor(A/10));
				PX=A%10
			}
			if midi_input_array(Midi_input_id[0], 0)=176
			{
				show_debug_message(PY)
				show_debug_message(PX)
				if midi_input_array(Midi_input_id[0], 2)!=0 and PY=0
				{
					if PX=3 and 0<ds_list_size(autoplay_list)
					{
						if autoplay_stop
						{
							autoplay_stop_ST=max(autoplay_stop_ST-3000,autoplay_list_ST);
						}
						else
						{
							autoplay_list_ST=min(current_time,max(autoplay_list_ST,current_time-array_get(autoplay_list[|ds_list_size(autoplay_list)-1],0))+3000);
						}
		
						autoplay_list_N=min(ds_list_size(autoplay_list)-1,autoplay_list_N)
						while(0<autoplay_list_N and (autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST<=array_get(autoplay_list[|autoplay_list_N],0))
						{
							var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
							pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
							var N=max(0,min(ds_list_size(autoplay_list)-1,autoplay_list_N+1));
							Midi_output_push((9-array_get(autoplay_list[|N],3))*10+array_get(autoplay_list[|N],4),0);
							autoplay_list_N--;
						}
						for(a=1;a<=8;a++){for(b=0;b<=8;b++){pad_T_LED[a,b]=0;}}
					}
					if PX=4 and 0<ds_list_size(autoplay_list)
					{
						if autoplay_stop
						{
							autoplay_stop_ST+=3000;
						}
						else
						{
							autoplay_list_ST-=3000;
						}
		
						while(autoplay_list_N<ds_list_size(autoplay_list) and (autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST>=array_get(autoplay_list[|autoplay_list_N],0))
						{
							Midi_output_push((9-array_get(autoplay_list[|autoplay_list_N],3))*10+array_get(autoplay_list[|autoplay_list_N],4),0);
							if autoplay_list_N<ds_list_size(autoplay_list)
							{
								var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
								pad_T_N[Y,X]=real(array_get(autoplay_list[|autoplay_list_N],5));
							}
							autoplay_list_N++;
						}
						for(a=1;a<=8;a++){for(b=0;b<=8;b++){pad_T_LED[a,b]=0;}}
					}
					if PX=5
					{
						if pad_S[|2]
						{
							if autoplay_stop
							{
								autoplay_list_ST+=current_time-autoplay_stop_ST;
								autoplay_stop=false;
							}
							else
							{
								autoplay_stop_ST=current_time;
								autoplay_stop=true;
							}
						}
						else
						{
							pad_S[|2]=true;
							autoplay_CT=current_time;
							autoplay_N=0;
						
							autoplay_list_ST=current_time;
							autoplay_list_N=0;
							autoplay_stop=false;
						}
					}
				}
				if PX=9
				{
					//체인 결정
					play_chain=PY;
				
					Midi_output_push((9-PY)*10+9,0);
				
					//초기화
					var a,b;
					for (a=1;a<=8;a++)
					{
						for (b=1;b<=8;b++)
						{
							pad_T_N[a,b]=0;             //클릭 횟수
							//pad_T_LED[a,b]=0;           //누른 키 표시
						}
					}
				}
				continue;
			}
			if midi_input_array(Midi_input_id[0], 2)!=0//0x7F
			{
				if (1<=PX and PX<=8) and (1<=PY and PY<=8)
				{
					if ds_list_find_value(pad_S,2) and autoplay_stop and pad_T[PY,PX]=false and autoplay_list_N<ds_list_size(autoplay_list)
					{
						var Y=array_get(autoplay_list[|autoplay_list_N],3);
						var X=array_get(autoplay_list[|autoplay_list_N],4);
						if PY=Y and PX=X and play_chain=array_get(autoplay_list[|autoplay_list_N],1)
						{
							pad_T_N[Y,X]=array_get(autoplay_list[|autoplay_list_N],5);
							Midi_output_push((9-Y)*10+X,0);
							autoplay_stop_ST=autoplay_list_ST+array_get(autoplay_list[|autoplay_list_N],0);
						
							var N=autoplay_list_N+1;
							while(N<ds_list_size(autoplay_list))
							{
								if array_get(autoplay_list[|N],2)=0
								{
									N++;
								}
								else
								{
									if real(array_get(autoplay_list[|N],0))<=real(array_get(autoplay_list[|autoplay_list_N],0))+30
									{
										Y=real(array_get(autoplay_list[|N],3));
										X=real(array_get(autoplay_list[|N],4));
										if pad_T[Y,X]
										{
											pad_T_N[Y,X]=array_get(autoplay_list[|N],5);
											Midi_output_push((9-Y)*10+X,0);
											autoplay_stop_ST=autoplay_list_ST+array_get(autoplay_list[|N],0);
											autoplay_list_N++;
										}
									}
									break;
								}
							}
							autoplay_list_N++;
						}
					}
					pad_T[PY,PX]=true; //누름 상태
					pad_button(PY,PX);
				}
			}
			else
			{
				pad_T[PY,PX]=false;                //누름 상태
			}
			//Input_Text[|midi_input_array(Midi_input_id[0], 2)]++;
		
			if PLAY_LOG
			{
				//show_message(string(current_time-PLAY_LOG_time)+" : "+string(midi_input_array(Midi_input_id[0], 0))+","+string(midi_input_array(Midi_input_id[0], 1))+","+string(midi_input_array(Midi_input_id[0], 2)))
				file_text_write_string(PLAY_LOG_file,string(current_time-PLAY_LOG_time)+" : "+string(midi_input_array(Midi_input_id[0], 0))+","+string(midi_input_array(Midi_input_id[0], 1))+","+string(midi_input_array(Midi_input_id[0], 2)));
				file_text_writeln(PLAY_LOG_file);
			}
		}
	}
	//LED 전송
	//Midi_output_multi_send(Midi_output_id[0],0x90);


}
