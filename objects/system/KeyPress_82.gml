/// @description Insert description here
// You can write your code in this editor
//game_restart();
//show_message_async("리셋 되었습니다.");

for(var a = 0; a < 10; a++)
{
	for (var b = a; b < 10; b++)
	{
		midi_output_velocity_set(Midi_output_id[0], a, b, 0)
	}
}