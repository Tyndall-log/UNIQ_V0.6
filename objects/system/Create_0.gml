/// @description Insert description here
// You can write your code in this editor

/*
//ini_open(string_replace_all(working_directory,@"\",@"\\")+"abc.ini");
//C:\Users\user\Desktop\uniq_v1
ini_open("C:\\Users\\user\\Desktop\\uniq_v1\\abc.ini");
show_debug_message(string_replace_all(working_directory,@"\",@"\\"));
ini_write_string("a","b","c");
ini_close();
*/

//game_set_speed(240,gamespeed_fps)

ini_open("options.ini")
DPI=ini_read_real("UNIQ","DPI",-1)
SDO=ini_read_real("UNIQ","show_debug_overlay",0)
ini_close()
//SDO=1
//DPI=1.5
if DPI<0.5 or 3<DPI
	DPI=min(display_get_dpi_x(),display_get_dpi_y())/96

if(0 < SDO)
	show_debug_overlay(true,false,DPI);

//DPI=1
fs_15=DPI/2.5
fs_14=DPI/2.5*14/15
fs_12=DPI/2.5*12/15
fs_8=DPI/2.5*8/15

//룸 크기 설정
room_width=1280*DPI;
room_height=720*DPI;
surface_resize(application_surface,room_width,room_height);
window_set_size(room_width,room_height);
window_set_position((display_get_width()-room_width)/2,(display_get_height()-room_height)/2);

font_malgeun_12 = font_add(malgeun_sdf,12*DPI,false,false,0,0)
font_malgeun_12 = malgeun_sdf

realtime=current_time

//STR("C:\\Users\\eunsu\\Desktop\\한글.txt","abc123김은수㘒㐘畠");
JJJ=buffer_create(31,buffer_fixed,1);
k=BUF_POINT(buffer_get_address(JJJ));
show_debug_message(buffer_peek(JJJ,31,buffer_s8));

NNN=buffer_create(4,buffer_grow,1);
SSS=surface_create(4,4);
surface_set_target(SSS);
draw_set_color(make_color_rgb(0xAA,0x33,0x55));
draw_rectangle(1,1,2,2,false);
surface_reset_target();
buffer_get_surface(NNN,SSS,0);

KKK=0;

var a,b;
//버전
Version="0.6.9";
Version_Update="2023.12.04";

Debug_Text=ds_list_create();
Input_Text=ds_list_create();

PLAY_LOG=false;
PLAY_LOG_time=0;
PLAY_LOG_N=1;
PLAY_LOG_file="";

//압축 알고리즘 세팅
CRC32_set();

//프록시
//var Proc=Set_Proc(window_handle());
//if Proc!="0"
//{
//	show_debug_message("프록시 주소 이전 성공! : "+Proc);
//	ds_list_add(Debug_Text,"프록시 주소 이전 성공! : "+Proc);
//}
//else
//{
//	show_debug_message("프록시 주소 이전 실패...");
//	ds_list_add(Debug_Text,"프록시 주소 이전 실패...");
//}

//Midi 설정
Midi_check=400;
Midi_input_id[0]=-1;
Midi_output_id[0]=-1;
Midi_input_name="";
Midi_output_name="";

var n,T_1,T_2;
Midi_input_list_text=midi_input_list();
show_debug_message(Midi_input_list_text);
T_2=Midi_input_list_text;
ds_list_add(Debug_Text,"----In----");
for(a=0;a<string_count("\\",Midi_input_list_text);a++)
{
	n=string_pos("\\",T_2);
	T_1=string_copy(T_2,1,n-1);
	ds_list_add(Debug_Text,T_1);
	show_debug_message(T_1);
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

ds_list_add(Debug_Text,"----Out----");
Midi_output_list_text=midi_output_list();
show_debug_message("Midi_output_list_text: " + string(Midi_output_list_text));
T_2=Midi_output_list_text;
for(a=0;a<string_count("\\",Midi_output_list_text);a++)
{
	var n=string_pos("\\",T_2);
	T_1=string_copy(T_2,1,n-1);
	ds_list_add(Debug_Text,T_1);
	show_debug_message(T_1);
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

show_debug_message(Midi_output_id)
show_debug_message(Midi_input_id)


//번역
TL=ds_map_create();
TL_set();

//레이어 변수
layer_num=0;

//좌단 바
left_bar=0;//off=0, on=1

//벨로시티 세팅
V_list=Velocity_set();

//공백 구분
space_list=ds_list_create();

//삑삑이~~!! -우헤헤헤,헿
//var HZ=880*8;
//speak_buffer=buffer_create(8820,buffer_grow,2);
//for(a=0;a<4410;a++)
//{
//	buffer_poke(speak_buffer,a*2,buffer_s16,sin(2*pi/88200*HZ*a)*32767*(1-a/4410)*0.5);
//	//show_debug_message(sin(2*pi/88200*HZ*a)*32767*(1-a/4410))
//}
//speak_sound=audio_create_buffer_sound(speak_buffer,buffer_s16,88200,0,8820,audio_mono);
//audio_play_sound(speak_sound,0,0);

//패드 그리는 변수 (layer_num=0)
M=(room_height-100*DPI)/10; //버튼 크기
room_sx=room_width/2-M*5;
room_sy=50*DPI;

//패드 스위치
pad_S=ds_list_create();
ds_list_add(pad_S,1,1,0); //표시,LED,자동재생

//체인
play_chain=1;

//패드 LED 변수
pad_LED_priority=ds_list_create(); //패드 LED 우선 순위
for (a=1;a<=8;a++)
{
	for (b=1;b<=8;b++)
	{
		pad_T       [a,b]=false;            //누름 상태
		pad_T_N     [a,b]=0;                //클릭 횟수
		pad_T_LED   [a,b]=0;                //누른 키 표시
		pad_LED_info[a,b]=ds_list_create(); //LED 정보
		pad_LED_S_T [a,b]=0;                //LED 재생 시점
		pad_LED     [a,b]=V_list[|0];       //현재 LED 색
		ds_list_add(pad_LED_priority,a*8+b-9); //우선 순위 기록
	}
	for (b=0;b<64;b++)
	{
		pad_KeySound [a,b]=ds_list_create(); //키 사운드
		pad_keyLED   [a,b]=ds_list_create(); //keyLED
	}
}
for (a=1;a<=32;a++)
{
	pad_MCLED     [a]=V_list[|0];
}

//PLAY 음악 버퍼 자동 삭제 목록
audio_buffer_ID=ds_list_create(); //버퍼
audio_ID       =ds_list_create(); //오디오 버퍼
audio_play_ID  =ds_list_create(); //재생 ID


//autoplay
autoplay_time=ds_list_create(); //오토 플레이 시간 정보
autoplay_info=ds_list_create(); //오토 플레이 누름 정보
autoplay_CT=0; //오토 플레이 기준 시간
autoplay_N=0;  //오토 플레이 현재 번호
autoplay_list=ds_list_create(); //오토 플레이 정보 (NEW) [time,chin,command,y,x,num]
autoplay_list_ST=0; //오토 플레이 기준 시간
autoplay_list_N=0; //오토 플레이 현재 번호
autoplay_stop=false; //오토 플레이 일시정지
autoplay_stop_ST=0; //오토 플레이 일시정지할 때 시간
autoplay_max_time=0; //오토 플레이 최대 시간
autoplay_bar_click=false; //오토 플레이 바 클릭

//sounds
sounds_list=ds_list_create(); //음악 파일 목록
sounds_list_draw_x=0; //음악 리스트 표시 위치

//audio 재생(음악 자르기 모드)
music_cut_all_audio_ID=0;  //자른 음악 전체 오디오 버퍼
music_cut_audio_play_ID=0; //자른 음악 전체 재생 ID

//메뉴
mb_R_menu=0;
mb_R_menu_x=0; //메뉴 x좌표
mb_R_menu_y=0; //메뉴 y좌표
mb_R_menu_w=0; //메뉴 가로 길이
mb_R_menu_h=0; //메뉴 세로 길이
mb_R_menu_n=0; //메뉴 수
for(a=10;a>=0;a--)
{
	mb_R_menu_c[a]=c_white; //메뉴 글자 색 설정
}

//노란줄 선택 영역
music_cut_section=0; //-1:비활성화 중, 0:비활성화, 1:마우스 위치 선택 중, 2:활성화
music_cut_section_1=0; //시작 위치
music_cut_section_2=0; //끝 위치

//모음집(꾸러미)
collection_list=ds_list_create(); //모음집(꾸러미) 목록
//collection_list[|n]=map.id
// map:name - 모음집 이름
// map:file(list) - 음악 파일 이름 리스트
//  "file.wav"...
// map:cut(list) - 음악 자른 위치 리스트
//  "22050"...
collection_list_n=0; //모음집(꾸러미) 선택

//음악 구분선(노란줄)
music_cut_list=ds_list_create();
music_cut_list_FN_1=-1;    //리스트 드로우 시작 지점
music_cut_list_FN_2=-1;    //리스트 드로우 끝 지점
music_cut_list_FM_A=-1;    //리스트 마우스 앞 지점
music_cut_list_FM_C=-1;    //리스트 마우스 가까운 지점
music_cut_list_replace=-1; //리스트 마우스 옮기는 중
music_cut_list_name=ds_list_create(); //구간 음악 이름

//음악 구분선(노란줄) 복사
music_cut_list_copy=-1;    //복사 리스트 ID

//음악 구분선(노란줄) 이동
music_cut_list_move=-1;    //이동 리스트 ID
music_cut_list_move_1=-1;  //이동 시작점
music_cut_list_move_2=-1;  //이동 끝점
music_cut_list_move_R_x=0; //이전 마우스 위치

//음악 파형
music_wave_buffer[0]=buffer_create(0,buffer_grow,2); //음악 파형 버퍼
music_wave_buffer_H=-1; //파형 중앙 계산 정도
music_wave_mini_buffer=buffer_create(4*48*room_width,buffer_grow,1); //미니 파형 버퍼
music_wave_mini_surface=surface_create(room_width,48); //미니 파형
music_wave_buffer_size=0; //음악 파일 크기
music_wave_position=0; //음악 파형 드로우 위치
music_wave_R_position=0; //음악 파형 이전 드로우 위치
music_wave_size=7; //파형 드로우 크기(^2) (1~15) (ex. 3 : 2^3)
for(a=1;a<16;a++)
{
	music_wave_buffer[a]=buffer_create(0,buffer_fast,1); //음악 파형 버퍼 (추후 크기 변경 가능)
	music_wave_buffer_list[a]=ds_list_create(); //파형 그리기 부분 목록(이상~이하)
}

//프로젝트 파일 이름
if directory_exists(working_directory+"Project")
{
	
	directory_destroy(working_directory+"Project");
}
PJ_F_P=working_directory+"Project"; //프로젝트 폴더 위치

//음악 배치
keysound_display=0; //키 사운드 표시 방법 - 0:좌표 1:줄서기 2:유니패드
keysound_standard=3; //키 사운드 기준 위치
keysound_sort=ds_list_create();    //키 사운드 정렬 방법
ds_list_add(keysound_sort,1,2);
keysound_list_print=ds_list_create(); //목록 그리기
keysound_list_print_info=ds_list_create(); //목록 정보
for (a=1;a<=8;a++)
{
	ds_list_add(keysound_list_print,TL[?"3:1:0:0:0"]+" "+string(a));
	ds_list_add(keysound_list_print_info,string(a)+"chain");
}
for (a=0;a<=8;a++)
{
	for (b=0;b<64;b++)
	{
		keysound_list_display[a,b]=false;
	}
}
keysound_list_pos=0; //스크롤 위치
//keysound_collection_list_print=ds_list_create(); //목록 그리기
//keysound_collection_list_print_info=ds_list_create(); //목록 정보
keysound_collection_list_display[0]=false; //펼침 접힘
keysound_collection_list_display[1]=false; //펼침 접힘
keysound_collection_list_display[2]=false; //펼침 접힘
keysound_collection_list_pos=0 //모음집 스크롤 위치
keysound_mouse_pressed="";




//info
map_info=ds_map_create();
ds_map_add(map_info,"title","");
ds_map_add(map_info,"buttonX","8");
ds_map_add(map_info,"buttonY","8");
ds_map_add(map_info,"producerName","");
ds_map_add(map_info,"chain","8");
ds_map_add(map_info,"squareButton","");
ds_map_add(map_info,"PackTool","");

//마우스 이전 클릭 위치
mouse_R_x=0;
mouse_R_y=0;

show_debug_message("----")
show_debug_message(string_copy("chain 0 ",string_pos(" ","chain 0 ")+1,string_length("chain 0 ")-string_pos(" ","chain 0 ")))
//string_copy(tt,n+1,string_length(tt)-n)

//한글 입력기
draw_set_font(fn_font);
kia_multi_init();
kia_multi_textbox_create(100,300);

//비동기 테스트
async_test(100);

BBBB=ds_list_create();
ds_list_add(BBBB,61,
120,
72,
121,
60,
106,
5,
6,
7,
107,
4,
3,
"----",
84,
96,
9,
127,
10,
83,
108,
11,
12,
105,
8,
"----",
124,
97,
62,
74,
125,
126,
99,
100,
13,
109,
14,
15,
113,
"----",
64,
98,
75,
85,
111,
86,
63,
17,
122,
73,
110,
18,
19,
16,
"----",
123,
101,
76,
27,
26,
25,
22,
21,
23,
88,
87,
"----",
78,
77,
68,
65,
37,
34,
33,
30,
29,
38,
35,
31,
39,
102,
90,
32,
24,
36,
20,
40,
28,
89,
114,
"----",
79,
41,
42,
45,
66,
43,
67,
46,
47,
69,
80,
104,
92,
112,
44,
103,
91,
93,
116,
115,
//0,
117,
118,
1,
119,
2,
71,
70,
"----",
49,
50,
51,
48,
"----",
55,
54,
81,
53,
94,
82,
52,
"----",
58,
59,
57,
95,
56)
VVV[0]=10;
VVV[1]=30;
VVV[2]=50;
VVV[3]=70;
VVV[4]=110;
VVV[5]=143;
VVV[6]=172;
VVV[7]=185;
VVV[8]=220;
VVV[9]=230;
VVV[10]=240;
VVV[11]=240;