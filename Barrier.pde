public class Barrier {
  float x1;
  float y1;
  float x2;
  float y2;
  
  Barrier(float x1_, float y1_, float x2_, float y2_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }
  
  boolean isColliding(Barrier barrier) {
    float x1 = this.x1;
    float y1 = this.y1;
    float x2 = this.x2;
    float y2 = this.y2;
    float x3 = barrier.x1;
    float y3 = barrier.y1;
    float x4 = barrier.x2;
    float y4 = barrier.y2;
    
    // Avoid division by 0
    if(x1 == x2) {
      x2 += 0.001;
    }
    else if(x3 == x4) {
      x4 += 0.001;
    }
    
    // Get equations of lines (y = mx + b)
    float m1 = (y2 - y1) / (x2 - x1);
    float b1 = y1 - m1*x1;
    float m3 = (y4 - y3) / (x4 - x3);
    float b3 = y3 - m3*x3;
    
    // If lines are parallel, return if they have the same y-intercept
    if(m1 == m3) {
      return b1 == b3;
    }
    
    // Find intersection point
    float xInt = (b3 - b1) / (m1 - m3);
    float yInt = m1*xInt + b1;
    
    // Returns true if intersection point is on both lines
    return isBetween(xInt, x1, x2) && isBetween(yInt, y1, y2) &&
           isBetween(xInt, x3, x4) && isBetween(yInt, y3, y4);
  }
}