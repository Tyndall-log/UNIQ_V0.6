function L2_draw() {
	var LW=room_width,LH=room_height-90;

	//show_debug_message(ds_list_find_value(V_list,0))
	//패드 LED 그리기
	var X,Y,MC;
	draw_set_font(fn_num);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	for(X=1;X<9;X++)
	{
		for(Y=1;Y<9;Y++)
		{
			draw_set_color(pad_LED[Y,X]);
			draw_roundrect(room_sx+M*(X+0.07),room_sy+M*(Y+0.07),room_sx+M*(X+0.93),room_sy+M*(Y+0.93),false);
			draw_set_color(c_black);
			draw_set_alpha(0.15);
			draw_text(room_sx+M*(X+0.5),room_sy+M*(Y+0.5),ds_list_size(pad_KeySound[play_chain,Y*8+X-9]))
			//누른 키 표시
			if pad_T_LED[Y,X]!=0 and pad_T_LED[Y,X]!=100 
			{
				draw_set_color(c_yellow);
				draw_set_alpha(0.5);
				draw_circle(room_sx+M*(X+0.5),room_sy+M*(Y+0.5),M*0.25,false);
				draw_set_alpha(1);
				if 100<pad_T_LED[Y,X]
				{
					draw_set_color(c_red);
				}
				else
				{
					draw_set_color(c_blue);
				}
				draw_circle(room_sx+M*(X+0.5),room_sy+M*(Y+0.5),M*0.1,false);
				pad_T_LED[Y,X]-=1;
			}
			draw_set_alpha(1);
			//draw_set_color(make_color_rgb(200,200,255));
		}
	}

	//탑 라이트 그리기
	for(MC=1;MC<=32;MC++)
	{
		draw_set_color(pad_MCLED[MC]);
		if MC<=8
		{
			draw_circle(room_sx+M*(MC+0.5),room_sy+M*(   0.5),(M*0.86)/2,false);
		}
		else if MC<=16
		{
			if play_chain==MC-8
			{
				draw_set_color(make_color_rgb(255,255,255));
			}
			draw_circle(room_sx+M*(   9.5),room_sy+M*(MC-8+0.5),(M*0.86)/2,false);
		}
		else if MC<=24
		{
			draw_circle(room_sx+M*(9.5-MC+16),room_sy+M*(9.5   ),(M*0.86)/2,false);
		}
		else
		{
			draw_circle(room_sx+M*(0.5   ),room_sy+M*(9.5-MC+24),(M*0.86)/2,false);
		}
	}

	//번호 그리기
	draw_set_font(malgeun_8);
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	for(Y=1;Y<9;Y++)
	{
		draw_text_transformed(room_sx+M*(1+0.32),room_sy+M*(Y+0.5),string(9-Y),1,1,270);
	}
	for(X=1;X<9;X++)
	{
		draw_text(room_sx+M*(X+0.5),room_sy+M*(8+0.72),string(X));
	}
	draw_set_halign(fa_left);

	//좌우 그리기
	var DLT=45+30+75,DLB=45+LH-100-30;
	draw_set_color(make_color_rgb(20,20,30));
	draw_rectangle(30,45+30,room_sx-30,DLT-8,false);
	draw_rectangle(30,DLT+8,room_sx-30,DLB-8,false);
	draw_rectangle(30,DLB+8,room_sx-30,45+LH-30,false);
	draw_rectangle(LW-room_sx+30,45+30,LW-30,45+LH-30,false);

	//DisplayLeftTop
	draw_set_color(c_white);
	draw_set_font(font5);
	draw_text(30+8,45+30+8,TL[?"3:0:0:0:0"]);
	var a=0,b=45+30+8,c=30+8;
	for(a=0;a<3;a++)
	{
		c+=string_width(TL[?"3:0:0:"+string(a)+":0"]+" ");
		if a=keysound_display
		{
			draw_set_color(c_white);
		}
		else
		{
			draw_set_color(c_gray);
		}
		draw_text(c,b,TL[?"3:0:0:"+string(a+1)+":0"]);
	}
	draw_set_color(c_white);
	b+=string_height(TL[?"3:0:0:0:0"]);
	draw_text(30+8,b,TL[?"3:0:1:0:0"]+" "+TL[?"3:0:1:1:"+string(keysound_standard)]);
	b+=string_height(TL[?"3:0:1:0:0"]);
	draw_text(30+8,b,TL[?"3:0:2:0:0"]);
	c=30+8+string_width(TL[?"3:0:2:0:0"]+" ");
	for(a=0;a<ds_list_size(keysound_sort)-1;a++)
	{
		draw_text(c,b,TL[?"3:0:2:"+string(keysound_sort[|a])+":"+string(keysound_display)]+" >");
		c+=string_width(TL[?"3:0:2:"+string(keysound_sort[|a])+":"+string(keysound_display)]+" > ");
	}
	draw_text(c,b,TL[?"3:0:2:"+string(keysound_sort[|a])+":"+string(keysound_display)]);

	//DisplayLeftMiddle
	var XX=30+8,YY=DLT+8+8,a,print="";
	for(a=keysound_list_pos;a<keysound_list_pos+20 and a<ds_list_size(keysound_list_print);a++)
	{
		print+=keysound_list_print[|a]+"\n";
	}
	draw_text(XX,YY,print);
	draw_set_color(make_color_rgb(40,40,60));
	if 20<ds_list_size(keysound_list_print) //스크롤
	{
		draw_roundrect(room_sx-55
		,DLT+16+ keysound_list_pos    /ds_list_size(keysound_list_print)*(DLB-DLT-32),room_sx-40
		,DLT+16+(keysound_list_pos+20)/ds_list_size(keysound_list_print)*(DLB-DLT-32),false);
	}

	//DisplayRight
	draw_set_color(c_white);
	var XX=LW-room_sx+30+8,YY=45+30+8,a,b,print="",N=0;
	for(a=0;a<ds_list_size(collection_list);a++)
	{
		if keysound_collection_list_pos<=N and N<keysound_collection_list_pos+30
		{
			print+=ds_map_find_value(collection_list[|a],"name")+"\n";
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
						print+="  "+ds_map_find_value(collection_list[|a],"name")+"_"+string_N(b,4)+".wav\n";
					}
					else
					{
						print+="  "+ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b)+"\n";
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
	draw_text(XX,YY,print);
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
	draw_set_color(make_color_rgb(40,40,60));
	if 30<b //스크롤
	{
		draw_roundrect(LW-55
		,45+30+8+ keysound_collection_list_pos    /b*(LH-76),LW-40
		,45+30+8+(keysound_collection_list_pos+30)/b*(LH-76),false);
	}

	var XX=30+8,YY=DLT+8+8,a,b,c,C;
	draw_set_font(font5);
	draw_set_color(c_white);
	if (XX<mouse_x and mouse_x<room_sx-55-8)
	{
		if (YY<mouse_y and mouse_y<DLB-8-8)
		{
			//DisplayLeftMiddle
			for(a=keysound_list_pos;a<keysound_list_pos+20 and a<ds_list_size(keysound_list_print);a++)
			{
				//show_debug_message("2");
				YY+=string_height(keysound_list_print[|a])
				if mouse_y<YY
				{
					if string_pos("chain",keysound_list_print_info[|a])!=0
					{
						C=real(keysound_list_print_info[|a]);
						//draw_set_color(c_aqua);
						//draw_set_alpha(0.3);
						draw_set_color(make_color_rgb(0,200,200));
						draw_circle(room_sx+M*(   9.5),room_sy+M*(C+0.5),(M*0.25)/2,false);
					}
					if string_pos("key",keysound_list_print_info[|a])!=0
					{
						b=real(keysound_list_print_info[|a]);
						C=b div 64;
						c=(b mod 64) div 8;
						b=b mod 8;
						//show_debug_message(c);
						draw_set_color(make_color_rgb(0,200,200));
						draw_circle(room_sx+M*(  9.5),room_sy+M*(C+0.5),(M*0.25)/2,false);
						draw_roundrect(room_sx+M*(b+1+0.37),room_sy+M*(c+1+0.37),room_sx+M*(b+1+0.63),room_sy+M*(c+1+0.63),false);
						draw_line_width(room_sx+M*(  9.5),room_sy+M*(C+0.5),room_sx+M*(b+1.5),room_sy+M*(c+1.5),2);
					}
					break;
				}
			}
		}
	}
	YY=45+30+8
	if (LW-room_sx+30+8<mouse_x and mouse_x<LW-55-8)
	{
		if (YY<mouse_y and mouse_y<45+LH-30-8)
		{
			draw_set_color(make_color_rgb(0,200,200));
			var N=0;
			for(a=0;a<ds_list_size(collection_list) and 0<=a;a++)
			{
				if keysound_collection_list_pos<=N and N<keysound_collection_list_pos+30
				{
					YY+=string_height(ds_map_find_value(collection_list[|a],"name"));
					if mouse_y<YY
					{
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
									var A,B,C,FN=ds_map_find_value(collection_list[|a],"name")+"_"+string_N(b,4)+".wav";
									for (A=1;A<=8;A++)
									{
										for (B=0;B<8;B++)
										{
											for (C=0;C<8;C++)
											{
												if 0<=ds_list_find_index(pad_KeySound[A,C*8+B],FN)
												{
													draw_circle(room_sx+M*(  9.5),room_sy+M*(A+0.5),(M*0.25)/2,false);
													draw_roundrect(room_sx+M*(B+1+0.37),room_sy+M*(C+1+0.37),room_sx+M*(B+1+0.63),room_sy+M*(C+1+0.63),false);
													draw_line_width(room_sx+M*(  9.5),room_sy+M*(A+0.5),room_sx+M*(B+1.5),room_sy+M*(C+1.5),2);
												}
											}
										}
									}
									//show_debug_message(ds_map_find_value(collection_list[|a],"name")+"_"+string_N(b,4)+".wav");
									a=-2;
									break;
								}
							}
							else
							{
								YY+=string_height("  "+ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b));
								if mouse_y<YY
								{
									var A,B,C,FN=ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b);
									for (A=1;A<=8;A++)
									{
										for (B=0;B<8;B++)
										{
											for (C=0;C<8;C++)
											{
												if 0<=ds_list_find_index(pad_KeySound[A,C*8+B],FN)
												{
													draw_circle(room_sx+M*(  9.5),room_sy+M*(A+0.5),(M*0.25)/2,false);
													draw_roundrect(room_sx+M*(B+1+0.37),room_sy+M*(C+1+0.37),room_sx+M*(B+1+0.63),room_sy+M*(C+1+0.63),false);
													draw_line_width(room_sx+M*(  9.5),room_sy+M*(A+0.5),room_sx+M*(B+1.5),room_sy+M*(C+1.5),2);
												}
											}
										}
									}
									//show_debug_message("  "+ds_list_find_value(ds_map_find_value(collection_list[|a],"sect"),b));
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
	draw_set_color(c_white);
	draw_set_alpha(1);

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	//pad에 자른 음악 배치할 때
	if !(keysound_mouse_pressed="")
	{
		draw_set_color(c_white);
		draw_roundrect(mouse_x-string_width(keysound_mouse_pressed)/2-2
			,mouse_y-string_height(keysound_mouse_pressed)/2
			,mouse_x+string_width (keysound_mouse_pressed)/2+2
			,mouse_y+string_height(keysound_mouse_pressed)/2,false)
		draw_set_color(c_black);
		draw_text(mouse_x,mouse_y,keysound_mouse_pressed);
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	//텍스트 입력창 그리기
	//draw_set_font(fn_font);
	//draw_set_color(c_white);
	//kia_multi_textbox_draw_text(x+10,y+10);


}
