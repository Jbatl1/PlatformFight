class SmallEnemy extends Enemy {

  SmallEnemy(PApplet sketch, Platform platform) {
    super(sketch, platform);
    this.eWidth *= 0.5f;
    this.eHeight *= 0.5f;
    this.hitboxWidth *= 0.5f;
    this.hitboxHeight *= 0.5f;
    this.y = platform.top - (this.eHeight / 2); 
    this.points = 2;
  }
}
