/*
 *     DOUBLE BLACK DIAMOND        DOUBLE BLACK DIAMOND
 *
 *         //\\   //\\                 //\\   //\\  
 *        ///\\\ ///\\\               ///\\\ ///\\\
 *        \\\/// \\\///               \\\/// \\\///
 *         \\//   \\//                 \\//   \\//H
 *
 *        EXPERTS ONLY!!              EXPERTS ONLY!!
 */

int nPointsPerPin = 252;

void buildOutputs() {
	lx.addOutput(new Beagle("10.200.1.40", 4));
	lx.addOutput(new Beagle("10.200.1.41", 2));
	lx.addOutput(new Beagle("10.200.1.42", 3));
	lx.addOutput(new Beagle("10.200.1.43", 1)); 
}

ArrayList<Beagle> beagles = new ArrayList<Beagle>();

class Beagle extends LXOutput {
	Socket      	socket;
	OutputStream  	output;
	int       		boardNum; 
	String      	host;
	byte[]      	packetData;
	int[] 			STRIP_ORD      = new int[] {10,  9, 12, 6 , 5, 8, 7, 11, 15, 3, 2, 1,  4, 14, 13, 16 };

	Beagle(String _host, int _boardNum) {
		super(lx); host = _host;
		enabled.setValue(false);
		boardNum  = _boardNum ;
		beagles.add(this);

		int numPixels  = nPointsPerPin*24;
		int numBytes   = 3 * numPixels;
		int packetLen  = 4 + numBytes;   //add header length 
		packetData    = new byte[packetLen];
		packetData[0] = 0;  // Channel
		packetData[1] = 0;  // Command (Set pixel colors)
		packetData[2] = (byte)((numBytes & 0x0000FF00) >> 8);
		packetData[3] = (byte)(numBytes & 0xFF);
	}

	void setPixel(int number, color c) {
		int offset = 4 + number * 3;
		packetData[offset + 0] = (byte) ((c >> 8)  & 0xFF); 
		packetData[offset + 1] = (byte) ((c >> 16)  & 0xFF);
		packetData[offset + 2] = (byte) ((c >> 0)  & 0xFF);
	}

	void onSend(int[] colors) {
		if (packetData == null || packetData.length == 0) return;
		if (output == null) {
			try {
				socket = new Socket();
                                socket.connect(new InetSocketAddress(host, 7890), 100);
				//socket.setTcpNoDelay(true);
				output = socket.getOutputStream();
				println("Connected to OPC server");
			} 
			catch (ConnectException e) {  dispose();  } 
			catch (IOException      e) {  dispose();  }
		}

		if (output == null) return;
		for (Cube c : model.cubes) {
			if (c.boardNum != boardNum) continue;
			int pinNum = c.pinNum, pi=0;
			for (int stripInd : STRIP_ORD) {
				Strip s = c.strips.get(stripInd-1);
				int stripLen = (stripInd == 10 || stripInd == 16 || stripInd == 12 || stripInd == 14) ? 15 : 16;  

				//to-do, make sure this is right, some pixels are off on actual structure
				for (int i = stripLen-1; i >= 0; --i) {
					setPixel(pinNum*nPointsPerPin + pi, colors[s.points.get(i).index]); // this is terrible.
					++pi;
				}
			}
		}

		if (mappingTool.mappingMode == mappingTool.MAPPING_MODE_DIGI && mappingMode == true) {
			for (int i=0; i<24; i++) {
				for (int j=0; j<nPointsPerPin; j++) {
					setPixel( i*nPointsPerPin + j, 0);
					int nOnes = i % 10;
					int nTens = ((int)i/10) % 10;
					for (int l=0; l<5; l++) {
						for (int k=0; k<boardNum; k++) setPixel(i*nPointsPerPin+l*30+20+k, #0000FF);
						for (int k=0; k<nTens   ; k++) setPixel(i*nPointsPerPin+l*30+10+k, #00FF00);
						for (int k=0; k<nOnes   ; k++) setPixel(i*nPointsPerPin+l*30+   k, #FF0000);
					}
				}
			}
		}



		if (mappingTool.mappingMode == mappingTool.MAPPING_MODE_FADE && mappingMode == true) {
			int n = 10+(int)(10*lx.tempo.rampf());
			color c = lx.hsb(0,0,n);
			for (int i=0; i<24; i++) {
				for (int j=0; j<nPointsPerPin; j++) {
					setPixel( i*nPointsPerPin + j, c);
				}
			}
		}



		try { output.write(packetData);} 
		catch (Exception e) {dispose();}
	}  

	void dispose() {
		if (output != null)  println("Disconnected from OPC server");
		println("Failed to connect to OPC server " + host);
		socket = null;
		output = null;
	}
}
//---------------------------------------------------------------------------------------------
class UIOutput extends UIWindow {
	UIOutput(float x, float y, float w, float h) {
		super(lx.ui,"OUTPUT",x,y,w,h);
		float yPos = UIWindow.TITLE_LABEL_HEIGHT - 2;
		List<UIItemList.Item> items = new ArrayList<UIItemList.Item>();
		for (Beagle b : beagles) { items.add(new BeagleItem(b)); }
		new UIItemList(1, yPos, width-2, 260)
			.setItems			(items		)
			.addToContainer		(this		);
	}

	class BeagleItem extends UIItemList.AbstractItem {
		final Beagle beagle;
		BeagleItem(Beagle _beagle) {
		  this.beagle = _beagle;
		  beagle.enabled.addListener(new LXParameterListener() {
		    public void onParameterChanged(LXParameter parameter) { redraw(); }
		  });
		}
		String  getLabel  () { return beagle.host; }
		boolean isSelected() { return beagle.enabled.isOn(); }
		void onMousePressed() { beagle.enabled.toggle(); }
	}
}
//---------------------------------------------------------------------------------------------
