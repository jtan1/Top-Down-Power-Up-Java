// Enum for handling common colors
enum Color {
  RED,
  BLUE,
  CUBE,
  PLACED_CUBE
}

// Returns a specified color
color getColor(Color name) {
  switch(name) {
    case RED:
      return color(237, 28, 36);
    case BLUE:
      return color(1, 145, 255);
    case CUBE:
      return color(227, 251, 42);
    case PLACED_CUBE:
      return color(224, 211, 38);
    default:
      return color(0);
  }
}

float[] sinValues = new float[360];
float[] cosValues = new float[360];

// Returns whether Value is between the two bounds
boolean isBetween(float value, float bound1, float bound2) {
  return (bound1 <= value && value <= bound2) || (bound1 >= value && value >= bound2);
}

// Precalculates sin and cos values to save time later
void precalculateTrig() {
  for(int deg = 0; deg < 360; deg++) {
    sinValues[deg] = sin(deg * PI / 180);
    cosValues[deg] = cos(deg * PI / 180);
  }
}

// Returns precalculated sin value, rounding angle down to nearest int
float getSin(float angle) {
  while(angle >= 360) {
    angle -= 360;
  }
  while(angle < 0) {
    angle += 360;
  }
  
  return sinValues[(int)angle];
}

// Returns precalculated sin value, rounding angle down to nearest int
float getCos(float angle) {
  while(angle >= 360) {
    angle -= 360;
  }
  while(angle < 0) {
    angle += 360;
  }
  
  return cosValues[(int)angle];
}