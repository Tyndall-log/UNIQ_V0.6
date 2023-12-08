/// @description Insert description here
// You can write your code in this editor
realtime=current_time
currentAsync = createDSMapAsync("key",0);
show_debug_message("delta time: "+string(current_time-realtime))
realtime=current_time