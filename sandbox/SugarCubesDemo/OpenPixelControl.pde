
import java.io.*;
import java.net.*;

// Server for Open Pixel Control patterns (http://openpixelcontrol.org/)
public class OpenPixelControl extends SCPattern implements Runnable {

    int port = 7890;
    Thread thread;
    ServerSocket server;
    byte[] buffer;
    int bufferedByteCount;

    public OpenPixelControl(LX lx, PApplet parent) {
        super(lx);
        parent.registerMethod("dispose", this);

        // Save a JSON layout file that some Open Pixel Control clients can use
        writeMappingFile("openpixelcontrol-layout.json");

        // Buffer space for two frames, worst case
        buffer = new byte[0x10004 * 2];
        bufferedByteCount = 0;
    }

    public void dispose() {
        thread = null;
        if (server != null) {
            try {
                server.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            server = null;
        }
    }

    public void run() {
        // Thread run function; handle OPC traffic.
        while (Thread.currentThread() == thread) {

            try {
                Socket cli = server.accept();
                InputStream input = cli.getInputStream();
                bufferedByteCount = 0;

                while (Thread.currentThread() == thread) {

                    int r = input.read(buffer, bufferedByteCount, buffer.length - bufferedByteCount);
                    if (r <= 0) {
                        break;
                    }
                    bufferedByteCount += r;

                    // Extract OPC packets from buffer
                    int offset = 0;
                    while (bufferedByteCount - offset >= 4) {
                        int channel = buffer[offset + 0] & 0xFF;
                        int command = buffer[offset + 1] & 0xFF;
                        int length = ((buffer[offset + 2] & 0xFF) << 8) | (buffer[offset + 3] & 0xFF);

                        if (bufferedByteCount - offset < length + 4) {
                            // Not enough data for a full packet yet
                            break;
                        }

                        // Handle the packet in-place
                        offset += 4;
                        opcPacket(channel, command, offset, length);
                        offset += length;
                    }

                    // If we didn't use the whole buffer, save remainder for later
                    bufferedByteCount -= offset;
                    arrayCopy(buffer, offset, buffer, 0, bufferedByteCount);
                }

                cli.close();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void run(double deltaMs) {
        // SCPattern run function; nothing to do except start our thread the first time.

        if (server == null) {
            try {
                server = new ServerSocket(this.port);
                thread = new Thread(this);
                thread.start();
                println("Listening for Open Pixel Control data on port " + port);

            } catch (IOException e) {
                e.printStackTrace();
                thread = null;
            }
        }
    }

    void opcPacket(int channel, int command, int offset, int length) {
        // Only look at "Set Pixel Colors" to channel 0.
        if (channel == 0 && command == 0) {

            // Unpack colors directly into framebuffer
            for (int i = 0; i < length / 3; i++) {
                if (i >= colors.length) {
                    break;
                }

                colors[i] =
                    ((buffer[offset + 0] & 0xFF) << 16) |
                    ((buffer[offset + 1] & 0xFF) << 8)  |
                     (buffer[offset + 2] & 0xFF) ;

                offset += 3;
            }
        }
    }

    void writeMappingFile(String filename) {
        PrintWriter output;
        output = createWriter(filename);

        // Rearrange points by color buffer index
        LXPoint[] orderedPoints;
        int maxIndex = 0;
        for (LXPoint p : model.points) {
            maxIndex = max(maxIndex, p.index);
        }
        orderedPoints = new LXPoint[maxIndex + 1];
        for (LXPoint p : model.points) {
            orderedPoints[p.index] = p;
        }

        float xCenter = (model.xMax + model.xMin) / 2.0;
        float yCenter = (model.yMax + model.yMin) / 2.0;
        float zCenter = (model.zMax + model.zMin) / 2.0;
        float xSize = model.xMax - model.xMin;
        float zSize = model.zMax - model.zMin;
        float maxSize = max(xSize, zSize);
        float scale = 4.0 / maxSize;

        output.print("[");
        for (int i = 0; i < orderedPoints.length; i++) {
            boolean isLast = i == orderedPoints.length - 1;
            String comma = isLast ? "" : ",";
            LXPoint p = orderedPoints[i];

            if (p == null) {
                // Unused index
                output.print("null" + comma);
            } else {
                // Transform coordinates to make sense in the OPC visualizer
                float x = (p.x - xCenter) * scale;
                float y = (p.z - zCenter) * scale;
                float z = (p.y - yCenter) * scale;

                output.print("{\"point\":[" + x + "," + y + "," + z + "]}" + comma);
            }
        }
        output.print("]");

        output.flush();
        output.close();
        println("Saved OpenPixelControl model to " + filename);
    }
};
