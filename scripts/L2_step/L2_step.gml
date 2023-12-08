function L2_step() {
	var LW=room_width,LH=room_height-90;

	//kia_multi_step();
	if keyboard_check_pressed(vk_enter)
	{
		//kia_multi_textbox_target_set(id);
		//room_speed=60;
	}

	if ds_list_find_value(pad_S,2)
	{
		var tt,n,key,V;
		while(current_time-autoplay_CT>=ds_list_find_value(autoplay_time,autoplay_N))
		{
			tt=ds_list_find_value(autoplay_info,autoplay_N)
			autoplay_N++;
			n=string_pos(" ",tt);
			key=string_copy(tt,1,n-1);
			V=string_copy(tt,n+1,string_length(tt)-n);
			if key="t"
			{
				var Y=real(string_char_at(V,1)),X=real(string_char_at(V,3));
				pad_button(Y,X);
				if pad_T_LED[Y,X]<=0 or 100<pad_T_LED[Y,X]
				{
					pad_T_LED[Y,X]=50; //50*5(ms)
				}
				else
				{
					pad_T_LED[Y,X]=150; //50*5(ms)(red)
				}
			}
			else if key=="o"
			{
				var Y=real(string_char_at(V,1)),X=real(string_char_at(V,3));
				pad_button(Y,X);
				pad_T_LED[Y,X]=-1;
			}
			else if key=="f"
			{
				pad_T_LED[string_char_at(V,1),string_char_at(V,3)]=0;
			}
			else if key=="c"
			{
				//체인 결정
				play_chain=real(V);
			
				//초기화
				var a,b;
				for (a=1;a<=8;a++)
				{
					for (b=1;b<=8;b++)
					{
						pad_T_N[a,b]=0;             //클릭 횟수
						pad_T_LED[a,b]=0;           //누른 키 표시
					}
				}
			}
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
						pad_MCLED[space_list[|2]]=V_list[|space_list[|4]];
					}
					else
					{
						pad_LED[space_list[|1],space_list[|2]]=V_list[|space_list[|4]];
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
						//pad_LED_S_T[Y,X]+=real(space_list[|1]);
						//ds_list_replace(pad_LED_info[Y,X],0,string(pad_LED_S_T[Y,X]+real(space_list[|1])-time))
						Loop=false;
					}
				}
				else if space_list[|0]=="off" or space_list[|0]=="f"
				{
					if space_list[|1]=="mc" or space_list[|1]=="m"
					{
						pad_MCLED[space_list[|2]]=V_list[|0];
					}
					else
					{
						pad_LED[space_list[|1],space_list[|2]]=V_list[|0];
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

	var DLT=45+30+75,DLB=45+LH-100-30;
	var XX=30+8,YY=DLT+8+8,a,b,c,d,e,C;
	draw_set_font(font5);
	if mouse_check_button_pressed(mb_left)
	{
		//DisplayLeftMiddle
		if (XX<mouse_x and mouse_x<room_sx-55-8)
		{
			if (YY<mouse_y and mouse_y<DLB-8-8)
			{
				//show_debug_message("1");
				for(a=keysound_list_pos;a<keysound_list_pos+20 and a<ds_list_size(keysound_list_print);a++)
				{
					//show_debug_message("2");
					YY+=string_height(keysound_list_print[|a])
					if mouse_y<YY
					{
						if string_pos("chain",keysound_list_print_info[|a])!=0
						{
							C=real(keysound_list_print_info[|a]);
							show_debug_message("chain"+string(C));
							if keysound_list_display[0,C]
							{
								keysound_list_display[0,C]=false;
								show_debug_message("false");
								while(ds_list_size(keysound_list_print_info)>a+1 and !string_pos("chain",keysound_list_print_info[|a+1]))
								{
									ds_list_delete(keysound_list_print,a+1);
									ds_list_delete(keysound_list_print_info,a+1);
								}
							}
							else
							{
								d=0;
								for(b=0;b<8;b++)
								//for(b=7;b>=0;b--) //x
								{
									//for(c=0;c<8;c++) //y
									for(c=7;c>=0;c--)
									{
										if ds_list_size(pad_KeySound[C,c*8+b])>0
										{
											ds_list_insert(keysound_list_print,a+1+d,"  "+string(b+1)+" "+string(8-c)+" ["+string(ds_list_size(pad_KeySound[C,c*8+b]))+"]");
											ds_list_insert(keysound_list_print_info,a+1+d,string(C*64+c*8+b)+"key");
											d++;
											if keysound_list_display[C,c*8+b]
											{
												e=0;
												repeat(ds_list_size(pad_KeySound[C,c*8+b]))
												{
													ds_list_insert(keysound_list_print,a+1+d,"    "+ds_list_find_value(pad_KeySound[C,c*8+b],e));
													ds_list_insert(keysound_list_print_info,a+1+d,string(C*64+c*8+b)+"music");
													e++;
													d++;
												}
											}
										}
									}
								}
								if 0<d
								{
									keysound_list_display[0,C]=true;
									show_debug_message("true");
								}
							}
						}
						if string_pos("key",keysound_list_print_info[|a])!=0
						{
							b=real(keysound_list_print_info[|a]);
							C=b div 64;
							c=(b mod 64) div 8;
							b=b mod 8;
							show_debug_message("key-num"+string(C)+"-"+string(b+1)+"-"+string(8-c));
							if keysound_list_display[C,c*8+b]
							{
								keysound_list_display[C,c*8+b]=false;
								while(ds_list_size(keysound_list_print_info)>a+1 and string_pos("music",keysound_list_print_info[|a+1]))
								{
									ds_list_delete(keysound_list_print,a+1);
									ds_list_delete(keysound_list_print_info,a+1);
								}
							}
							else
							{
								keysound_list_display[C,c*8+b]=true;
								d=0;
								repeat(ds_list_size(pad_KeySound[C,c*8+b]))
								{
									ds_list_insert(keysound_list_print,a+1+d,"    "+ds_list_find_value(pad_KeySound[C,c*8+b],d));
									ds_list_insert(keysound_list_print_info,a+1+d,string(C*64+c*8+b)+"music");
									d++;
								}
							}
						}
						break;
					}
				}
			}
		}
	
		//DisplayRight
		YY=45+30+8
		if (LW-room_sx+30+8<mouse_x and mouse_x<LW-55-8)
		{
			if (YY<mouse_y and mouse_y<45+LH-30-8)
			{
				var N=0;
				for(a=0;a<ds_list_size(collection_list) and 0<=a;a++)
				{
					if keysound_collection_list_pos<=N and N<keysound_collection_list_pos+30
					{
						YY+=string_height(ds_map_find_value(collection_list[|a],"name"));
						if mouse_y<YY
						{
							keysound_collection_list_display[a]=!keysound_collection_list_display[a];
							//show_debug_message(ds_map_find_value(collection_list[|a],"name"));
							break;
						}
					}
					N++;
					if keysound_collection_list_display[a]
					{
						if keysound_collection_list_pos<N+ds_list_size(ds_map_find_value(collection_list[|a],"cut" ))
						{
							b=max(0,keysound_collection_list_pos-N)+1;
							for(N+=b-1;b<ds_list_size(ds_map_find_value(collection_list[|a],"cut" )) and N<keysound_collection_list_pos+30;b++)
							{
								if ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b)="-"
								{
									YY+=string_height("  "+ds_map_find_value(collection_list[|a],"name")+"_"+string_N(b,4)+".wav");
									if mouse_y<YY
									{
										show_debug_message(ds_map_find_value(collection_list[|a],"name")+"_"+string_N(b,4)+".wav");
										keysound_mouse_pressed=ds_map_find_value(collection_list[|a],"name")+"_"+string_N(b,4)+".wav";
										a=-2;
										break;
									}
								}
								else
								{
									YY+=string_height("  "+ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b));
									if mouse_y<YY
									{
										show_debug_message(ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b));
										keysound_mouse_pressed=ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b);
										a=-2;
										break;
									}
								}
								N++;
							}
						}
						else
						{
							N+=ds_list_size(ds_map_find_value(collection_list[|a],"cut" ))-1;
						}
					}
				}
			}
		}
	
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
	}

	if mouse_check_button_released(mb_left)
	{
		if !(keysound_mouse_pressed="")
		{
			var PX=(mouse_x-room_sx) div M,PY=(mouse_y-room_sy) div M;
			if (0<PX and PX<=8) and (0<PY and PY<=8)
			{
				show_debug_message("음악 배치하기 : "+string(PY)+","+string(PX)+" - "+string(keysound_mouse_pressed));
				ds_list_add(pad_KeySound[play_chain,PY*8+PX-9],keysound_mouse_pressed);
				a=ds_list_find_index(keysound_list_print_info,string(play_chain)+"chain");
				if keysound_list_display[0,play_chain]
				{
					while(ds_list_size(keysound_list_print_info)>a+1 and !string_pos("chain",keysound_list_print_info[|a+1]))
					{
						ds_list_delete(keysound_list_print,a+1);
						ds_list_delete(keysound_list_print_info,a+1);
					}
				}
				keysound_list_display[0,play_chain]=true;
				keysound_list_display[play_chain,PY*8+PX-9]=true;
				d=0;
				for(b=0;b<8;b++)
				//for(b=7;b>=0;b--) //x
				{
					//for(c=0;c<8;c++) //y
					for(c=7;c>=0;c--)
					{
						if ds_list_size(pad_KeySound[play_chain,c*8+b])>0
						{
							ds_list_insert(keysound_list_print,a+1+d,"  "+string(b+1)+" "+string(8-c)+" ["+string(ds_list_size(pad_KeySound[play_chain,c*8+b]))+"]");
							ds_list_insert(keysound_list_print_info,a+1+d,string(play_chain*64+c*8+b)+"key");
							d++;
							if keysound_list_display[play_chain,c*8+b]
							{
								e=0;
								repeat(ds_list_size(pad_KeySound[play_chain,c*8+b]))
								{
									ds_list_insert(keysound_list_print,a+1+d,"    "+ds_list_find_value(pad_KeySound[play_chain,c*8+b],e));
									ds_list_insert(keysound_list_print_info,a+1+d,string(play_chain*64+c*8+b)+"music");
									e++;
									d++;
								}
							}
						}
					}
				}
			}
			keysound_mouse_pressed="";
		}
	}

	if mouse_check_button_pressed(mb_right)
	{
		//DisplayLeftMiddle
		if (XX<mouse_x and mouse_x<room_sx-55-8)
		{
			if (YY<mouse_y and mouse_y<DLB-8-8)
			{
				//show_debug_message("1");
				for(a=keysound_list_pos;a<keysound_list_pos+20 and a<ds_list_size(keysound_list_print);a++)
				{
					//show_debug_message("2");
					YY+=string_height(keysound_list_print[|a])
					if mouse_y<YY
					{
						if string_pos("music",keysound_list_print_info[|a])!=0
						{
							b=real(keysound_list_print_info[|a]);
							C=b div 64;
							c=(b mod 64) div 8;
							b=b mod 8;
							show_debug_message("music-num"+string(C)+"-"+string(b+1)+"-"+string(8-c)+"삭제!");
							if ds_list_size(pad_KeySound[C,c*8+b])=1
							{
								ds_list_clear(pad_KeySound[C,c*8+b]);
								ds_list_delete(keysound_list_print_info,a-1);
								ds_list_delete(keysound_list_print_info,a-1);
								ds_list_delete(keysound_list_print,a-1);
								ds_list_delete(keysound_list_print,a-1);
							}
							else
							{
								d=ds_list_find_index(keysound_list_print_info,string(C*64+c*8+b)+"key");
								ds_list_delete(pad_KeySound[C,c*8+b],a-d-1);
								ds_list_delete(keysound_list_print_info,a);
								ds_list_delete(keysound_list_print,a);
							}
						}
						break;
					}
				}
			}
		}
	}

	if mouse_wheel_up()
	{
		if (30+8<mouse_x and mouse_x<room_sx-30-8)
		{
			if (DLT+8+8<mouse_y and mouse_y<DLB-8-8)
			{
				//DisplayLeftMiddle
				if 0<keysound_list_pos
				{
					keysound_list_pos--;
				}
			}
		}
		if (LW-room_sx+30+8<mouse_x and mouse_x<LW-30-8)
		{
			if (45+30<mouse_y and mouse_y<45+LH-30)
			{
				//DisplayRight
				if 0<keysound_collection_list_pos
				{
					keysound_collection_list_pos--;
				}
			}
		}
	}

	if mouse_wheel_down()
	{
		if (30+8<mouse_x and mouse_x<room_sx-30-8)
		{
			if (DLT+8+8<mouse_y and mouse_y<DLB-8-8)
			{
				//DisplayLeftMiddle
				if keysound_list_pos<ds_list_size(keysound_list_print)-20
				{
					keysound_list_pos++;
				}
			}
		}
		if (LW-room_sx+30+8<mouse_x and mouse_x<LW-30-8)
		{
			if (45+30<mouse_y and mouse_y<45+LH-30)
			{
				//DisplayRight
				b=0;
				for(a=0;a<ds_list_size(collection_list);a++)
				{
					if keysound_collection_list_display[a]
					{
						b+=ds_list_size(ds_map_find_value(collection_list[|a],"cut" ));
					}
					else
					{
						b++;
					}
				}
				if keysound_collection_list_pos<b-30
				{
					keysound_collection_list_pos++;
				}
			}
		}
	}



}
