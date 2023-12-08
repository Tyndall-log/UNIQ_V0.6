function L4_draw() {
	var LW=room_width,LH=room_height-90;

	//show_debug_message(ds_list_find_value(V_list,0))
	//패드 LED 그리기
	/*
	var X,Y,MC,PAD_X,PAD_Y;
	PAD_X[0]=LW-300;
	PAD_X[1]=LW-260;
	PAD_X[2]=LW-200;
	PAD_Y[0]=50;
	PAD_Y[1]=50;
	PAD_Y[2]=50;
	for(X=1;X<9;X++)
	{
		for(Y=1;Y<9;Y++)
		{
			draw_set_color(pad_LED[Y,X]);
			draw_roundrect(room_sx+M*(X+0.07),room_sy+M*(Y+0.07),room_sx+M*(X+0.93),room_sy+M*(Y+0.93),false);
			draw_rectangle(PAD_X[0]+X*4,PAD_Y[0]+Y*4,PAD_X[0]+2+X*4,PAD_Y[0]+2+Y*4,false);
			draw_rectangle(PAD_X[1]+X*5,PAD_Y[1]+Y*5,PAD_X[1]+3+X*5,PAD_Y[1]+3+Y*5,false);
			draw_rectangle(PAD_X[2]+X*6,PAD_Y[2]+Y*6,PAD_X[2]+4+X*6,PAD_Y[2]+4+Y*6,false);
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
	draw_set_color(c_black);
	draw_rectangle(PAD_X[0]+18,PAD_Y[0]+18,PAD_X[0]+2+18,PAD_Y[0]+2+18,false);
	draw_rectangle(PAD_X[1]+23,PAD_Y[1]+23,PAD_X[1]+2+23,PAD_Y[1]+2+23,false);
	draw_rectangle(PAD_X[2]+28,PAD_Y[2]+28,PAD_X[2]+2+28,PAD_Y[2]+2+28,false);

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
	draw_set_alpha(1);
	var a,X=30,Y=100;
	for(a=0;a<ds_list_size(BBBB);a++)
	{
		if (string(BBBB[|a])="----")
		{
			X+=20;
			Y=100;
		}
		else
		{
			draw_set_color(V_list[|BBBB[|a]]);
			draw_rectangle(X,Y,X+19,+Y+19,false);
			Y+=20;
		}
	}





	draw_set_alpha(1);
	var a,X=50,Y=70;
	for(a=0;a<128;a++)
	{
		draw_set_color(V_list[|a]);
		draw_rectangle(X,Y,X+10,Y+10,false);
		if a mod 4=3
		{
			Y+=10;
			X=50;
		}
		else
		{
			X+=10;
		}
	}
	*/


	var a,X=100,Y=50;
	for(a=0;a<128;a++)
	{
		draw_set_color(V_list[|a]);
		draw_rectangle(X+color_get_hue(V_list[|a])*4
		,Y+color_get_saturation(V_list[|a])*2
		,X+color_get_hue(V_list[|a])*4+2
		,Y+color_get_saturation(V_list[|a])*2+10,false);
	}
	draw_set_color(c_red);
	draw_text(mouse_x,mouse_y+20,(mouse_x-100)/4)
	var NNN,R;
	for(a=0;a<12;a++)
	{
		draw_line(X+VVV[a]*4,0,X+VVV[a]*4,LH);
		NNN[a]=ds_list_create();
	}
	if keyboard_check_pressed(vk_f1)
	{
		var ttt=get_integer("변수",-1)
		if 0<=ttt
		{
			VVV[ttt]=get_integer("위치",0);
		}
	}
	if keyboard_check_pressed(vk_f2)
	{
		for(a=0;a<12;a++)
		{
			show_debug_message(string(a)+" "+string(VVV[a]));
		}
	}
	if mouse_wheel_up()
	{
		for(a=0;a<12;a++)
		{
			if mouse_x<100+4*VVV[a]
			{
				VVV[a]++;
				break;
			}
		}
	}
	if mouse_wheel_down()
	{
		for(a=0;a<12;a++)
		{
			if mouse_x<100+4*VVV[a]
			{
				VVV[a]--;
				break;
			}
		}
	}
	for(a=0;a<128;a++)
	{
		R=color_get_hue(V_list[|a]);
	
		if R<VVV[0] or VVV[11]<=R{ds_list_add(NNN[0],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[1]     {ds_list_add(NNN[1],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[2]     {ds_list_add(NNN[2],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[3]     {ds_list_add(NNN[3],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[4]     {ds_list_add(NNN[4],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[5]     {ds_list_add(NNN[5],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[6]     {ds_list_add(NNN[6],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[7]     {ds_list_add(NNN[7],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[8]     {ds_list_add(NNN[8],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[9]     {ds_list_add(NNN[9],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[10]    {ds_list_add(NNN[10],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		else if R<VVV[11]    {ds_list_add(NNN[11],floor(color_get_saturation(V_list[|a])*10)+a/1000)}
		//ds_list_add(NNN[10],floor(color_get_saturation(V_list[|a])*10)+a/1000);
		//show_debug_message(string_format(floor(color_get_saturation(V_list[|a])*10)+a/1000,4,4)+" "+string_format(ds_list_find_value(NNN[10],a),4,4));
		//show_debug_message(frac(ds_list_find_value(NNN[10],a))*1000);
	}
	//show_debug_message("----");
	Y=580;
	var b;
	for(a=0;a<12;a++)
	{
		X=0;
		ds_list_sort(NNN[a],false);
		for(b=0;b<ds_list_size(NNN[a]);b++)
		{
			//show_debug_message(round(frac(ds_list_find_value(NNN[a],b))*1000));
			draw_set_color(V_list[|round(frac(ds_list_find_value(NNN[a],b))*1000)]);
			draw_rectangle(X,Y,X+30,Y+10,false);
			X+=30;
		}
		//show_debug_message("----")
		Y+=10;
		ds_list_destroy(NNN[a]);
	}


}
