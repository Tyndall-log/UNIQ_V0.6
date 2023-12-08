function rgb_to_hsv(argument0, argument1, argument2) {
	//R, G and B input range = 0 ÷ 255
	//H, S and V output range = 0 ÷ 1.0
	var var_R,var_G,var_B,var_Min,var_Max,del_Max,Return,del_R,del_G,del_B;

	var_R = ( argument0 / 255 )
	var_G = ( argument1 / 255 )
	var_B = ( argument2 / 255 )

	var_Min = min( var_R, var_G, var_B )    //Min. value of RGB
	var_Max = max( var_R, var_G, var_B )    //Max. value of RGB
	del_Max = var_Max - var_Min             //Delta RGB value

	Return[2] = var_Max //V

	if ( del_Max == 0 )                     //This is a gray, no chroma...
	{
	    Return[0] = 0 //H
	    Return[1] = 0 //S
	}
	else                                    //Chromatic data...
	{
	   Return[1] = del_Max / var_Max

	   del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
	   del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
	   del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

	   if      ( var_R == var_Max ) Return[0] = del_B - del_G
	   else if ( var_G == var_Max ) Return[0] = ( 1 / 3 ) + del_R - del_B
	   else if ( var_B == var_Max ) Return[0] = ( 2 / 3 ) + del_G - del_R

	    if ( Return[0] < 0 ) Return[0] += 1
	    if ( Return[0] > 1 ) Return[0] -= 1
	}
	return Return;


}
