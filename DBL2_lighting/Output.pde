/* 
* Dr. Brainlove lighting
*
* output to physical hardware
* mjp 2015
*
* currently sending output to Teensy arduino
* basic packet format is 3 bytes at the nhead for commands and 
* then RGB values
*/
import java.net.DatagramSocket;
import java.net.SocketException;
import java.net.UnknownHostException;

int UDP_PORT = 6038;


void buildOutputs() {
  if (!SIMULATION) { 
    try {
      lx.addOutput(new Teensy("10.4.2.40", 0, new int[] {600, 638} ));
    } catch(SocketException e) {
      println("Could not add outputs to LX engine");
      e.printStackTrace();
      //throw e;
    } 
  }
}

// use the controllers list for internal reference to the output controllers
ArrayList<Teensy> controllers = new ArrayList<Teensy>();



class Teensy extends LXDatagramOutput {
  Teensy(String _host, int _boardNum, int[] _stripLengths) throws SocketException {
    super(lx);
    enabled.setValue(true);
    String host = _host;
    int boardNum = _boardNum;
    int[] stripLengths = _stripLengths; // number of strips and pixels on each strip for this board
    controllers.add(this);

    
    for (int stripix=0; stripix< stripLengths.length; stripix++) {
      // create array of indices from bar strip path
      int pxCount = 0;
      int stripOffset = 0;
      int[] stripIxBuffer = new int[3000]; //arbitrary length, will copy to actual array
      //for (Map.Entry<String, Bar> entry : model.barmap.entrySet()) {
      for (Bar b : model.barmap.values()) {
        println("# pixels in bar " + b.id + ": " + str(b.points.size()));
        // turn this back on when we add board number to the bars
        //if (b.boardNum != boardNum) continue;
        //if (bar.stripix != stripix ) continue; //use this instead of line below when we have strip index
        if (pxCount + b.points.size() > stripLengths[stripix]) break; // move to next strip
        
        for (int i=0; i < b.points.size(); i++, pxCount++) {
          stripIxBuffer[pxCount] = b.points.get(i).index;
          if(pxCount+1 % TeensyDatagram.PKT_NPIXEL == 0) {
            int n = pxCount - stripOffset+1;
            int[] colorIndices = new int[n];
            System.arraycopy(stripIxBuffer, stripOffset, colorIndices, 0, n);
            try {
              TeensyDatagram dg = new TeensyDatagram(stripix, pxCount, colorIndices);
              dg.setAddress(host);
              this.addDatagram(dg);
            } catch (UnknownHostException e) {
              println("***** Could not connect to controller: " + host);
            }
            stripOffset = pxCount+1; //update the offset
          }
        }

      } //end bar
    
    } //end strip
    
  }
}

class TeensyDatagram extends LXDatagram {
  private final static int PKT_NPIXEL = 450;
  private final static int PKT_HEADERLEN = 3;
  private final static int PKT_DATALEN = PKT_NPIXEL * 3; // 1350
  private final static int PACKETLEN = PKT_HEADERLEN + PKT_DATALEN; // number of bytes in packet, incl 3 byte header

  private final int[] pointIndices; // get these from bars in section

  /**
  * Construct a datagram with 3 byte header: strip index, index of datagram offset, and global brightness
  * @param _stripix    index of the strip our target Teensy is contzrolling
  * @param _stripoffset starting index within strip for this 450 pixel datagram
  * @param indices    list of the global indices for the color array for this datagram
  */
  TeensyDatagram(int _stripix, int _stripOffset, int[] indices) {
    super(PACKETLEN);
    setPort(UDP_PORT);
    this.pointIndices = indices; 
    this.buffer[0] = (byte) (_stripix);
    this.buffer[1] = (byte) (_stripOffset);
    this.buffer[2] = (byte) 0xFF; // brightness
  }
  public void onSend(int[] colors) {
    copyPoints(colors, this.pointIndices, PKT_HEADERLEN);
  }

}









/*

class Teensy extends LXOutput {
  Socket      socket;
  OutputStream  output;
  int        boardNum;
  String      host;
  byte[]      packetData;
  int        brightness;
  //int[]      STRIP_ORD = new int[] {0, 1};

  Teensy(String _host, int _boardNum, int[] _stripLenths) {
    super(lx);
    enabled.setValue(true);
    host = _host;
    boardNum = _boardNum;
    brightness = 255; // software brightness, global control
    int[] stripLenths = _stripLenths; // number of strips and pixels on each strip for this board
    controllers.add(this);

    packetData = new byte[PACKETLEN]; //fixed packet len
    packetData[0] = 0; // strip index on controller
    packetData[1] = 0; // pixel offset within strip
    packetData[2] = (byte)(brightness & 0xFF); // FastLED software brightness
    // TODO: we can limit the hardware brightness globally in Processing this way

  }
  void setBrightness(int _brightness) {
    brightness = _brightness;
  }
  void setPixel(int pixelix, color c) {
    // FastLED will flip the byte order as necessary
    int offset = PKT_HEADERLEN + pixelix * 3;
    packetData[offset + 0] = (byte) ((c >> 16)  & 0xFF); // R
    packetData[offset + 1] = (byte) ((c >> 8)  & 0xFF);   // G
    packetData[offset + 2] = (byte) ((c >> 0)  & 0xFF);   // B
  }
  void onSend(int[] colors) {
    if (packetData == null || packetData.length == 0) return;
    if (output == null) {
      try {
        socket = new Socket();
        socket.connect(new InetSocketAddress(host, UDP_PORT), 100);
        output = socket.getOutputStream();
        println("Connected to controller");
      }
      catch (ConnectException e) { dispose(); }
      catch (IOException e) { dispose(); }
    }

    // barmap is a map sorted in the order of the strips
    int pxCount = 0;
    for (int stripLen : stripLenths) {
      for (Bar b : model.barmap) { //may need to be over physicalbarmap?
        // will eventually need to add check to see what board bar is connected to
        // if(b.boardNum != boardNum) continue;
        if (pxCount + b.points.size() >= stripLen) continue; // move to next strip
        pxCount += b.points.size();
        for (int i = 0; i< b.points.size(); i++) {
          setPixel(i, colors[b.points.get(i).index])
        }
      }
    }

    try { output.write(packetData); }
    catch (Exception e) { dispose();}
  }

  void dispose() {
    if (output != null) println("Disconnected from controller");
    println("Failed to connect to controller " + host);
    socket = null;
    output = null;
  }

}
*/

//---------------------------------------------------------------------------------------------
/*
class UIOutput extends UIWindow {
  UIOutput(float x, float y, float w, float h) {
    super(lx.ui, "OUTPUT", x,y,w,h);
    float yPos = UIWindow.TITLE_LABEL_HEIGHT -2;
    List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
    for (Teensy t : controllers) { items.add(new TeensyItem(t)); }
    new UIItemList(1,yPos, width-2, 260)
      .setItems(items)
      .addtoContainer(this);
  }

  class TeensyItem extends UIItemList.AbstractItem {
    final Teensy teensy;
    TeensyItem(Teensy _teensy) {
      this.teensy = _teensy;
      teensy.enabled.addListener(new LXParameterListener() {
        public void onParameterChanged(LXParameter parameter) { redraw(); }
      });
    }
    String getLabel() { return teensy.host; }
    boolean isSelected() { return teensy.enabled.isOn(); }
    void onMousePressed() { teensy.enabled.toggle(); }
  }

}
*/
