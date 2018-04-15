public class Robot extends Rectangle {
  static final float SHOOTER_POWER = 1.5; 
  static final float MAX_ACCEL = 0.60; // Pixels per frame per frame
  static final float MAX_ANGSPEED = 4; // Degrees per frame
  static final float WIDTH = 98;
  static final float HEIGHT = 83;
  
  float dV = 0; // From -1 to 1
  float dA = 0; // From -1 to 1
  
  float midX; // Temp variables for intaking and ejecting cubes
  float midY;
  float[] c = new float[8]; 
  
  boolean hasCube = true;
  boolean isIntaking = false;
  boolean raisingIntake = false;
  boolean raisingClimber = false;
  int intakeHeight = 0;
  int climberHeight = 0;
  
  Color bumperColor;
  int score = 0;
  
  Robot(Color bumperColor_, float x_, float y_, float angle_) {
    super(getColor(bumperColor_), x_, y_, WIDTH, HEIGHT, angle_, 0);
    bumperColor = bumperColor_;
  }
  
  void update() {
    moveRobot();
    handleBarrierCollisions();
    handleRobotCollisions();
    handleCubeCollisions();
    handleScalePlateCollisions();
    display();
  }
  
  void moveRobot() {
    speed += dV * MAX_ACCEL;
    speed *= FRICTION;
    angle += dA * MAX_ANGSPEED;
    
    x += speed * getCos(angle);
    y += speed * getSin(angle);
  }
  
  void handleRobotCollisions() {  
    for(Robot robot : robots) {
      if(robot != this) {
        for(Barrier edge : robot.getLines()) {
          if(isColliding(edge)) {
            normalAngle = getNormalAngle(edge);
            
            speed *= FRICTION;
            x += kN/2 * getCos(normalAngle);
            y += kN/2 * getSin(normalAngle);
            
            robot.x -= kN/2 * getCos(normalAngle);
            robot.y -= kN/2 * getSin(normalAngle);
          }
          while(isColliding(edge)) {
            speed *= FRICTION;
            x += kN/2 * getCos(normalAngle);
            y += kN/2 * getSin(normalAngle);
            
            robot.x -= kN/2 * getCos(normalAngle);
            robot.y -= kN/2 * getSin(normalAngle);
          }
        }
      }
    }
  }
  
  void handleCubeCollisions() {
    //for(Cube cube : cubes) {
    //  if(!cube.isPlaced) {
    //    for(Barrier edge : cube.getLines()) {
    //      if(isColliding(edge)) {
    //        normalAngle = getNormalAngle(edge);
            
    //        speed *= FRICTION;
    //        x += kN/2 * getCos(normalAngle);
    //        y += kN/2 * getSin(normalAngle);
            
    //        cube.x -= kN/2 * getCos(normalAngle);
    //        cube.y -= kN/2 * getSin(normalAngle);
    //      }
    //      while(isColliding(edge)) {
    //        speed *= FRICTION;
    //        x += kN/2 * getCos(normalAngle);
    //        y += kN/2 * getSin(normalAngle);
            
    //        cube.x -= kN/2 * getCos(normalAngle);
    //        cube.y -= kN/2 * getSin(normalAngle);
    //      }
    //    }
    //  }
    //}
  }
  
  void handleScalePlateCollisions() {
    
  }
  
  void display() {
    pushMatrix();
    
    fill(fillColor);
    stroke(0);
    strokeWeight(2);
    
    translate(x, y);
    rotate(angle * PI / 180);
    
    rect(-w/2, -h/2, w, h, 3);
    
    // Render robot cube
    rectMode(CENTER);
    if(hasCube) {
      fill(getColor(Color.CUBE));
    }
    else {
      fill(fillColor);
    }
    rect(20, 0, Cube.SIDE + intakeHeight / 10, Cube.SIDE + intakeHeight / 10);
    rectMode(CORNER);
    
    // Render indicator light
    // Intake: black when lowered, white when fully raised, colorless when in between
    // Climber: colorless when lowered, green when raised, yellow when in between
    switch(intakeHeight) {
      case 0:
        fill(color(0));
        break;
      case 100:
        fill(color(255));
        break;
      default:
        fill(fillColor);
        break;
    }
    switch(climberHeight) {
      case 0:
        break;
      case 100:
        fill(color(0, 255, 0));
        break;
      default:
        fill(color(255, 255, 0));
        break;
    }
    ellipse(-30, 0, 10, 10);
    
    popMatrix();
  }
  
  void findMid() {
    c = getCorners();
    midX = (c[0] + c[2]) / 2;
    midY = (c[1] + c[3]) / 2;
  }
  
  void toggleIntake() {
    findMid();
    
    if(!hasCube) {
      for(Cube cube : cubes) {
        if(((cube.x - midX)*(cube.x - midX) + (cube.y - midY)*(cube.y - midY)) < 1600) {
          hasCube = true;
          cube.x = -10000;
          break;
        }
      }
    }
    else {
      cubes.add(new Cube(1 + midX + Cube.SIDE / 2 * getCos(angle), 1 + midY + Cube.SIDE / 2 * getSin(angle), angle, SHOOTER_POWER * speed));
      hasCube = false;
    }
  }
}