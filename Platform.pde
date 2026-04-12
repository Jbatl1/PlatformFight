class Platform {
  PImage image;
  float x, y;
  float wide, tall;

  float left, right, top, bottom;

  Platform(float x, float y) {
    this.image = loadImage("Platform.png");
    this.x = x;
    this.y = y;

    float scale = 0.1;
    this.wide = image.width * scale;
    this.tall = image.height * scale;

    updateBounds();
  }

  void updateBounds() {
    float hitboxWidth = 120; 
    float hitboxHeight = 20;
    
    left = x - hitboxWidth / 2;
    right = x + hitboxWidth / 2;
    top = y - hitboxHeight / 2;
    bottom = y + hitboxHeight / 2;
  }

  void display() {
    imageMode(CENTER);
    image(image, x, y, wide, tall);
  }
}
