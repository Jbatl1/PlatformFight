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
  
  void update() {
    if (movingRight) {
      if (facingRight) {
        x += walkSpeed;
      } else {
        x -= walkSpeed;
      }
      
      y += yVelocity;
      yVelocity += fallSpeed * 0.2;
      
      // Simple ground (for now)
      if (y >= 400) { // ground level
        y = 400;
        yVelocity = 0;
        onGround = true;
      
        // Return to idle/walk after jump
        if (state == 2) {
          state = movingRight ? 1 : 0;
        }
      }
    }

    if (state != 2 && state != 3) {
      if (movingRight) {
        state = 1; // walking
      } else {
        state = 0; // idle
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
