///kia_second(ord)
function kia_second(argument0) {
	if argument0 > $AC00 && argument0 < $D7A3
	{
	    return floor(((argument0-$AC00)/28)%21)
	}


}
