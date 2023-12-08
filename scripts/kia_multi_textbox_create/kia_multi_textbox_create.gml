///kia_multi_textbox_create(width,height)
function kia_multi_textbox_create(argument0, argument1) {
	kia_multi_textbox_list = ds_list_create();
	kia_multi_textbox_line_now = 0;

	kia_multi_textbox_width = argument0;
	kia_multi_textbox_height = argument1;

	kia_multi_textbox_line_num = floor(kia_multi_textbox_height/string_height("가A"))


}
