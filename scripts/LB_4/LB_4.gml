function LB_4() {
	var a,_G=load_csv(get_open_filename("uniQ(.csv)|*.csv","입력"));
	ds_map_clear(TL);
	for(a=0;a<ds_grid_height(_G);a++)
	{
		TL[? _G[# 0,a]]=_G[# 1,a];
	}
	ds_grid_destroy(_G);


}
