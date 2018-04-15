public class Cube extends Rectangle {
  static final float SIDE = 39;
  
  boolean isPlaced = false;
  
  Cube(float x_, float y_) {
    super(getColor(Color.CUBE), x_, y_, SIDE, SIDE);
    angle = 0;
    speed = 0;
  }
  
  Cube(float x_, float y_, float angle_, float speed_) {
    super(getColor(Color.CUBE), x_, y_, SIDE, SIDE);
    angle = angle_;
    speed = speed_;
  }
  
  void update() {
    moveCube();
    handleBarrierCollisions();
    display();
  }
    
  void display() {
    pushMatrix();
    
    fill(fillColor);
    stroke(0);
    strokeWeight(2);
    
    translate(x, y);
    rotate(angle * PI / 180);
    
    rect(-w/2, -h/2, w, h, 3);
    
    popMatrix();
  }
  
  void moveCube() {
    speed *= FRICTION;
    x += speed * getCos(angle);
    y += speed * getSin(angle);
  }
}