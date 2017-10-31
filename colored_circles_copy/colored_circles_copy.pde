//==============================================================
// sketch:  PG_RandomSpherePoints_Cook.pde by Gerd Platl
// create random points on a sphere surface
// version: v1.0  2012-09-07   initial version  
//          v1.1  2014-04-14   usage of class 
//          v1.2  2017-08-30   draw colorized dots
//          v1.3  2017-09-17   createPoints() added
//          v1.4  2017-09-27   timer added
// tags: random, distributed, sphere, surface, points, uniform
//==============================================================
/** 
 Cook (1957) extended a method of von Neumann (1951) to give a simple method 
 of picking points uniformly distributed on the surface of a unit sphere. <bs>

 Pick four numbers a,b,c, and d from a uniform distribution on (-1,1), 
 and reject pairs with k>=1 where k=a^2+b^2+c^2+d^2. 

 From the remaining points, the rules of quaternion transformation then imply 
 that the points with Cartesian coordinates
   x = 2*(b*d +a*c) / k
   y = 2*(c*d -a*b) / k
   z = (a^2 +d^2 -b^2 -c^2) / k
 have the desired distribution (Cook 1957, Marsaglia 1972). 

 Press mouse button to rotate sphere. 
 Press 'spacekey' to generate new dots, '+'/'-' for zoom, 
 'i', 'o' or 'c' for different dot distributions, 
 's' for saving picture, 'r' to reset zoom and 'h' for help
*/
//--------------------------------------------------------

final String title = ">>> PG_RandomSpherePoints_Cook v1.4 <<<";

int randomPoints = 2000;
int timer = 400;
float rotX, rotY = 0.0;
randomSpherePoints dots;
//--------------------------------------------------------
void setup()
{
  size(800, 800, P3D);
  String usbmodem1411 = Serial.list()[0];
  myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  println (title);
  smooth();
  stroke(40, 166);
  strokeWeight(4.0);
  sphereDetail(6,8);
  lights();
  dots = new randomSpherePoints (randomPoints, width * 0.4);
  val = "";
}
//--------------------------------------------------------
void draw()
{
  background(222);
  // draw text information
  if (--timer > 0)
  {
    fill (0, timer);

    textAlign(RIGHT);
    text (round(frameRate+0.2) + " fps", width-10, 30);

    textAlign(LEFT);
    text (title,10,30);
    text (" o/i on/in sphere",10,50);
    text ("  c  cube dots",10,70);
    text ("  m  draw balls/dots",10,90);
    text (" ' ' random dots",10,110);
    text (" +/- zoom in/out",10,130);
    text ("  s  save picture",10,150);
    text ("  r  reset",10,170);
    text ("  h  help",10,190);
    
    val="";
     if (myPort.available() > 0)
  {
    val = myPort.readStringUntil('\n');
  }
   if(val != null) {
     float value = float(val);
     println(val);
   }
  
  }
  
  // draw 3d scenery
  translate(width*0.5, height*0.5);
  rotateX (rotX);
  rotateY (rotY);
  dots.draw();
  rotY += 0.009; //changes speed of rotation
  
  // do interaction
  if (mousePressed)
  {
     rotY += (pmouseX - mouseX) * -0.002;
     rotX += (pmouseY - mouseY) * +0.002;
     //println (round(frameRate) + " fps");
  }
  if (keyPressed) repeatKeyAction();
}
//--------------------------------------------------------
void repeatKeyAction()
{
  if (key == '-') dots.resize (0.99);
  if (key == '+') dots.resize (1.01);
  if (key == ' ') dots.createPoints();
}
//--------------------------------------------------------
void keyPressed()
{
  switch (key)
  {        case 'h': case '?': timer = 400;
    break; case 'i': dots.createPointsInSphere();
    break; case 'o': dots.createPointsOnSphere();
    break; case 'c': dots.createPointsInCube();
    break; case 'm': dots.toggleDrawing();
    break; case 'r': dots.reset();
    break; case 's': save("RandomSpherePoints.png");
  }
}