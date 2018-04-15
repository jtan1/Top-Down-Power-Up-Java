public class Rectangle {
  static final float kN = 1;           // Coefficient for normal force
  static final float FRICTION = 0.90;  // Speed is multiplied by this after every frame
  
  float x;
  float y;
  float w;
  float h;
  float angle;
  float speed;
  color fillColor;
  
  float normalAngle = 0;    // Temp variable used in collision detection
  float[] c = new float[8]; // Temp variable used in getLines
  
  Rectangle(color fillColor_, float x_, float y_, float w_, float h_) {
    fillColor = fillColor_;
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    angle = 0;
    speed = 0;
  }
  
  Rectangle(color fillColor_, float x_, float y_, float w_, float h_, float angle_, float speed_) {
    fillColor = fillColor_;
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    angle = angle_;
    speed = speed_;
  }
  
  float[] getCorners() {
    float sin_a = getSin(angle);
    float cos_a = getCos(angle);
    
    // Distances from robot center to corners
    float dx1 = (w/2) * cos_a - (h/2) * sin_a;
    float dy1 = (w/2) * sin_a + (h/2) * cos_a;
    float dx2 = (w/2) * cos_a + (h/2) * sin_a;
    float dy2 = (w/2) * sin_a - (h/2) * cos_a;
    
    float[] corners = {x + dx1, y + dy1, x + dx2, y + dy2, x - dx1, y - dy1, x - dx2, y - dy2};
    return corners;
  }
  
  Barrier[] getLines() {
    c = getCorners();
    Barrier[] lines = {new Barrier(c[0], c[1], c[2], c[3]),
                       new Barrier(c[2], c[3], c[4], c[5]),
                       new Barrier(c[4], c[5], c[6], c[7]),
                       new Barrier(c[6], c[7], c[0], c[1])};
    return lines;
  }
  
  boolean isColliding(Barrier barrier) {
    for(Barrier edge : getLines()) {
      if(edge.isColliding(barrier)) {
        return true;
      }
    }
    return false;
  }
  
  boolean isColliding(Rectangle rectangle) {
    for(Barrier edge : rectangle.getLines()) {
      if(isColliding(edge)) {
        return true;
      }
    }
    return false;
  }
  
  float getNormalAngle(Barrier barrier) {
    float x = this.x;
    float y = this.y;
    float x1 = barrier.x1;
    float y1 = barrier.y1;
    float x2 = barrier.x2;
    float y2 = barrier.y2;
    
    // If barrier is vertical, compare your x to the barrier's x
    if(x1 == x2) {
      if(x <= x1) {
        return 180;
      }
      return 0;
    }
    
    // If barrier is horizontal, compare your y to the barrier's y
    else if(y1 == y2) {
      if(y <= y1) {
        return 270;
      }
      return 90;
    }
    
    else {
      // Get equations of barrier lines
      float m = (y2 - y1) / (x2 - x1);
      float b = y1 - m*x1;
      
      // Y distance from point to line
      float yDist = m*x + b - y;
      
      // If y distance is positive, the point is clockwise from the line with respect to Point 1
      if(yDist >= 0) {
        return atan(m)/PI*180 - 90;
      }
      // Otherwise, point is counterclockwise from the line
      else {
        return atan(m)/PI*180 + 90;
      }
    }
  }
  
  void handleBarrierCollisions() {
    for(Barrier barrier : barriers) {
      if(isColliding(barrier)) {
        normalAngle = getNormalAngle(barrier);
        
        speed *= FRICTION;
        x += kN * getCos(normalAngle);
        y += kN * getSin(normalAngle);
      }
      while(isColliding(barrier)) {
        speed *= FRICTION;
        x += kN * getCos(normalAngle);
        y += kN * getSin(normalAngle);
      }
    }
  }
}