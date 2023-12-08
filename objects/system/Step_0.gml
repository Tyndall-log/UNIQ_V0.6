/// @description Insert description here
// You can write your code in this editor

var a;

//Midi 확인
Midi_check--;
if Midi_check<=0
{
	Midi_check=400;
	var T_1,T_2;
	show_debug_message(midi_input_list())
	if Midi_input_list_text!=midi_input_list()
	{
		Midi_input_id[0]=-1;
		Midi_input_list_text=midi_input_list();
		T_2=Midi_input_list_text;
		for(a=0;a<string_count("\\",Midi_input_list_text);a++)
		{
			n=string_pos("\\",T_2);
			T_1=string_copy(T_2,1,n-1);
			if string_count("MK3",T_1)
			{
				if string_count("MIDIIN2",T_1)
				{
					Midi_input_id[0]=midi_input_open(a);
					Midi_input_name=T_1;
					break;
				}
			}
			else if string_count("LPX MIDI",T_1)
			{
				if string_count("MIDIIN2",T_1)
				{
					Midi_input_id[0]=midi_input_open(a);
					Midi_input_name=T_1;
					break;
				}
			}
			else if string_count("Launchpad",T_1)
			{
				Midi_input_id[0]=midi_input_open(a);
				Midi_input_name=T_1;
				break;
			}
			else if string_count("MIDIHub Port",T_1)
			{
				Midi_input_id[0]=midi_input_open(a);
				Midi_input_name=T_1;
				break;
			}
			T_2=string_delete(T_2,1,n);
		}
	}
	
	if Midi_output_list_text!=midi_output_list()
	{
		Midi_output_id[0]=-1;
		Midi_output_list_text=midi_output_list();
		T_2=Midi_output_list_text;
		for(a=0;a<string_count("\\",Midi_output_list_text);a++)
		{
			var n=string_pos("\\",T_2);
			T_1=string_copy(T_2,1,n-1);
			if string_count("MK3",T_1)
			{
				if string_count("MIDIOUT2",T_1)
				{
					Midi_output_id[0]=midi_output_open(a);
					Midi_output_name=T_1;
					break;
				}
			}
			else if string_count("LPX MIDI",T_1)
			{
				if string_count("MIDIOUT2",T_1)
				{
					Midi_output_id[0]=midi_output_open(a);
					Midi_output_name=T_1;
					break;
				}
			}
			else if string_count("Launchpad",T_1)
			{
				Midi_output_id[0]=midi_output_open(a);
				Midi_output_name=T_1;
				break;
			}
			else if string_count("MIDIHub Port",T_1)
			{
				Midi_output_id[0]=midi_output_open(a);
				Midi_output_name=T_1;
				break;
			}
			T_2=string_delete(T_2,1,n);
		}
	}
	show_debug_message(Midi_output_id)
	show_debug_message(Midi_input_id)
}

if keyboard_check_pressed(vk_f1)
{
	repeat(1041)
	{
		//Midi_output_push(11,3);
	}
	//Midi_output_multi_send(Midi_output_id[0],0x90);
}
if keyboard_check(vk_f2)
{
	//Midi_output_send(Midi_output_id[0],0x19030E90030E90);
}

var CHACK=true;
if mouse_check_button_pressed(mb_left)
{
	/*
	draw_line(0,room_height*0.43,room_width*0.015,room_height*0.46);
	draw_line(room_width*0.015,room_height*0.46,room_width*0.015,room_height*0.54);
	draw_line(room_width*0.015,room_height*0.54,0,room_height*0.57);
	*/
	if left_bar=0
	{
		//좌단 바 열기 버튼 클릭 확인
		if (mouse_x < room_width*0.015)
		{
			if (room_height*0.43<mouse_y) and (mouse_y < room_height*0.57)
			{
				left_bar=1;
			}
		}
	}
	else
	{
		//좌단 바 닫기 버튼 클릭 확인
		if (room_width*0.100 < mouse_x) //and (mouse_x < room_width*0.115)
		{
			left_bar=0;
			CHACK=false;
		}
		//좌단 바의 내용 클릭 확인
		if (room_width*0.05-32*DPI < mouse_x) and (mouse_x < room_width*0.05+32*DPI)
		{
			var K=(mouse_y-50*DPI) mod ((room_height-100*DPI)/5);
			if (30*DPI<=K) and (K<=92*DPI)
			{
				switch ((mouse_y-50*DPI) div ((room_height-100*DPI)/5))
				{
					case 0 :
						LB_0(); //불러오기
					break;
					case 1 :
						//LB_1(); //저장하기
					break;
					case 2 :
						//LB_2();
					break;
					case 3 :
						//LB_3();
					break;
					case 4 :
						//LB_4();
					break;
				}
				left_bar=0;
				show_debug_message((mouse_y-50*DPI) div ((room_height-100*DPI)/5));
			}
		}
	}
	//상단
	if (10*DPI < mouse_x) and (mouse_x < room_width-10*DPI)
	{
		if (mouse_y < 45*DPI)
		{
			//layer_num=floor((mouse_x-10)/(room_width-20)*7)
		}
	}
}

if left_bar=0 and CHACK
{
	//본체 조건부
	switch (layer_num)
	{
		case 0 :
			L0_step();
		break;
		case 1 :
			L1_step();
		break;
		case 2 :
			L2_step();
		break;
		case 3 :
			L3_step();
		break;
		case 4 :
			L4_step();
		break;
		case 5 :
			L5_step();
		break;
		case 6 :
			L6_step();
		break;
	}
}