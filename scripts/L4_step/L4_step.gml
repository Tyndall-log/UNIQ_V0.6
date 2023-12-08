function L4_step() {
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


}
