/// @description Insert description here
// You can write your code in this editor

//본체 그리기
switch (layer_num)
{
	case 0 :
		L0_draw();
	break;
	case 1 :
		L1_draw();
	break;
	case 2 :
		L2_draw();
	break;
	case 3 :
		L3_draw();
	break;
	case 4 :
		L4_draw();
	break;
	case 5 :
		L5_draw();
	break;
	case 6 :
		L6_draw();
	break;
}

draw_set_color(c_white);
//좌단 버튼 그리기
if left_bar=0 //좌단 바 닫힘
{
	draw_set_alpha(0.5);
	draw_line(0               ,room_height*0.43,room_width*0.015,room_height*0.46);
	draw_line(room_width*0.015,room_height*0.46,room_width*0.015,room_height*0.54);
	draw_line(room_width*0.015,room_height*0.54,0               ,room_height*0.57);
	draw_set_alpha(1);
}
else //좌단 바 열림
{
	draw_set_color(c_black);
	draw_rectangle(0,0,room_width*0.1,room_height,false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_line(room_width*0.100,room_height*0.43,room_width*0.115,room_height*0.46);
	draw_line(room_width*0.115,room_height*0.46,room_width*0.115,room_height*0.54);
	draw_line(room_width*0.115,room_height*0.54,room_width*0.100,room_height*0.57);
	draw_line(room_width*0.1,45,room_width*0.1,room_height*0.43);
	draw_line(room_width*0.1,room_height*0.57,room_width*0.1,room_height-45);
	draw_sprite_ext(sprite1,0,room_width*0.05,50*DPI+(room_height-100*DPI)/5*0.5,DPI,DPI,0,c_white,1);
	draw_sprite_ext(sprite1,1,room_width*0.05,50*DPI+(room_height-100*DPI)/5*1.5,DPI,DPI,0,c_white,1);
	draw_sprite_ext(sprite1,2,room_width*0.05,50*DPI+(room_height-100*DPI)/5*2.5,DPI,DPI,0,c_white,1);
	draw_sprite_ext(sprite1,3,room_width*0.05,50*DPI+(room_height-100*DPI)/5*3.5,DPI,DPI,0,c_white,1);
	draw_sprite_ext(sprite1,4,room_width*0.05,50*DPI+(room_height-100*DPI)/5*4.5,DPI,DPI,0,c_white,1);
}

//상단 바 그리기
//draw_set_color(c_white);
//draw_set_alpha(0.4);
//draw_set_color(make_color_rgb(20,20,20))
//draw_rectangle(0,0,room_width,40,false);
//draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(Spoqa_sdf); //Spoqa_14
var a;
var K = (room_width-20*DPI)/7
for(a=0;a<8;a++)
{
	if (layer_num=a-1 or layer_num=a){draw_set_alpha(1);}else{draw_set_alpha(0.3);}
	draw_line(10*DPI+K*a,12*DPI,10*DPI+K*a,32*DPI);
}
draw_set_alpha(1);
draw_line(0,45*DPI,K*(layer_num)-2*DPI,45*DPI);
draw_line(20*DPI+K*(layer_num+1)+2*DPI,45*DPI,room_width,45*DPI);
draw_set_halign(fa_center);
//layer_num
if layer_num=0{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*0.5,10*DPI,TL[? "0:1:0:0:0"],fs_14,fs_14,0);
if layer_num=1{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*1.5,10*DPI,TL[? "0:1:1:0:0"],fs_14,fs_14,0);
if layer_num=2{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*2.5,10*DPI,TL[? "0:1:2:0:0"],fs_14,fs_14,0);
if layer_num=3{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*3.5,10*DPI,TL[? "0:1:3:0:0"],fs_14,fs_14,0);
if layer_num=4{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*4.5,10*DPI,TL[? "0:1:4:0:0"],fs_14,fs_14,0);
if layer_num=5{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*5.5,10*DPI,TL[? "0:1:5:0:0"],fs_14,fs_14,0);
if layer_num=6{draw_set_alpha(1);}else{draw_set_alpha(0.3);}
draw_text_transformed(10*DPI+K*6.5,10*DPI,TL[? "0:1:6:0:0"],fs_14,fs_14,0);
draw_set_halign(fa_top);
draw_set_alpha(1);

//하단 바 그리기
draw_line(0,room_height-45*DPI,room_width,room_height-45*DPI);

//프로젝트 이름 드로우
draw_set_font(malgeun_sdf);  //malgeun_12
draw_text_transformed(10*DPI,room_height-40*DPI,ds_map_find_value(map_info,"title"),fs_12,fs_12,0);
//draw_text(300,room_height-40,program_directory);
//draw_text(500,room_height-40,working_directory);
//draw_text(700,room_height-40,temp_directory);

//오른쪽 마우스 메뉴 창 표시
if mb_R_menu>0
{
	draw_set_font(malgeun_8);
	switch (mb_R_menu)
	{
		case "2:1:2" : //그리기
			var a;
			draw_set_color(c_black);
			draw_roundrect(mb_R_menu_x,mb_R_menu_y,mb_R_menu_x+mb_R_menu_w,mb_R_menu_y+mb_R_menu_h,false);
			draw_set_color(c_white);
			draw_roundrect(mb_R_menu_x,mb_R_menu_y,mb_R_menu_x+mb_R_menu_w,mb_R_menu_y+mb_R_menu_h,true);
			for(a=0;a<mb_R_menu_n;a++)
			{
				draw_set_color(mb_R_menu_c[a]); //색 설정
				//"2:1:2:5:0"
				draw_text(mb_R_menu_x+5,mb_R_menu_y+5+14*a,TL[? "2:1:2:"+string(a)+":0"])
			}
		break;
		case "2:1:1" : //그리기
			var a;
			draw_set_color(c_black);
			draw_roundrect(mb_R_menu_x,mb_R_menu_y,mb_R_menu_x+mb_R_menu_w,mb_R_menu_y+mb_R_menu_h,false);
			draw_set_color(c_white);
			draw_roundrect(mb_R_menu_x,mb_R_menu_y,mb_R_menu_x+mb_R_menu_w,mb_R_menu_y+mb_R_menu_h,true);
			for(a=0;a<mb_R_menu_n;a++)
			{
				draw_set_color(mb_R_menu_c[a]); //색 설정
				//"2:1:2:5:0"
				draw_text(mb_R_menu_x+5,mb_R_menu_y+5+14*a,TL[? "2:1:1:"+string(a)+":0"])
			}
		break;
	}
}
draw_set_color(c_white)
draw_set_font(malgeun_sdf); //malgeun_12
var _y_pos=50*DPI
if debug_mode
draw_text_transformed(2*DPI,_y_pos-20,"debug_mode",fs_12,fs_12,0);
draw_text_transformed(2*DPI,_y_pos,"fps:"+string(fps),fs_12,fs_12,0);
draw_text_transformed(2*DPI,_y_pos+20*DPI,string(music_wave_size),fs_12,fs_12,0);
draw_text_transformed(2*DPI,_y_pos+40*DPI,ds_list_size(music_wave_buffer_list[music_wave_size]),fs_12,fs_12,0);
//ds_list_add(music_wave_buffer_list[2],3);

for(var a=0; a<ds_list_size(Debug_Text); a++)
{
	draw_text_transformed(10*DPI,320*DPI+15*a*DPI,Debug_Text[|a],fs_12,fs_12,0);
}

var b=0;
for(var a=0; a<ds_list_size(Input_Text); a++)
{
	if Input_Text[|a]!=0
	{
		draw_text_transformed(980*DPI,360*DPI+15*b*DPI,string(a)+" : "+string(Input_Text[|a]),fs_12,fs_12,0);
		b++;
	}
}

//테스트
//draw_text(70,50,async_test_value(100));