/// @description zip_dir(dir,zip_save)
/// @param dir
/// @param zip_save
function YYCF(argument0, argument1) {

	var zip=zip_create();
	zip_add_dir(zip,argument0,"");
	zip_save(zip,argument1);
	zip_destroy(zip);


}
