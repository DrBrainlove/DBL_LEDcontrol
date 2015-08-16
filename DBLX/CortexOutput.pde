/*
 * Motor cortex:
 * Create output to the LEDs via OSC packets to BeagleBone Black
 * Each BBB pushes up to 24 channels of <=512 pixels per channel
 *
 * @author mjp 2015.08.08
 */


import java.io.IOException;
import java.io.OutputStream;
import java.net.ConnectException;
import java.net.InetSocketAddress;
import java.net.Socket;

import heronarts.lx.LX;


int nPixPerChannel = 512; // OPC server is set to 512 pix per channel
int nChannelPerBoard = 24;

String[] outputIP = {"192.168.1.80", "192.168.1.81"};

/*
void buildOutputs() {
    for(int i=0; i<model.channelMap.size; i++) {
        int[] indexMap = model.channelMap.get(i);
        int boardNum = int(i/nChannelPerBoard);
        lx.addOutput(new ChannelOutput(outputIP[boardNum], boardNum, i, indexMap))
    }
}
*/

ArrayList<CortexOutput> channelList = new ArrayList<CortexOutput>();


public class CortexOutput extends LXOutput {
    // constants for creating OPC header
    static final int HEADER_LEN = 4;
    static final int BYTES_PER_PIXEL = 3;
    static final int INDEX_CHANNEL = 0;
    static final int INDEX_COMMAND = 1;
    static final int INDEX_DATA_LEN_MSB = 2;
    static final int INDEX_DATA_LEN_LSB = 3;
    static final int INDEX_DATA = 4;
    static final int OFFSET_R = 0;
    static final int OFFSET_G = 1;
    static final int OFFSET_B = 2;

    static final int COMMAND_SET_PIXEL_COLORS = 0;

    static final int PORT = 7890; //the standard OPC port

    Socket socket;
    OutputStream output;
    String host;
    int port = 7890;

    public int boardNum;
    public int channelNum; 
    public byte[] packetData;

    private final int[] pointIndices;


    CortexOutput(LX lx, String _host, int _boardNum, int _channelNum, int[] _pointIndices) {
        super(lx);
        this.boardNum = _boardNum;
        this.channelNum = _channelNum;
        this.pointIndices = _pointIndices;
        
        channelList.add(this);

        int dataLength = BYTES_PER_PIXEL*nPixPerChannel;
        this.packetData = new byte[HEADER_LEN + dataLength];
        this.packetData[INDEX_CHANNEL] = (byte)(channelNum & 0xFF);
        this.packetData[INDEX_COMMAND] = COMMAND_SET_PIXEL_COLORS;
        this.packetData[INDEX_DATA_LEN_MSB] = (byte)(dataLength >>> 8);
        this.packetData[INDEX_DATA_LEN_LSB] = (byte)(dataLength & 0xFF);
    }


    public boolean isConnected() {
        return (this.output != null);
    }

    private void connect() {
        // if (this.socket == null) {
        if (this.output == null) {
            try {
                this.socket = new Socket();
                this.socket.connect(new InetSocketAddress(this.host, this.port), 100);
                // this.socket.setTcpNoDelay(true); // disable on SugarCubes
                this.output = this.socket.getOutputStream();
                didConnect();
            } 
            catch (ConnectException cx) { dispose(cx); } 
            catch (IOException iox) { dispose(iox); }
        }
    }

    protected void didConnect() {
        println("Connected to OPC server: " + host + " for channel " + channelNum);
    }

    protected void dispose(Exception x) {
        if (output != null)  println("Disconnected from OPC server");
        this.socket = null;
        this.output = null;
        didDispose(x);
    }

    protected void didDispose(Exception x) {
        println("Failed to connect to OPC server " + host);
    }

    // @Override
    protected void onSend(int[] colors) {
        if (packetData == null || packetData.length == 0) return;

        connect();
        if (isConnected()) {
          try {
            this.output.write(getPacketData(colors));
        } catch (IOException iox) {
            dispose(iox);
        }
    }
    }

    // @Override
    protected byte[] getPacketData(int[] colors) {
        for (int i = 0; i < this.pointIndices.length; ++i) {
            int dataOffset = INDEX_DATA + i * BYTES_PER_PIXEL;
            int c = colors[this.pointIndices[i]];
            this.packetData[dataOffset + OFFSET_R] = (byte) (0xFF & (c >> 16));
            this.packetData[dataOffset + OFFSET_G] = (byte) (0xFF & (c >> 8));
            this.packetData[dataOffset + OFFSET_B] = (byte) (0xFF & c);
        }
        // all other values in packetData should be 0 by default
        return this.packetData;
    }

}




//---------------------------------------------------------------------------------------------
// add UI components for the hardware, allowing enable/disable

// mjp 2015.08.15 currently broken, gives array out of bounds error somewhere

class UIOutput extends UIWindow {
    UIOutput(UI ui, float x, float y, float w, float h) {
        super(ui,"OUTPUT",x,y,w,h);
        float yPos = UIWindow.TITLE_LABEL_HEIGHT - 2;
        List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
        items.add(new OutputItem());

        new UIItemList(1, yPos, width-2, 260)
            .setItems           (items      )
            .addToContainer     (this       );
    }

    class OutputItem extends UIItemList.AbstractItem {
        OutputItem() {
            for(CortexOutput ch : channelList) {
                ch.enabled.addListener(new LXParameterListener(){
                    public void onParameterChanged(LXParameter parameter) { redraw();}
                });
            }
        } 
        String getLabel() { return "ALL CHANNELS"; }
        boolean isSelected() { 
            // jut check the first one, since they either should all be on or all be off
            return channelList.get(0).enabled.isOn(); 
        }
        void onMousePressed() { 
            for(CortexOutput ch : channelList) { ch.enabled.toggle(); }
        }
    }
}

//---------------------------------------------------------------------------------------------


