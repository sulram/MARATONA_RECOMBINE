

/* 

- Project by Antoine Puel (http:/antoine.cool)  
- Based on the SimpleOpenNi and oscP5 libraries
- Big thanks to Greg Borenstein and his book Making Things See
- & to Rebecca Fiebrink for Wekinator and Wekinator's examples.
- Credits for the font : Alte DIN 1451 by Peter Wiegel 
- modified for MARATONA MAKER RIO2C 2018

*/

import oscP5.*;
import netP5.*;
import SimpleOpenNI.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

SkeletonKinect  kinect;

boolean visibleUser;
float textPosition;

// * Array of color (put as many color as you want)
color[] userColor = new color[]{ color(255, 0, 0),
                                 color(109, 57, 255),
                                 color(0,255,0),
                                 color(0,0,255)
                                }; 
 
// * Start at the 0 value 
int randomColor = 0;
PFont f;

// * Enable FullScreen 
boolean sketchFullScreen() {
  return false;
}

void setup() {

  f = loadFont("AlteDIN1451.vlw");
  textFont(f);

  size(1280, 720, P3D);

  kinect = new SkeletonKinect(this);
// * kinect.setMirror MUST BE BEFORE enableDepth and enableUser functions!!!
  kinect.setMirror(true);
  kinect.enableDepth();
// * Turn on user tracking
  kinect.enableUser();

// * Choose the x position you want to display the debbuging informations
  textPosition = width/1.5;
  
  oscP5 = new OscP5(this,8001);
  myRemoteLocation = new NetAddress("127.0.0.1",8000);
  
  smooth();

}

void draw() { 

  kinect.update();
  background(0);

// * Put detected users in an IntVector
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
                                   
// * Search for an user and give him a UserId
  for (int i=0; i < userList.size(); i++) {
    int userId = userList.get(i);

// * For every user, draw the skeleton
    if ( kinect.isTrackingSkeleton(userId)) {
      stroke(userColor[ randomColor ] );
      kinect.drawSkeleton(userId);
// * Set to false to turn off success tracking message      
      displaySuccess(true);
      
      //drawLimbs(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
      
      if(i==0){
        
        PVector head = new PVector();
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
    
        OscMessage myMessage = new OscMessage("/xyz");
        myMessage.add(head.x);
        myMessage.add(head.y);
        myMessage.add(head.z);
        oscP5.send(myMessage, myRemoteLocation);
      
      }
    } else {      
// * Set to false to turn off error tracking message
      displayError(true);         
// * Each time the tracking is lost, change the random color value for the next tracking   
      randomColor = (int)random(0, userColor.length); 
    }
 }
 
// * Set to false to turn off the debugging informations
 displayInfo(true);
 
}
