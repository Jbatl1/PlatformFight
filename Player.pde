import gifAnimation.*;

class Player {
  float x;
  float y;
  int pWidth;
  int pHeight;
  PImage[] idle;
  PImage[] walk;
  PImage[] jump;
  PImage[] attack;
  PImage heart;
  float walkSpeed;
  float fallSpeed;
  float jumpHeight;
  boolean movingRight;
  boolean facingRight;
  float yVelocity;
  boolean onGround;
  int lives;
  int lastHit;
  float attackWidth = 60;
  float attackHeight = 40;
  boolean isAttacking = false;
  float hitboxWidth;
  float hitboxHeight;
  float hitboxOffsetX = 0;
  float hitboxOffsetY = 0;
  

  // State (0 = idle, 1 = walking, 2 = jump, 3 = attack)
  int state;
  int frameIndex;
  int frameDelay;
  int frameCounter;
  int prevState;
  PApplet sketch;

  Player(PApplet sketch) {
    this.sketch = sketch;
    x = 100;
    y = 100;
    pWidth = 64;
    pHeight = 64;
    hitboxWidth = pWidth * 0.5f;
    hitboxHeight = pHeight * 0.7f;
    walkSpeed = 3;
    fallSpeed = 5;
    jumpHeight = 17;
    movingRight = false;
    facingRight = true;
    yVelocity = 0;
    onGround = true;
    state = 0;
    prevState = -1;
    frameIndex = 0;
    frameDelay = 5;
    frameCounter = 0;
    Gif idleGif = new Gif(sketch, "playerIdle.gif");
    Gif walkGif = new Gif(sketch, "playerWalk.gif");
    Gif jumpGif = new Gif(sketch, "playerJump.gif");
    Gif attackGif = new Gif(sketch, "playerAttack.gif");
    idle = idleGif.getPImages();
    walk = walkGif.getPImages();
    jump = jumpGif.getPImages();
    attack = attackGif.getPImages();
    this.lives = 3;
    this.heart = loadImage("Heart.png");
    this.lastHit = 0;
  }

  void display() {
    PImage[] currentAnimation;

    switch (state) {
      case 0:
        currentAnimation = idle;
        break;
      case 1:
        currentAnimation = walk;
        break;
      case 2:
        currentAnimation = jump;
        break;
      case 3:
        currentAnimation = attack;
        break;
      default:
        currentAnimation = idle;
        break;
    }

    if (state != prevState) {
      frameIndex = 0;
      frameCounter = 0;
      prevState = state;
    }

    frameCounter++;
    if (frameCounter >= frameDelay) {
    
      if (state == 3) { // ATTACK
        isAttacking = true;
        if (frameIndex < currentAnimation.length - 1) {
          frameIndex++;
          
        } else {
          isAttacking = false;
          if (movingRight) {
            state = 1; // walking
          } else {
            state = 0; // idle
          }
        }
    
      } else {
        frameIndex = (frameIndex + 1) % currentAnimation.length;
      }
    
      frameCounter = 0;
    }

    sketch.pushMatrix();

    sketch.translate(x, y);
    
    if (!facingRight) {
      sketch.scale(-1, 1);
    }
    
    sketch.image(currentAnimation[frameIndex], 0, 0, pWidth, pHeight);
    
    sketch.popMatrix();
  }
  

  void moveRight() {
    movingRight = true;
    facingRight = true;
  }

  void moveLeft() {
    movingRight = true;
    facingRight = false;
  }

  void stop() {
    movingRight = false;
  }
  
  void update(Platform[] platforms) {
    y += yVelocity;
    yVelocity += fallSpeed * 0.2;
  
    onGround = false;
  
    for (Platform p : platforms) {
      // Player edges
      float playerLeft = x + hitboxOffsetX - hitboxWidth/2;
      float playerRight = x + hitboxOffsetX + hitboxWidth/2;
      
      float playerBottomPrev = (y - yVelocity) + hitboxOffsetY + hitboxHeight/2;
      float playerBottom = y + hitboxOffsetY + hitboxHeight/2;
  
      boolean withinX = (playerRight > p.left && playerLeft < p.right);
  
      // Collision if player was above platform and now intersecting
      if (withinX && yVelocity > 0 && playerBottomPrev <= p.top && playerBottom >= p.top) {
        y = p.top - hitboxOffsetY - hitboxHeight/2;
        yVelocity = 0;
        onGround = true;
      
        if (state == 2) {
          state = movingRight ? 1 : 0;
        }
      }
    }
    
    //stop player from falling off screen
    if (y + pHeight/2 >= height) {
      y = height - pHeight/2;
      yVelocity = 0;
      onGround = true;
    
      if (state == 2) {
        state = movingRight ? 1 : 0;
      }
    }
    
    if (x + pWidth/2 >= width) {
      x = width - (pWidth/2);
    }
    
    if (x - pWidth/2 <= 0) {
      x = 0 + (pWidth/2);
    }
    
  
    if (state != 3) {
      if (movingRight) {
        if (facingRight) {
          x += walkSpeed;
        } else {
          x -= walkSpeed;
        }
      }
    }
  
    // State logic
    if (state != 2 && state != 3) {
      if (movingRight) {
        state = 1;
      } else {
        state = 0;
      }
    }
  }
  
  void jump() {
    if (onGround) {
      yVelocity = -jumpHeight;
      onGround = false;
      state = 2; // jump
    }
  }
  
  void attack() {
    state = 3;
  }
  
  void displayLives() {
    imageMode(CENTER);
    if (lives >= 1) {
      image(heart, 20, 20);
    }
    if (lives >= 2) {
      image(heart, 40, 20);
    }
    if (lives == 3) {
      image(heart, 60, 20);
    }
  }
  
  // returns false if the player is dead
  boolean reduceHealth() {
    if ((frameCount - lastHit) > 120) {
      this.lives -= 1;
      lastHit = frameCount;
      println(this.lives);
      return this.lives > 0;
      
    }
    return true;
  }
  
  boolean hitsEnemy(Enemy e) {
    if (!isAttacking) return false;
  
    // Attack hitbox
    float attackX = facingRight ? x + pWidth/2 + attackWidth/2
                                : x - pWidth/2 - attackWidth/2;
    float attackY = y;
  
    // Attack box edges
    float aLeft = attackX - attackWidth/2;
    float aRight = attackX + attackWidth/2;
    float aTop = attackY - attackHeight/2;
    float aBottom = attackY + attackHeight/2;
  
    // Enemy hitbox
    float eLeft = e.x - e.hitboxWidth/2;
    float eRight = e.x + e.hitboxWidth/2;
    float eTop = e.y - e.hitboxHeight/2;
    float eBottom = e.y + e.hitboxHeight/2;
  
    return !(aRight < eLeft || aLeft > eRight || aBottom < eTop || aTop > eBottom);
  }
  
}
