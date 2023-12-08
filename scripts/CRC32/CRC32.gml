/// @description CRC32(bufferID,offset,size)
/// @param bufferID
/// @param offset
/// @param size
function CRC32(argument0, argument1, argument2) {
	buffer_seek(argument0, buffer_seek_start, argument1);
	var crc = $ffffffff;
	// process four bytes at once
	repeat(argument2 div 4)
	{
		crc = crc ^ buffer_read(argument0,buffer_u32);
		crc = Crc32Lookup[3, crc      & 0xFF] ^
		      Crc32Lookup[2,(crc>>8 ) & 0xFF] ^
		      Crc32Lookup[1,(crc>>16) & 0xFF] ^
		      Crc32Lookup[0, crc>>24        ];
	}
	// remaining 1 to 3 bytes
	repeat(argument2 mod 4)
	{
		crc = (crc >> 8) ^ Crc32Lookup[0,(crc & 0xFF) ^ buffer_read(argument0,buffer_u8)];
	}
	//return ~crc;
	return (crc ^ $ffffffff);


}
