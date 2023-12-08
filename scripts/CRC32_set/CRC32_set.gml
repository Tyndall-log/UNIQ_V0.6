function CRC32_set() {
	// same as before
	var i,j,crc,Polynomial = 0xEDB88320;
	for (i = 0; i <= 0xFF; i++)
	{
		crc = i;
		for (j = 0; j < 8; j++)
			crc = (crc >> 1) ^ ((crc & 1) * Polynomial);
		Crc32Lookup[0,i] = crc;
	}
	for (i = 0; i <= 0xFF; i++)
	{
		//Slicing-by-8
		Crc32Lookup[1,i] = (Crc32Lookup[0,i] >> 8) ^ Crc32Lookup[0,Crc32Lookup[0,i] & 0xFF];
		Crc32Lookup[2,i] = (Crc32Lookup[1,i] >> 8) ^ Crc32Lookup[0,Crc32Lookup[1,i] & 0xFF];
		Crc32Lookup[3,i] = (Crc32Lookup[2,i] >> 8) ^ Crc32Lookup[0,Crc32Lookup[2,i] & 0xFF];
	}


}
