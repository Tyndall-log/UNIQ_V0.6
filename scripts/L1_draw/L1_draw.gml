function L1_draw() {
	var a,LW=room_width,LH=room_height-90,LW_6=floor(LW/6),CX=sounds_list_draw_x+LW_6,CW=LH*1/7,CY=45+LH*2/3;

	//음악 시간 표시
	draw_set_color(c_white);

	var Time=abs(floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))/44100);
	draw_text(LW*9/10,LH+48,"위치 : "+string_N(floor(Time div 60),2)+":"+string_N(floor(Time mod 60),2)+":"+string_N(floor(frac(Time)*1000),4));
	var Time=audio_sound_get_track_position(music_cut_audio_play_ID);
	draw_text(LW*9/10,LH+67,"시간 : "+string_N(floor(Time div 60),2)+":"+string_N(floor(Time mod 60),2)+":"+string_N(floor(frac(Time)*1000),4));

	//음악 리스트 그리기
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	for(a=floor(-sounds_list_draw_x/CW)*2;a<min(ceil((LW/3*2-sounds_list_draw_x)/CW)*2,ds_list_size(sounds_list));a++)
	{
		if ds_list_size(collection_list)
		{
			if ds_list_find_index(ds_map_find_value(collection_list[|collection_list_n],"file"),sounds_list[|a])>=0
			{
				draw_set_color(c_aqua);
			}
			else
			{
				draw_set_color(c_white);
			}
		}
		draw_roundrect(CX+CW*(a div 2)+CW/10,CY+CW*(a mod 2)+CW/10,CX+CW*(a div 2)+CW,CY+CW*(a mod 2)+CW,true);
		draw_text(CX+CW*(a div 2)+CW*11/20,CY+CW*(a mod 2)+CW/4,filename_change_ext(sounds_list[|a],""));
	}

	//리스트 위치 표시
	draw_set_color(c_white);
	draw_circle(LW_6-(CX-LW_6)/(ceil(ds_list_size(sounds_list)/2)*CW-LW/3*2)*(LW/3*2),(CY+CW*2+LH+45)/2,(LH+45-(CY+CW*2))/3,true);

	//리스트 가리기 부분
	draw_set_color(c_black);
	draw_rectangle(0,CY,LW_6+1,LH+45,false);
	draw_rectangle(LW*5/6,CY,LW,LH+45,false);

	//파형 관련
	draw_set_alpha(1);
	draw_set_color(make_color_rgb(120,120,120));
	if buffer_get_size(music_wave_buffer[1])>0
	{
		if music_wave_size=0
		{
			//파형 그리기
			var VY_1=45+floor(LH*1/6),VY_2=45+floor(LH*1/2),
				C=1/32768*(LH*1/6-12),
				MA=min(LW,floor(-music_wave_position+buffer_get_size(music_wave_buffer[1])+LW_6)),
				D=floor(music_wave_position)-LW_6;
			for(a=max(0,-D);a<=MA;a++)
			{
				draw_line(a,VY_1,a,VY_1-buffer_peek(music_wave_buffer[0],(a+D)*4  ,buffer_s16)*C);
				draw_line(a,VY_2,a,VY_2-buffer_peek(music_wave_buffer[0],(a+D)*4+2,buffer_s16)*C);
			}
		
			//자른 위치 그리기(노란 줄)
			var K=floor(music_cut_list[|0]/4),SIZE=ds_list_size(music_cut_list);
			draw_set_color(make_color_rgb(100,100,200));
			draw_line(-D+K,57       ,-D+K,33+LH*1/3); //처음_L
			draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //처음_R
			K=floor(music_cut_list[|SIZE-1]/4);
			draw_line(-D+K,57       ,-D+K,33+LH*1/3); //끝_L
			draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //끝_R
			draw_set_alpha(0.7);
			draw_set_color(c_yellow);
			for (a=1;a<SIZE-1;a++)
			{
				K=floor(music_cut_list[|a]/4);
				draw_line(-D+K,57       ,-D+K,33+LH*1/3); //노란 줄 그리기_L
				draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //노란 줄 그리기_R
			}
		}
		else
		{
			//파형 그리기
			var S=music_wave_size,VY_1=45+LH*1/6,VY_2=45+LH*1/2,
				C=1/256*(LH*1/6-12),
				R=power(2,S),
				MA=min(LW,floor(-music_wave_position/R+buffer_get_size(music_wave_buffer[S])+LW_6)),
				D=floor(music_wave_position/R)-LW_6;
			for(a=max(0,-D);a<MA;a++)
			{
				draw_line(a,VY_1-buffer_peek(music_wave_buffer[S],(a+D)*4  ,buffer_u8)*C
				         ,a,VY_1+buffer_peek(music_wave_buffer[S],(a+D)*4+1,buffer_u8)*C);
				draw_line(a,VY_2-buffer_peek(music_wave_buffer[S],(a+D)*4+2,buffer_u8)*C
				         ,a,VY_2+buffer_peek(music_wave_buffer[S],(a+D)*4+3,buffer_u8)*C);
			}
		
			//자른 위치 그리기(노란 줄)
			R*=4;
			var K=floor(music_cut_list[|0]/R),SIZE=ds_list_size(music_cut_list);
			draw_set_color(make_color_rgb(100,100,200));
			draw_line(-D+K,57       ,-D+K,33+LH*1/3); //처음_L
			draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //처음_R
			K=floor(music_cut_list[|SIZE-1]/R);
			draw_line(-D+K,57       ,-D+K,33+LH*1/3); //끝_L
			draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //끝_R
			draw_set_alpha(0.7);
			draw_set_color(c_yellow);
		
			if 0<=music_cut_list_move
			{
				for (a=max(1,music_cut_list_FN_1);a<min(music_cut_list_move_1,SIZE-1);a++)
				{
					K=floor(music_cut_list[|a]/R);
					draw_line(-D+K,57       ,-D+K,33+LH*1/3); //노란 줄 그리기_L
					draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //노란 줄 그리기_R
				}
				draw_set_alpha(0.2);
				for (a=max(1,music_cut_list_move_1);a<min(music_cut_list_move_2,SIZE-1);a++)
				{
					K=floor(music_cut_list[|a]/R);
					draw_line(-D+K,57       ,-D+K,33+LH*1/3); //노란 줄 그리기_L
					draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //노란 줄 그리기_R
				}
				draw_set_alpha(0.7);
				for (a=max(1,music_cut_list_move_2);a<min(music_cut_list_FN_2,SIZE-1);a++)
				{
					K=floor(music_cut_list[|a]/R);
					draw_line(-D+K,57       ,-D+K,33+LH*1/3); //노란 줄 그리기_L
					draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //노란 줄 그리기_R
				}
				draw_set_alpha(1);
				var n_1=max(0,music_cut_list[|music_cut_list_move_1-1]-(music_cut_list_move[|0]-(music_cut_list_move_R_x-floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4))),
					n_2=min(0,music_cut_list[|music_cut_list_move_2]-(music_cut_list_move[|ds_list_size(music_cut_list_move)-1]-(music_cut_list_move_R_x-floor(music_wave_position+(mouse_x-LW_6)*power(2,music_wave_size))*4)));
				for (a=0;a<ds_list_size(music_cut_list_move);a++)
				{
					K=floor((music_cut_list_move[|a]-music_cut_list_move_R_x+n_1+n_2)/R)+mouse_x;
					draw_line(K,57       ,K,33+LH*1/3); //노란 줄 그리기_L
					draw_line(K,57+LH*1/3,K,33+LH*2/3); //노란 줄 그리기_R
				}
			}
			else
			{
				for (a=max(1,music_cut_list_FN_1);a<min(music_cut_list_FN_2,SIZE-1);a++)
				{
					K=floor(music_cut_list[|a]/R);
					draw_line(-D+K,57       ,-D+K,33+LH*1/3); //노란 줄 그리기_L
					draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3); //노란 줄 그리기_R
				}
			}
		
			//파일 이름 및 숫자 표시
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_set_halign(fa_center);
			draw_set_valign(fa_bottom);
			draw_set_font(malgeun_8);
			for (a=max(0,music_cut_list_FN_1-1);a<min(music_cut_list_FN_2,SIZE-1);a++)
			{
				draw_text(-D+(floor(music_cut_list[|a]/R)+floor(music_cut_list[|a+1]/R))/2,59,filename_change_ext(music_cut_list_name[|a+1],""));
				draw_text(-D+(floor(music_cut_list[|a]/R)+floor(music_cut_list[|a+1]/R))/2,47+LH*2/3,string(a+1));
			}
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
		
			//부분 재생 라인 그리기
			draw_set_color(c_purple);
			for(a=0;a<ds_list_size(audio_play_ID);a++)
			{
				if audio_buffer_ID[|a]<0
				{
					K=floor((audio_sound_get_track_position(audio_play_ID[|a])*44100*4+music_cut_list[|-audio_buffer_ID[|a]-1])/R);
					draw_line(-D+K,57,-D+K,33+LH*1/3);
					draw_line(-D+K,57+LH*1/3,-D+K,33+LH*2/3);
				}
			}
		}
	}

	//마우스 따라다니는 연두줄 드로우
	if (57<mouse_y and mouse_y<=33+LH*1/3) or (57+LH*1/3<=mouse_y and mouse_y<33+LH*2/3) //파형 드로우 구간일 경우 
	{
		if music_cut_list_FM_C=-1 and music_cut_list_replace=-1
		{
			draw_set_color(c_lime);
			draw_set_alpha(0.5);
			if 0<=music_cut_list_copy
			{
				var XX;
				for(a=0;a<ds_list_size(music_cut_list_copy);a++)
				{
					XX=mouse_x+music_cut_list_copy[|a]/power(2,music_wave_size)/4;
					draw_line(XX,57       ,XX,33+LH*1/3); //노란 줄 그리기_L
					draw_line(XX,57+LH*1/3,XX,33+LH*2/3); //노란 줄 그리기_R
				}
			}
			else
			{
				draw_line(mouse_x,57       ,mouse_x,33+LH*1/3); //노란 줄 그리기_L
				draw_line(mouse_x,57+LH*1/3,mouse_x,33+LH*2/3); //노란 줄 그리기_R
			}
		}
	
		//선택 영역 드로우
		if music_cut_section=1
		{
			var K=floor((music_cut_section_1-music_wave_position)/power(2,music_wave_size))+LW_6;
			draw_set_color(c_lime);
			draw_set_alpha(0.5);
			draw_line(K,57       ,K,33+LH*1/3); //노란 줄 그리기_L
			draw_line(K,57+LH*1/3,K,33+LH*2/3); //노란 줄 그리기_R
			draw_set_alpha(0.05);
			draw_rectangle(mouse_x,57       ,K,33+LH*1/3,false);
			draw_rectangle(mouse_x,57+LH*1/3,K,33+LH*2/3,false);
		}
	}

	//선택 영역 드로우
	if music_cut_section=2
	{
		var K1=floor((music_cut_section_1-music_wave_position)/power(2,music_wave_size))+LW_6,
			K2=floor((music_cut_section_2-music_wave_position)/power(2,music_wave_size))+LW_6;
		draw_set_color(c_lime);
		draw_set_alpha(0.5);
		draw_line(K2,57       ,K2,33+LH*1/3); //노란 줄 그리기_L
		draw_line(K2,57+LH*1/3,K2,33+LH*2/3); //노란 줄 그리기_R
		draw_line(K1,57       ,K1,33+LH*1/3); //노란 줄 그리기_L
		draw_line(K1,57+LH*1/3,K1,33+LH*2/3); //노란 줄 그리기_R
		draw_set_alpha(0.05);
		draw_rectangle(K2,57       ,K1,33+LH*1/3,false);
		draw_rectangle(K2,57+LH*1/3,K1,33+LH*2/3,false);
	}

	//재생 라인 그리기
	draw_set_font(malgeun_12);
	draw_set_color(c_aqua);
	draw_set_alpha(1);
	draw_line(LW_6,57,LW_6,33+LH*1/3);
	draw_line(LW_6,57+LH*1/3,LW_6,33+LH*2/3);
	draw_text(LW_6-10,45+LH*1/6,"L");
	draw_text(LW_6-10,45+LH*3/6,"R");
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	//틀 그리기
	draw_set_color(c_white);
	/*//그라데이션
	draw_primitive_begin(pr_trianglefan);
	draw_vertex_color(LW_6+12,CY+1 ,c_black,1);
	draw_vertex_color(LW_6+40,CY+1 ,c_black,0);
	draw_vertex_color(LW_6+40,46+LH,c_black,0);
	draw_vertex_color(LW_6+12,46+LH,c_black,1);
	draw_primitive_end();
	*/
	//
	if mouse_check_button(mb_left) and 33+LH*1/3<mouse_R_y and mouse_R_y<57+LH*1/3
	{
		if surface_exists(music_wave_mini_surface)
		{
			draw_surface_ext(music_wave_mini_surface,0,34+LH*1/3,1,0.5,0,make_color_rgb(100,100,100),1);
		}
		else
		{
			music_wave_mini_surface=surface_create(room_width,48); //미니 파형
			buffer_set_surface(music_wave_mini_buffer,music_wave_mini_surface,0);
		}
	}
	else
	{
		if music_wave_buffer_H=-1
		{
			draw_line(0,45+LH*1/3,LW,45+LH*1/3);
		}
		else
		{
			draw_line(0,45+LH*1/3,LW*music_wave_buffer_H/buffer_get_size(music_wave_buffer[7])*4,45+LH*1/3);
		}
	}
	draw_line(0,CY,LW,CY);
	draw_line(LW_6,CY+12,LW_6,LH+33);
	draw_line(LW*5/6,CY+12,LW*5/6,LH+33);
	//draw_line(10,45+LH*5/6,LW-10,45+LH*5/6);

	//파형 위치 표시
	draw_circle(music_wave_position/(buffer_get_size(music_wave_buffer[2]))*LW,45+LH*1/3,12,true);

	//모음집 그리기
	for(a=0;a<ds_list_size(collection_list);a++)
	{
		if collection_list_n=a
		{
			draw_set_color(c_aqua);
		}
		else
		{
			draw_set_color(c_white);
		}
		draw_text(5,CY+5+a*20,ds_map_find_value(collection_list[|a],"name")); //모음집 이름
	}

	//하단 오른쪽 버튼 그리기
	draw_set_color(c_aqua);
	var DX=(LW/12-64)/3+32,DY=(LH/6-64)/3+32;
	draw_set_color(c_white);
	//draw_point(LW*11/12,45+LH*5/6) //중심 표현
	draw_sprite(sprite3,0,LW*11/12-DX,45+LH*5/6-DY);
	draw_sprite(sprite3,2,LW*11/12+DX,45+LH*5/6-DY);
	draw_sprite(sprite3,3,LW*11/12-DX,45+LH*5/6+DY);
	draw_sprite(sprite3,4,LW*11/12+DX,45+LH*5/6+DY);

	//디버그
	draw_set_valign(fa_right);
	draw_text(LW,45,string_format(music_wave_position,2,8));
	draw_set_valign(fa_left);


}
