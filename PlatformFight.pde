import processing.core.*;
import gifAnimation.*;

Player player;
PImage platformImg;
Platform[] platforms;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
int maxEnemies = 3;
PImage backgroundImage;
boolean gameStart = false;
boolean firstLaunch = true;
int score;
int time;
int maxScore;
int lastIndex; 
void setup() {
  lastIndex = -1;
  maxScore = 15;
  score = 0;
  time = 0;
  size(800, 600);
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);
  backgroundImage = loadImage("background.png");
  player = new Player(this);


  platforms = new Platform[6];

  platforms[0] = new Platform(200, 500);
  platforms[1] = new Platform(width -200, 500);
  platforms[2] = new Platform(width/2, 400);
  platforms[3] = new Platform(200, 300);
  platforms[4] = new Platform(width-200, 300);
  platforms[5] = new Platform(width/2, 200);
  
}

void draw() {
  if (gameStart) {
    image(backgroundImage, (width/2), height/2);
    
    for (Platform p : platforms) {
      p.display();
    }
  
    player.update(platforms);
    player.display();
  
    
    if (frameCount % 120 == 0) { // every ~2 seconds
      spawnEnemy();
    }
  
    
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
    
      if (e.state != 1) {
        e.move();
      }
    
      
      if (e.hits(player) && e.state != 1) {
        e.state = 1;
        e.frameIndex = 0;
      }
      e.display(this);
    
      if (e.hits(player)) {
        gameStart = player.reduceHealth();
        e.state = 1;
        e.facePlayer(player);
      }
      
      
      if (player.hitsEnemy(e)) {
        enemies.remove(i);
        score += e.points;;
      }
    }
    
    player.displayLives();
    
    if (frameCount % 60 == 0) {
      time++;
    }
    text("Score: " + score, width-100, 30);
    text("Time: " + time, 100, 30);
    if (score >= maxScore) {
      gameStart = false;
    }
  }
  else {
    image(backgroundImage, width/2, height/2);
    textSize(50);
    if(score >= maxScore) {
      text("YOU WIN", width/2, height/4);
    }
    else if (firstLaunch) {
      text("Welcome to Platform Fight", width/2, height/4);
      firstLaunch = false;
    }
    else {
      text("GAME OVER", width/2, height/4);
    }
    text("Click to play!", width/2, height/4+60);
    
    textSize(20);
    text("Prev score: " + score, width-100, 30);
    text("Prev time: " + time, 100, 30);
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
    if (gameStart == false) {
      gameStart = true;
      player = new Player(this);
      time = 0;
      score = 0;
    }
    else {
      player.attack();
    }
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    player.stop();
  }
}



void spawnEnemy() {
  if (enemies.size() >= maxEnemies) return;
  int index;
  do {
    index = (int) random(platforms.length);
  } while (index == lastIndex);
  lastIndex = index;
  Platform p = platforms[index];
  if (random(1) < 0.5) {
    enemies.add(new Enemy(this, p));
  } else {
    enemies.add(new SmallEnemy(this, p));
  }
}
