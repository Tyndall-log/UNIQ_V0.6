function L5_draw() {
	var LW=room_width,LH=room_height-100;
	/*
	title | Alan Walker - All Falls Down
	buttonX | 8
	buttonY | 8
	producerName | 원작 : Lassive 유니팩 원작 : UnaLataDeFrijoles MCLED 수정 : Ussiliver(google0231)
	chain | 5
	squareButton | true
	PackTool | Unitor;3.1.0.0
	*/
	draw_set_font(malgeun_15);
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
	draw_text(LW*0.15,50+LH*0.5-90,"title = "       +ds_map_find_value(map_info,"title")       +"");
	draw_text(LW*0.15,50+LH*0.5-60,"buttonX = "     +ds_map_find_value(map_info,"buttonX")     +"");
	draw_text(LW*0.15,50+LH*0.5-30,"buttonY = "     +ds_map_find_value(map_info,"buttonY")     +"");
	draw_text(LW*0.15,50+LH*0.5   ,"producerName = "+ds_map_find_value(map_info,"producerName")+"");
	draw_text(LW*0.15,50+LH*0.5+30,"chain = "       +ds_map_find_value(map_info,"chain")       +"");
	draw_text(LW*0.15,50+LH*0.5+60,"squareButton = "+ds_map_find_value(map_info,"squareButton")+"");
	draw_text(LW*0.15,50+LH*0.5+90,"PackTool = "    +ds_map_find_value(map_info,"PackTool")    +"");
	draw_set_valign(fa_top);


}
