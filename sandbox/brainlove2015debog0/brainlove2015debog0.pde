import hypermedia.net.*;

UDP udp;
int count = 0;
int temp;
byte[] packet = new byte[1353];
//AudioFile myInput; 
//AudioStream myStream; 
//FFT myFFT; 
float volume; 
float avgVol; 
void setup() {

  udp = new UDP(this, 6038);
  udp.listen( true );

  packet[00] = 0x00;
  
  int cstart = 0;

}

void draw() {
  // set string port here:
  // packet[16] = 0x01
   
  int colNum = 0;

  
  for (int y=0;y<64;y++)
  {
 
      for (int i = 0; i < 449; i++) {

        packet[((i+1)*3)+0] = byte(i%2*64+y);
        packet[((i+1)*3)+1] = byte(i%4*32+y);
        packet[((i+1)*3)+2] = byte(i%8*16+y);
        
       
        
        // packet[(i*3)+1] = byte(i%16-i);
        
//        packet[21+(i*3)+1] = byte(255-i);
//        packet[21+(i*3)+2] = byte(255-i*2);
      }
      
      
    
       packet[00] = 0x00;
       udp.send(packet, "10.4.2.11");
    
      packet[00] = 0x01;
       udp.send(packet, "10.4.2.11");
       
        packet[01] = 0x00;
       udp.send(packet, "10.4.2.11");
    
      packet[01] = 0x01;
       udp.send(packet, "10.4.2.11");
     //  delay(10);
      
  }
      

}
