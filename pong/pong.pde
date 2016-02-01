/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/8043*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Thee good olde Pong OOP'ed (almost)

  built on memories!
  
 
  keyboard interactivity
  
  e : player 1 up
  d : player 1 down
  c : player 1 release ball
  
  up : player 2 up
  down : player 2 down
  left : player 2 release ball
  
  p : switch player 2 : computer / human
  r : reset game
  + : computer level ++
  - : computer level --
  
  // //// 6 juin 2009 //// / ~emoc // // /// /
  
  TODO : 
  * needs improvement on racket hit test...
    (more vicious bounces on racket corners)
  * some "easter eggs" bounces bugs too!
*/


import processing.serial.*;

OPC opc;
Serial myPort;


PFont scoreFont;
Ground ground;
Player player1;
Player player2;
Ball ball;
Message message;
boolean start = true;

void setup() {
  // setup the stage
  size(500, 500);
  background(0);
  
  // Connect to the local instance of fcserver
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  opc = new OPC(this, "127.0.0.1", 7890);
  
  // Setup the OPC grid
  float spacing = (width-20)/21;
  opc.ledGrid(0,   20, 3, width/2, spacing*2,    spacing, spacing, 0, false);
  opc.ledGrid(64 , 20, 3, width/2, spacing*5,    spacing, spacing, 0, false);
  opc.ledGrid(128, 20, 3, width/2, spacing*8,    spacing, spacing, 0, false);
  opc.ledGrid(192, 20, 3, width/2, spacing*11,   spacing, spacing, 0, false);
  opc.ledGrid(256, 20, 3, width/2, spacing*14,   spacing, spacing, 0, false);
  opc.ledGrid(320, 20, 3, width/2, spacing*17,   spacing, spacing, 0, false);
  opc.ledGrid(384, 20, 2, width/2, spacing*19.5, spacing, spacing, 0, false);
  
  ground      = new Ground();
  player1     = new Player(1, spacing+10, height/2, false, spacing);
  player2     = new Player(2, width - spacing*2, height/2, true, spacing);
  ball        = new Ball(0,0, spacing);
  message     = new Message();

  ball.setPos(player1.posX + player1.size/9 + ball.size/2, player1.posY);
  
  scoreFont = createFont("Arial", 40);
  textFont(scoreFont);
  ellipseMode(CENTER);
  frameRate(50);
}

void draw() {
  background(0);
  stroke(255); fill(255);
  ground.draw();
  player1.draw();
  player2.draw();
  ball.draw();
  message.draw();
  if (start) {
    player1.movY = 4;
    ball.stickRelease(1);
    start = false;
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetGame();
  }
  if (key == 'p' || key == 'P') {
    player2.switchComputerDriven();
  }
  if (key == 'e' || key == 'E') {
    player1.up();
  }
  if (key == 'd' || key == 'D') {
    player1.down();
  }  
  if (key == 'c' || key == 'C') {
    player1.releaseBall(); 
  }
  if (key == '+') {
    player2.setDifficulty(1);
    message.set("computer level " + (int)player2.getDifficulty());
  }
  if (key == '-') {
    player2.setDifficulty(-1);
    message.set("computer level " + (int)player2.getDifficulty());
  }
  if (key == CODED) {
    if (keyCode == UP) {
      player2.up();
    }
    if (keyCode == DOWN) {
      player2.down();
    }
    if (keyCode == LEFT) {
      player2.releaseBall();
    }
  }
}

void resetGame() {
  player1.setPos(20, height/2);
  player2.setPos(width - 20, height/2);
  player1.resetScore();
  player2.resetScore();
  ball.setSticky(1);
  player1.movY = 4;
  ball.stickRelease(1);
  message.set("new game");
}
















