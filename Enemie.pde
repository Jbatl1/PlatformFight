import gifAnimation.*;
class Enemie {
  PImage[] idle;
  PImage[] attack;
  Platform platform;
  float x;
  float y;
  float speed;
  
  Enemie(PApplet sketch, Platform platform) {
    this.idle = Gif.getPImages(sketch, "enemieIdle.gif");
    this.attack = Gif.getPImages(sketch, "enemieAttack.gif");
    this.platform = platform;
    this.x = platform.x;
    this.y = platform.top;
  }
  
  void display() {
    
  }
  
  void move() {
    
  }
}
