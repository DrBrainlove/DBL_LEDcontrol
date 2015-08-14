uniform mat4 transform;
attribute vec4 vertex;
attribute vec4 color;
varying vec4 vertColor;
attribute float pointsize;
void main() {
  gl_Position = transform * vertex;  
  vertColor = color;
  gl_PointSize = 2.0;
}

