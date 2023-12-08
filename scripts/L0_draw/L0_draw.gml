function L0_draw() {
	//유니큐 정보 및 로고 그리기
	var LW=room_width,LH=room_height-90*DPI;
	draw_sprite_ext(sprite0,0,((room_sx+M*10)+LW)/2,45*DPI+LH*0.2,DPI,DPI,0,c_white,1);
	draw_set_font(malgeun_sdf); //fs_12
	draw_set_color(c_white);
	draw_set_alpha(0.5);
	draw_set_halign(fa_center);
	draw_text_transformed(((room_sx+M*10)+LW)/2,45*DPI+LH*0.24,"V "+Version+" - "+Version_Update,fs_12,fs_12,0)
	draw_set_alpha(1);
	draw_set_halign(fa_top);
	draw_set_color(c_white);
	//draw_line((room_sx+M*10)*0.9+LW*0.1   ,60 ,(room_sx+M*10)*0.9+LW*0.1,220)
	//draw_line((room_sx+M*10)*0.9+LW*0.1+10,230,                   LW    ,230)

	//로그인 그리기
	draw_rectangle((room_sx+M*10)*0.9+LW*0.1,45+LH*0.40,(room_sx+M*10)*0.1+LW*0.9,45+LH*0.44,true);
	draw_rectangle((room_sx+M*10)*0.9+LW*0.1,45+LH*0.45,(room_sx+M*10)*0.1+LW*0.9,45+LH*0.49,true);


	//show_debug_message(ds_list_find_value(V_list,0))
	//패드 LED 그리기
	var X,Y,MC;
	for(X=1;X<9;X++)
	{
		for(Y=1;Y<9;Y++)
		{
			if pad_S[|1]
			{
				draw_set_color(pad_LED[Y,X]);
			}
			else
			{
				draw_set_color(V_list[|0]);
			}
			draw_roundrect_ext(room_sx+M*(X+0.07),room_sy+M*(Y+0.07),room_sx+M*(X+0.93),room_sy+M*(Y+0.93), 15*DPI, 15*DPI,false);
		
			//누른 키 표시
			if pad_T_LED[Y,X]!=0 and pad_T_LED[Y,X]!=100
			{
				if pad_S[|0]
				{
					draw_set_color(c_yellow);
					draw_set_alpha(0.5);
					draw_circle(room_sx+M*(X+0.5),room_sy+M*(Y+0.5),M*0.35,false);
					draw_set_alpha(1);
					if 100<pad_T_LED[Y,X]
					{
						draw_set_color(c_red);
					}
					else
					{
						draw_set_color(c_blue);
					}
					draw_circle(room_sx+M*(X+0.5),room_sy+M*(Y+0.5),M*0.15,false);
				}
				pad_T_LED[Y,X]-=1;
			}
			draw_set_alpha(1);
		}
	}

	//탑 라이트 그리기
	for(MC=1;MC<=32;MC++)
	{
		if pad_S[|1]
		{
			draw_set_color(pad_MCLED[MC]);
		}
		else
		{
			draw_set_color(V_list[|0]);
		}
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


	//가이드 LED 그리기 
	if ds_list_find_value(pad_S,2) and autoplay_stop
	{
		while(autoplay_list_N<ds_list_size(autoplay_list))
		{
			if array_get(autoplay_list[|autoplay_list_N],2)=0
			{
				autoplay_list_N++;
			}
			else
			{
				if array_get(autoplay_list[|autoplay_list_N],1)!=play_chain
				{
					Midi_output_push((9-array_get(autoplay_list[|autoplay_list_N],1))*10+9,49);
				}
				var Y=real(array_get(autoplay_list[|autoplay_list_N],3)),X=real(array_get(autoplay_list[|autoplay_list_N],4));
				Midi_output_push((9-Y)*10+X,49);
				draw_set_color(V_list[|49]);
				draw_roundrect(room_sx+M*(X+0.07),room_sy+M*(Y+0.07),room_sx+M*(X+0.93),room_sy+M*(Y+0.93),false);
	
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
							Midi_output_push((9-Y)*10+X,49);
							draw_roundrect(room_sx+M*(X+0.07),room_sy+M*(Y+0.07),room_sx+M*(X+0.93),room_sy+M*(Y+0.93),false);
						}
						break;
					}
				}
				break;
			}
		}
	}

	//Midi_output_multi_send(Midi_output_id[0],0x90);

	//왼쪽 버튼 그리기
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
	draw_rectangle(LW*0.04-10*DPI,45*DPI+LH*0.10-10*DPI,LW*0.04+10*DPI,45*DPI+LH*0.10+10*DPI,true);
	draw_text_transformed(LW*0.04+18*DPI,45*DPI+LH*0.10,"누른 키 표시",fs_12,fs_12,0);
	if ds_list_find_value(pad_S,0){draw_circle(LW*0.04,45*DPI+LH*0.10,3*DPI,false);}
	draw_rectangle(LW*0.04-10*DPI,45*DPI+LH*0.17-10*DPI,LW*0.04+10*DPI,45*DPI+LH*0.17+10*DPI,true);
	draw_text_transformed(LW*0.04+18*DPI,45*DPI+LH*0.17,"LED",fs_12,fs_12,0);
	if ds_list_find_value(pad_S,1){draw_circle(LW*0.04,45*DPI+LH*0.17,3*DPI,false);}
	draw_rectangle(LW*0.04-10*DPI,45*DPI+LH*0.24-10*DPI,LW*0.04+10*DPI,45*DPI+LH*0.24+10*DPI,true);
	draw_text_transformed(LW*0.04+18*DPI,45*DPI+LH*0.24,"자동재생",fs_12,fs_12,0);
	if ds_list_find_value(pad_S,2)
	{
		draw_circle(LW*0.04,45*DPI+LH*0.24,3*DPI,false);
		draw_set_alpha(0.3);
		draw_roundrect(LW*0.04-2,45*DPI+LH*0.31-5*DPI,LW*0.2+LW*0.04+2,45*DPI+LH*0.31+5*DPI,false);
		draw_set_alpha(1);
		if autoplay_bar_click
		{
			draw_roundrect(LW*0.04,45*DPI+LH*0.31-3*DPI,max(LW*0.04,min(mouse_x,LW*0.24)),45*DPI+LH*0.31+3*DPI,false);
		}
		else
		{
			draw_roundrect(LW*0.04,45*DPI+LH*0.31-3*DPI,min(((autoplay_stop ? autoplay_stop_ST : current_time)-autoplay_list_ST)/autoplay_max_time,1)*LW*0.2+LW*0.04,45*DPI+LH*0.31+3*DPI,false);
		}
	
	}
	draw_set_valign(fa_left);


}
