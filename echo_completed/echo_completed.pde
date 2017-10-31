import processing.serial.*;
Serial myPort;
String val;

void setup()
{
  background(255);
  size(700,700);
  String usbmodem1411 = Serial.list()[0];
  myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  ellipseMode(CENTER);
  val = "";
}    

void draw()
{
   //background(255);
    fill(0, 102, 153);
    val="";
  if (myPort.available() > 0)
  {
    val = myPort.readStringUntil('\n');
  }
  
  if(val != null) {
     float value = float(val);
      println(val);
     //if(val != null) println(val);
     ellipse(width/2,height/2,value,value);
  }

}