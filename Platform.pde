class Platform {
  PImage image;
  int wide;
  int tall;
  float x;
  float y;
  
  Platform(float x, float y) {
    this.image = loadImage("Platform.png");
    this.wide = 529;
    this.tall = 29;
    this.x = x;
    this.y = y;
  }
  
  void render() {
    
  }
}
