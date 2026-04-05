import processing.core.*;
import gifAnimation.*;

Player player;

void setup() {
  size(800, 600);

  player = new Player(this);
}

void draw() {
  background(50);

  player.update();
  player.display();
}


void keyPressed() {
  if (key == 'a') {
    player.moveLeft();
  }
  if (key == 'd') {
    player.moveRight();
  }
  if (key == ' ') {
    player.jump(); // we'll define this next
  }
}

void keyReleased() {
  if (key == 'a' || key == 'd') {
    player.stop();
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    player.attack();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    player.stop();
  }
}
