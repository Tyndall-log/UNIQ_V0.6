/// @description wav_load(filename) 
/// @param filename
function wav_load(argument0) {
	var _wav = file_bin_open(argument0, 0),a=12,Chunk_ID,Chunk_Data_Size,rIDRiff,rRiffSize,rFormat,FL;

	//RIFF
	rIDRiff = bin_read_string(_wav, 0, 4, 0);
	rRiffSize = bin_read_real(_wav, 4, 4, 1);
	rFormat = bin_read_string(_wav, 8, 4, 0);
	
	if(rIDRiff == "RIFF" and rFormat == "WAVE") //wav 파일인지 확인
	{
	  if rRiffSize != file_bin_size(_wav) - 8 show_debug_message("wav 파일 크기 오류")
	  while (a<rRiffSize)
	  {
	    Chunk_ID=bin_read_string(_wav, a, 4, 0)
	    Chunk_Data_Size=bin_read_real(_wav, a+4, 4, 1)
	    switch(Chunk_ID)
	    {
	      case "fmt ":
	      {
		
	        //fIDFmt       = bin_read_string (_wav, a   , 4, 0);
	        //fSize        = bin_read_real   (_wav, a+4 , 4, 1);
	        //fAudioFormat = bin_read_real   (_wav, a+8 , 2, 1);
	        //fChannels    = bin_read_real   (_wav, a+10, 2, 1);
	        fSampleRate  = bin_read_real   (_wav, a+12, 4, 1);
	        //fByteRate    = bin_read_real   (_wav, a+16, 4, 1);
	        //fBlockAlign  = bin_read_real   (_wav, a+20, 2, 1);
	        //fBPS         = bin_read_real   (_wav, a+22, 2, 1);
	        //추가 정보는 불러오지 않음
	        break;
	      }
	      case "data":
	      {
	        //dIDData = bin_read_string(_wav,a, 4, 0);
	        dSize = bin_read_real(_wav,a + 4, 4, 1);
			FL=buffer_create(file_bin_size(_wav),buffer_fixed,2);
			buffer_load_ext(FL, argument0,0);
	        Music_Pos=a+8 //음악 위치
	        break;
	      }
	    }
	    a+=8+Chunk_Data_Size //읽을 위치를 구해 a에 저장합니다.
	    //show_debug_message("Chunk_ID:"+string(Chunk_ID)+"	size:"+string(file_bin_size(_wav))+"	a:"+string(a))
	  }
	}
	else
	{
		FL=-1;
		show_debug_message("!!! wav 오류 !!!")
	}
	file_bin_close(_wav);
	return FL;


}
