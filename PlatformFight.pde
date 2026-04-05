import processing.core.*;
import gifAnimation.*;

Player player;
Platform[] platforms;
void setup() {
  size(800, 600);
  imageMode(CENTER);

  player = new Player(this);

  platforms = new Platform[5];

  // Bottom (full-width ground substitute)
  platforms[0] = new Platform(width / 2, height - 20);

  // Left platform
  platforms[1] = new Platform(width * 0.2, height * 0.6);

  // Middle platforms
  platforms[2] = new Platform(width * 0.4, height * 0.4);
  platforms[3] = new Platform(width * 0.6, height * 0.4);

  // Right platform
  platforms[4] = new Platform(width * 0.8, height * 0.6);
}

void draw() {
  background(50);

  // Draw platforms
  for (Platform p : platforms) {
    p.display();
  }

  player.update(platforms);
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
    player.jump();
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
