import gifAnimation.*;

class Enemy {
  PImage[] idle;
  PImage[] attack;

  Platform platform;

  float x, y;
  float speed;
  boolean movingRight;

  int frameIndex, frameCounter, frameDelay;
  int state; // 0 = idle, 1 = attack
  int points = 1;

  float eWidth;
  float eHeight;
  float hitboxWidth;
  float hitboxHeight;
  float spriteOffsetX = 15;

  Enemy(PApplet sketch, Platform platform) {
    this.idle = Gif.getPImages(sketch, "enemyIdle.gif");
    this.attack = Gif.getPImages(sketch, "enemyAttack.gif");
  
    if (this.idle == null || this.idle.length == 0) {
      println("Error: enemyIdle.gif not found!");
      return; 
    }
  
    // 3. Set sprite dimensions
    float scale = 0.1;
    this.eWidth = idle[0].width * scale;
    this.eHeight = idle[0].height * scale;

    this.hitboxWidth = eWidth * 0.5;
    this.hitboxHeight = eHeight * 0.7;
  
    this.platform = platform;
    this.x = random(platform.left, platform.right);
    this.y = platform.top - (this.eHeight / 2); 
    
    this.speed = 1;
    this.movingRight = random(1) > 0.5;
    
    this.frameIndex = 0;
    this.frameCounter = 0;
    this.frameDelay = 6; 
}

  void move() {
    if (movingRight) {
      x += speed;
      if (x + eWidth/2 >= platform.right) {
        movingRight = false;
      }
    } else {
      x -= speed;
      if (x - eWidth/2 <= platform.left) {
        movingRight = true;
      }
    }
  }

  void display(PApplet sketch) {
    PImage[] anim;
  
  
    if (state == 1) {
      anim = attack;
    } else {
      anim = idle;
    }
  
    frameCounter++;
    if (frameCounter >= frameDelay) {
  
      frameIndex++;
  
      if (state == 1) {
        if (frameIndex >= attack.length) {
          frameIndex = 0;
          state = 0;
        }
      } else {
        if (frameIndex >= idle.length) {
          frameIndex = 0;
        }
      }
  
      frameCounter = 0;
    }
  
    sketch.pushMatrix();
  
    sketch.translate(x, y);
  
    if (!movingRight) {
      sketch.scale(-1, 1);
    }
  
    sketch.imageMode(CENTER);
    sketch.image(anim[frameIndex], spriteOffsetX, 0, eWidth, eHeight);
  
    sketch.popMatrix();
  }

  boolean hits(Player p) {
    float eLeft   = x - hitboxWidth / 2;
    float eRight  = x + hitboxWidth / 2;
    float eTop    = y - hitboxHeight / 2;
    float eBottom = y + hitboxHeight / 2;
  
    float pLeft = p.x + p.hitboxOffsetX - p.hitboxWidth/2;
    float pRight = p.x + p.hitboxOffsetX + p.hitboxWidth/2;
    float pTop = p.y + p.hitboxOffsetY - p.hitboxHeight/2;
    float pBottom = p.y + p.hitboxOffsetY + p.hitboxHeight/2;
  
    return !(pRight < eLeft || pLeft > eRight || pBottom < eTop || pTop > eBottom);
  }
  
  void facePlayer(Player p) {
    if (p.x > x) {
      movingRight = true;
    } else {
      movingRight = false;
    }
  }
}
