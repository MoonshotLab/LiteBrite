import processing.serial.*;

OPC opc;
Serial myPort;
String serialValue;
float Spacing;

void setup(){
  // setup gui
  background(0);
  size(500, 500);
  noStroke();
  
  // Connect to the local instance of fcserver
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map an 20x20 grid of LEDs to the center of the window
  Spacing = (width-20)/21;

//  rect(0, 0, Spacing, Spacing);  
//  rect(Spacing*2, 0, Spacing, Spacing);
//  rect(Spacing*4, 0, Spacing, Spacing);
//  rect(width-Spacing, 0, Spacing, Spacing);
//  fill(255, 0, 0);
//  rect(width/2, 0, Spacing, Spacing); 
//  rect(width/2+Spacing/2, Spacing*2, Spacing, Spacing);
  
  opc.ledGrid(0,   20, 3, width/2, Spacing*2, Spacing, Spacing, 0, false);
  opc.ledGrid(64 , 20, 3, width/2, Spacing*5, Spacing, Spacing, 0, false);
  opc.ledGrid(128, 20, 3, width/2, Spacing*8, Spacing, Spacing, 0, false);
  opc.ledGrid(192, 20, 3, width/2, Spacing*11, Spacing, Spacing, 0, false);
  opc.ledGrid(256, 20, 3, width/2, Spacing*14, Spacing, Spacing, 0, false);
  opc.ledGrid(320, 20, 3, width/2, Spacing*17, Spacing, Spacing, 0, false);
  opc.ledGrid(384, 20, 2, width/2, Spacing*19.5, Spacing, Spacing, 0, false);
  
  opc.showLocations(false);
}

void draw(){
  if ( myPort.available() >0){
    serialValue = myPort.readStringUntil('\n');

    if (serialValue != null && serialValue.length() == 25){
     String xPosition = serialValue.substring(13, 16); 
     String yPosition = serialValue.substring(17, 20);
     String rColor = serialValue.substring(1, 4);
     String gColor = serialValue.substring(5, 8);
     String bColor = serialValue.substring(9, 12);
     String resetButton = serialValue.substring(21, 22);
     
     float x = map(float(xPosition), 255, 0, 0, 640);
     float y = map(float(yPosition), 0, 255, 0, 480);

     fill(int(rColor), int(gColor), int(bColor));
    
     if(x > width - Spacing*2){
       x = width - Spacing*2;
     } else if(x < Spacing + 2){
       x = Spacing + 2;
     }
     
     if(y > height - Spacing*3){
        y = height - Spacing*3;
     } else if(y < Spacing/2){
       y = Spacing/2;
     }
     
     rect(x, y, Spacing-3, Spacing-3);

     if (int(resetButton) == 1){
      background(0);
     }
    }
  }
}
