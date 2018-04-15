float gameY;
float scaleFactor;

PImage field;

Robot[] robots = new Robot[2];
Barrier[] barriers = new Barrier[20];
ArrayList<Cube> cubes;

// Resets things that need to be updated between each match
void resetField() {
  // Draw robots
  robots[0] = new Robot(Color.RED, 54, 488, 0);
  robots[1] = new Robot(Color.BLUE, 1867, 467, 180);
  
  // Draw cubes
  cubes = new ArrayList<Cube>();
  float[][] cubeCoords = {{599, 685}, {599, 603}, {599, 519}, {599, 436}, {599, 352}, {599, 269},
                          {1320, 685}, {1320, 603}, {1320, 519}, {1320, 436}, {1320, 352}, {1320, 260},
                          {394, 433}, {394, 476}, {394, 520}, {354, 455}, {354, 498}, {314, 476}, {394, 455}, {394, 498}, {354, 476}, {394, 476},
                          {1525, 433}, {1525, 477}, {1525, 520}, {1565, 455}, {1565, 498}, {1605, 477}, {1525, 455}, {1525, 498}, {1565, 477}, {1525, 477}};
  for(float[] coordSet : cubeCoords) {
    cubes.add(new Cube(coordSet[0], coordSet[1]));
  }
}

void setup() {
  fullScreen();
  
  // Used to fit game on screen
  gameY = min(displayHeight, displayWidth * 9/16);
  scaleFactor = displayWidth / 1920;
  
  field = loadImage("/assets/field.png");
  
  precalculateTrig();
  
  // Draw barriers
  float[][] barrierCoords = {{0, 0, 1920, 0}, {1920, 0, 1920, 953}, {1920, 953, 0, 953}, {0, 953, 0, 0},                      // Field walls
                             {0, 86, 104, 0}, {1816, 0, 1920, 86}, {0, 867, 105, 953}, {1816, 953, 1920, 867},                // Portal walls
                             {416, 251, 577, 251}, {577, 251, 577, 702}, {577, 702, 416, 702}, {416, 702, 416, 251},          // Red switch
                             {1341, 251, 1502, 251}, {1502, 251, 1502, 702}, {1502, 702, 1341, 702}, {1341, 702, 1341, 251},  // Blue switch
                             {936, 311, 985, 311}, {985, 311, 985, 642}, {985, 642, 936, 642}, {936, 642, 936, 311}};         // Scale
  for(int i = 0; i < 20; i++) {
    barriers[i] = new Barrier(barrierCoords[i][0], barrierCoords[i][1], barrierCoords[i][2], barrierCoords[i][3]);
  }

  resetField();
}

void draw() {
  // Fits everything on screen
  translate(0, (int)((displayHeight - gameY) / 2));
  scale(scaleFactor);

  image(field, 0, 0);
  
  for(Cube cube : cubes) {
    cube.update();
  }
  
  robots[0].update();
  robots[1].update();
}

void keyPressed() {
  switch(key) {
    case 'w':
      robots[0].dV = 1;
      break;
    case 's':
      robots[0].dV = -1;
      break;
    case 'a':
      robots[0].dA = -1;
      break;
    case 'd':
      robots[0].dA = 1;
      break;
    case 'q':
      robots[0].toggleIntake();
      break;
    case 'i':
      robots[1].dV = 1;
      break;
    case 'k':
      robots[1].dV = -1;
      break;
    case 'j':
      robots[1].dA = -1;
      break;
    case 'l':
      robots[1].dA = 1;
      break;
    case 'u':
      robots[1].toggleIntake();
      break;
    default:
      break;
  }
}

void keyReleased() {
  switch(key) {
    case 'w':
    case 's':
      robots[0].dV = 0;
      break;
    case 'a':
    case 'd':
      robots[0].dA = 0;
      break;
    case 'q':
      robots[0].isIntaking = false;
    case 'i':
    case 'k':
      robots[1].dV = 0;
      break;
    case 'j':
    case 'l':
      robots[1].dA = 0;
      break;
    case 'u':
      robots[1].isIntaking = false;
      break;
    default:
      break;
  }
}