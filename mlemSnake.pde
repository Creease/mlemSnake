import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

PVector[] body = new PVector[324];
PVector food = new PVector(150, 150);
Boolean gameEnd = false;
int snakeSize = 25;
int snakeLength = 2;
int xdirection = 0;
int ydirection = -1;
int speed = 25;

Minim minim;
AudioSample mlem;

void setup() { 
  size(500, 500);
  background(0, 0, 0);
  frameRate(15);
  smooth();
  minim = new Minim(this);
  mlem = minim.loadSample("mlem.mp3", 512);
  body[0] = new PVector(150, 300);
  body[1] = new PVector(body[0].x, body[0].y + 25);
  body[2] = new PVector(body[1].x, body[1].y - 50);
}

void draw() {
  background (#F7F5F5);  
  fill (68, 132, 178);
  rect(0,0, width, snakeSize);
  rect(0,0, snakeSize, height);
  rect(0, height - snakeSize, width, snakeSize);
  rect(width - snakeSize ,0, snakeSize, height);
  fill (243, 197, 103);
  rect(food.x, food.y, snakeSize, snakeSize);
  noStroke();
  fill (160, 208, 213);
  snakeDraw();
  snakeUpdate();
}

void restartGame() {
  noLoop();
  gameEnd = true;
  food = new PVector(150, 150);
  body = new PVector[324];
  body[0] = new PVector(150, 300);
  body[1] = new PVector(body[0].x, body[0].y + 25);
  body[2] = new PVector(body[1].x, body[1].y - 50);
  xdirection = 0;
  ydirection = -1;
  snakeLength = 2;
}


void newFood() {

  int foodx = snakeSize * floor(random(1, (width - snakeSize) / snakeSize));
  int foody = snakeSize * floor(random(1, (height - snakeSize) / snakeSize));
  for (int i = 0; i <= snakeLength; i ++) {
    if ((body[i].x == foodx) && (body[i].y == food.y)) {
      newFood();
    }
  }
  food = new PVector(foodx, foody);
}

void snakeUpdate() {

  for (int i = snakeLength; i > 0; i --) {
    body[i].y = body[i-1].y;
    body[i].x = body[i-1].x;
  }

  body[0].y += speed * ydirection;
  body[0].x += speed * xdirection;

  if (body[0].y <= 0) {
    restartGame();
  }
  if (body[0].y >= height-snakeSize) {
    restartGame();
  }
  if (body[0].x <= 0) {
    restartGame();
  }
  if (body[0].x >= width-snakeSize) {
    restartGame();
  }

  if ((body[0].x == food.x) && (body[0].y == food.y)) {
    mlem.trigger();
    newFood();
    snakeLength ++;
    body[snakeLength] = new PVector(body[snakeLength -1].x, body[snakeLength - 1].y);
  }

  for (int i = 1; i <= snakeLength; i ++) {
    if ((body[0].x == body[i].x) && (body[0].y == body[i].y)) {
      restartGame();
      break;
    }
  }
}

void snakeDraw() {

  for (int i = 0; i <= snakeLength; i++ ) {
    rect(body[i].x, body[i].y, snakeSize, snakeSize);
  }
}

void keyPressed() {

  if (key == CODED) {
    if ((keyCode == UP) && (ydirection != 1)) {
      ydirection = -1;
      xdirection = 0;
    }
    if ((keyCode == DOWN) && (ydirection != -1)) {
      ydirection = 1;
      xdirection = 0;
    }
    if ((keyCode == LEFT) && (xdirection != 1)) {
      ydirection = 0;
      xdirection = -1;
    }
    if ((keyCode == RIGHT) && (xdirection != -1)) {
      ydirection = 0;
      xdirection = 1;
    }
  }
  
  if (key == 'r') {
   if (gameEnd == true) {
     gameEnd = false;
     loop();
   }
  }
  
}

void stop() {
  
  mlem.close();
  minim.stop();
  super.stop();
  
}
