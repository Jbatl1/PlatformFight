import processing.core.*;
import gifAnimation.*;

Player player;
PImage platformImg;
Platform[] platforms;
ArrayList<Enemy> Enemys = new ArrayList<Enemy>();
int maxEnemys = 3;

void setup() {
  size(800, 600);
  imageMode(CENTER);
  rectMode(CENTER);
  player = new Player(this);

  // Bottom (full-width ground substitute)
  platformImg = loadImage("Platform.png");

  platforms = new Platform[5];

  platforms[0] = new Platform(platformImg, width / 2, height - 20);
  platforms[1] = new Platform(platformImg, width * 0.2, height * 0.6);
  platforms[2] = new Platform(platformImg, width * 0.4, height * 0.4);
  platforms[3] = new Platform(platformImg, width * 0.6, height * 0.4);
  platforms[4] = new Platform(platformImg, width * 0.8, height * 0.6);
}

void draw() {
  background(50);

  // Draw platforms
  for (Platform p : platforms) {
    p.display();
  }

  player.update(platforms);
  player.display();

  // Spawn occasionally
  if (frameCount % 120 == 0) { // every ~2 seconds
    spawnEnemy();
  }

  // Update Enemys
  for (Enemy e : Enemys) {
    e.move();
    e.display(this);

    if (e.hits(player)) {
      println("Player hit!");
      // later: reduce health
    }
  }
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

void spawnEnemy() {
  if (Enemys.size() >= maxEnemys) return;

  int index = int(random(platforms.length));
  Platform p = platforms[index];

  Enemys.add(new Enemy(this, p));
}
