class Platform {
  PImage image;
  int wide;
  int tall;
  float x;
  float y;
  float top;
  float bottom;
  float left;
  float right;
  
  Platform(float x, float y) {
    this.image = loadImage("Platform.png");
    this.wide = 529;
    this.tall = 29;
    this.x = x;
    this.y = y;
    this.top = y - (tall / 2);
    this.bottom = y + (tall / 2);
    this.left = x - (wide / 2);
    this.right = x + (wide / 2);
  }
  
  void display() {
    image(image, x, y, wide, tall);
  }
}
