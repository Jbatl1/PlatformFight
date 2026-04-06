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

  float eWidth;
  float eHeight;
  float hitboxWidth;
  float hitboxHeight;
  float spriteOffsetX = 15;

  Enemy(PApplet sketch, Platform platform) {
    // 1. Load the images
    this.idle = Gif.getPImages(sketch, "enemyIdle.gif");
    this.attack = Gif.getPImages(sketch, "enemyAttack.gif");
  
    // 2. Safety Check
    if (this.idle == null || this.idle.length == 0) {
      println("Error: enemyIdle.gif not found!");
      return; 
    }
  
    // 3. Set sprite dimensions
    float scale = 0.1;
    this.eWidth = idle[0].width * scale;
    this.eHeight = idle[0].height * scale;

    // ✅ FIX: Initialize hitbox dimensions!
    // Adjust the 0.5 and 0.7 multipliers to fit your sprite's actual shape
    this.hitboxWidth = eWidth * 0.5;
    this.hitboxHeight = eHeight * 0.7;
  
    this.platform = platform;
    this.x = random(platform.left, platform.right);
    this.y = platform.top - (this.eHeight / 2); 
    
    this.speed = 2;
    this.movingRight = random(1) > 0.5;
    
    // Initialize animation values to avoid null/zero issues
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
    PImage[] anim = (state == 0) ? idle : attack;
  
    // Animate
    frameCounter++;
    if (frameCounter >= frameDelay) {
      frameIndex = (frameIndex + 1) % anim.length;
      frameCounter = 0;
    }
  
    sketch.pushMatrix();
  
    // Move origin to enemy center
    sketch.translate(x, y);
  
    // Flip around center if moving left
    if (!movingRight) {
      sketch.scale(-1, 1);
    }
  
    // Draw the sprite
    sketch.imageMode(CENTER);
    sketch.image(anim[frameIndex], spriteOffsetX, 0, eWidth, eHeight);
  
    // 🔴 DRAW HITBOX for debug
    sketch.noFill();
    sketch.stroke(255, 0, 0);
    sketch.rectMode(CENTER);
    sketch.rect(0, 0, hitboxWidth, hitboxHeight);
  
    sketch.popMatrix();
  }

  boolean hits(Player p) {
    // Enemy edges
    float eLeft   = x - hitboxWidth / 2;
    float eRight  = x + hitboxWidth / 2;
    float eTop    = y - hitboxHeight / 2;
    float eBottom = y + hitboxHeight / 2;
  
    // Player edges
    float pLeft   = p.x - p.pWidth / 2;
    float pRight  = p.x + p.pWidth / 2;
    float pTop    = p.y - p.pHeight / 2;
    float pBottom = p.y + p.pHeight / 2;
  
    // Return true if boxes overlap
    return !(pRight < eLeft || pLeft > eRight || pBottom < eTop || pTop > eBottom);
  }
}
