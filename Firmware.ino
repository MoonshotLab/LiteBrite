#include <Adafruit_NeoPixel.h>
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(3, 3, NEO_GRB + NEO_KHZ800); 


const int rMeter = A1;
const int bMeter = A0;
const int gMeter = A3;

const int xMeter = A2;
const int yMeter = A5;

const int resetButton = 4;     
const int preview = 3;

int rColor = 0;
int bColor = 0;
int gColor = 0;

int xPos   = 0;
int yPos   = 0;

String serialCom;


void setup(){
  // setup color meters
  digitalWrite(rMeter, HIGH); 
  digitalWrite(bMeter, HIGH);
  digitalWrite(gMeter, HIGH);
  // reset button
  pinMode(resetButton, INPUT);

  // neopixels
  pinMode(preview, OUTPUT);
  pixels.begin();

  // serial comm
  Serial.begin(9600);
}

void loop(){
  // derive colors from soft pots
  //Serial.println(analogRead(rMeter));
 if (analogRead(rMeter)<1000){
     rColor = map(analogRead(rMeter), 0, 1000, 255, 0); 
  }
  if(analogRead(bMeter)<1000){
    bColor = map(analogRead(bMeter), 0, 1000, 255, 0);
  }
  if(analogRead(gMeter)<1000){
    gColor = map(analogRead(gMeter), 0, 1000, 255, 0);
  } 
  if (rColor<0){
    rColor=0;
  }
  if (bColor<0){
    bColor=0;
  }
  if (gColor<0){
    gColor=0;
  }
  
  // derive coords from pots
  xPos = map(analogRead(xMeter), 0, 1023, 0, 255); //Mapping value
  yPos = map(analogRead(yMeter), 0, 1023, 0, 255); //Mapping value

  // parse serial communication
  String rString;
  String gString;
  String bString;
  String xString;
  String yString;
  String zString;

  if(rColor < 10)       { rString = "00" + String(rColor); }
  else if(rColor < 100) { rString = "0"  + String(rColor); }
  else                  { rString = String(rColor); }

  if(bColor < 10)       { bString = "00" + String(bColor); }
  else if(bColor < 100) { bString = "0"  + String(bColor); }
  else                  { bString = String(bColor); }

  if(gColor < 10)       { gString = "00" + String(gColor); }
  else if(gColor < 100) { gString = "0"  + String(gColor); }
  else                  { gString = String(gColor); }

  if(xPos < 10)         { xString = "00" + String(xPos); }
  else if(xPos < 100)   { xString = "0"  + String(xPos); }
  else                  { xString = String(xPos); }

  if(yPos < 10)         { yString = "00" + String(yPos); }
  else if(yPos < 100)   { yString = "0"  + String(yPos); }
  else                  { yString = String(yPos); }
  
  serialCom = "(" + rString + "," + gString + "," + bString + "," + xString + "," + yString + "," + digitalRead(resetButton) + ")";
  Serial.println(serialCom);

  // update the neopixels
  pixels.setPixelColor(0, pixels.Color(rColor,gColor,bColor)); // Moderately bright green color.
  pixels.setPixelColor(1, pixels.Color(rColor,gColor,bColor));
  pixels.setPixelColor(2, pixels.Color(rColor,gColor,bColor));
  pixels.show();
  
  delay(50); //just here to slow down the output for easier reading
}
