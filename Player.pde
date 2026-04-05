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
  float walkSpeed;
  float fallSpeed;
  float jumpHeight;
  boolean movingRight;
  boolean facingRight;
  float yVelocity;
  boolean onGround;

  // State (0 = idle, 1 = walking, 2 = jump, 3 = attack)
  int state;
  int frameIndex;
  int frameDelay;
  int frameCounter;
  int prevState;
  PApplet sketch;

  // Constructor
  Player(PApplet sketch) {
    this.sketch = sketch;
    x = 100;
    y = 100;
    pWidth = 64;
    pHeight = 64;
    walkSpeed = 3;
    fallSpeed = 5;
    jumpHeight = 10;
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
    
      if (state == 3) { // ATTACK (play once)
        if (frameIndex < currentAnimation.length - 1) {
          frameIndex++;
        } else {
          // Animation finished → return to idle or walk
          if (movingRight) {
            state = 1; // walking
          } else {
            state = 0; // idle
          }
        }
    
      } else {
        // Normal looping animations
        frameIndex = (frameIndex + 1) % currentAnimation.length;
      }
    
      frameCounter = 0;
    }

    sketch.pushMatrix();

    if (!facingRight) {
      sketch.translate(x + pWidth, y);
      sketch.scale(-1, 1);
      sketch.image(currentAnimation[frameIndex], 0, 0, pWidth, pHeight);
    } else {
      sketch.image(currentAnimation[frameIndex], x, y, pWidth, pHeight);
    }
  
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
    // Apply gravity
    y += yVelocity;
    yVelocity += fallSpeed * 0.2;
  
    onGround = false;
  
    for (Platform p : platforms) {
      // Player edges
      float playerLeft = x - pWidth/2;
      float playerRight = x + pWidth/2;
      float playerBottomPrev = y - yVelocity + pHeight/2; // previous bottom
      float playerBottom = y + pHeight/2; // current bottom
  
      boolean withinX = (playerRight > p.left && playerLeft < p.right);
      boolean falling = (yVelocity >= 0);
  
      // Collision if player was above platform and now intersecting
      if (withinX && falling && playerBottomPrev <= p.top && playerBottom >= p.top) {
        // Snap player to platform top
        y = p.top - pHeight/2;
        yVelocity = 0;
        onGround = true;
  
        // If jumping, reset to idle/walk
        if (state == 2) {
          state = movingRight ? 1 : 0;
        }
      }
    }
  
    // Movement (not during attack)
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
  
  
}
