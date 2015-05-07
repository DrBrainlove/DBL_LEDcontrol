import hypermedia.net.*;

UDP udp;

int temp;
byte[] packet = new byte[536];
//AudioFile myInput; 
//AudioStream myStream; 
//FFT myFFT; 
float volume; 
float avgVol; 

float led_gain = 0.25;
int count =0;

void setup() {

  udp = new UDP(this, 6038);
  udp.listen( true );

  packet[00] = 0x04;
  packet[01] = 0x01;
  packet[02] = byte(0xdc);
  packet[03] = byte(0x4a);
  packet[04] = 0x01;
 // packet[05] = 0x00; //???? was not in orig code


  packet[06] = 0x01;
  packet[07] = 0x01;

  packet[16] = byte(0xff);  
  packet[17] = byte(0xff);
  packet[18] = byte(0xff);
  packet[19] = byte(0xff);  // port # string is connected to on the power supply.
  // packet[21] = 0x02;
  //packet[22] = byte(0x01); // number of ports
  //packet[23] = byte(0xff);
}

void draw() {
  // set string port here:
  // packet[16] = 0x01
    count++;
    
    for (int i = 0; i < 144; i++) {

      packet[21+(i*3)+2] = byte(64);
      //packet[21+(i*3)+2] = byte(int(255*led_gain));
      //packet[21+(i*3)+1] = byte(255-i);
      //packet[21+(i*3)+2] = byte(255-i*2);
    }

    delay(30); //some power supplies freak out if this is less than 30ms or so
    udp.send(packet, "10.4.2.10");

}
