// Authors:  //<>//
// Lluís Bello Alventosa
// Raúl Sanz Jodar

// Problem description:
// ...
// ...
// ...

// Differential equations:
// ...
// ...
// ...

// Definitions:

enum IntegratorType 
{
  NONE,
  EXPLICIT_EULER, 
  SIMPLECTIC_EULER, 
  HEUN, 
  RK2, 
  RK4
}

// Parameters of the numerical integration:

final boolean REAL_TIME = true;

final float SIM_STEP = 25920;   // Simulation time-step (s)
final float TIME_ACCEL = 46*24*3600;
IntegratorType integrator = IntegratorType.RK4;   // ODE integration method

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)

// Draw values:

final int [] BACKGROUND_COLOR = {0, 0, 0};
final int [] REFERENCE_COLOR = {255, 255, 0};
final int [] OBJECTS_COLOR = {255, 0, 0};
final float OBJECTS_SIZE = 2E10;   // Size of the objects (m)
final float PIXELS_PER_METER = 2E-9;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)

// Parameters of the problem:

final float Mp = 5.972E24;   // Planet mass (kg)
final float Me = 1.989E30;   // Star mass (kg)
final float Gc = 6.67430E-11;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))
final PVector _s_e = new PVector(0.0, 0.0);
final PVector _s0 = new PVector(149.6E9, 0.0);

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)

// Output control:

PrintWriter _output;
final String FILE_NAME = "data.txt";

// Auxiliary variables:

float _energy;   // Total energy of the particle (J)

// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))


// Main code:

// Converts distances from world length to pixel length
float worldToPixels(float dist)
{
  return dist*PIXELS_PER_METER;
}

// Converts distances from pixel length to world length
float pixelsToWorld(float dist)
{
  return dist/PIXELS_PER_METER;
}

// Converts a point from world coordinates to screen coordinates
void worldToScreen(PVector worldPos, PVector screenPos)
{
  screenPos.x = 0.5*DISPLAY_SIZE_X + (worldPos.x - DISPLAY_CENTER.x)*PIXELS_PER_METER;
  screenPos.y = 0.5*DISPLAY_SIZE_Y - (worldPos.y - DISPLAY_CENTER.y)*PIXELS_PER_METER;
}

// Converts a point from screen coordinates to world coordinates
void screenToWorld(PVector screenPos, PVector worldPos)
{
  worldPos.x = ((screenPos.x - 0.5*DISPLAY_SIZE_X)/PIXELS_PER_METER) + DISPLAY_CENTER.x;
  worldPos.y = ((0.5*DISPLAY_SIZE_Y - screenPos.y)/PIXELS_PER_METER) + DISPLAY_CENTER.y;
}

void drawStaticEnvironment()
{
  background(255, 255, 255);

  strokeWeight(3);
  
  PVector screenPos2 = new PVector();
  worldToScreen(_s0, screenPos2);

  PVector screenPos3 = new PVector();
  worldToScreen(_s_e, screenPos3);

  fill(REFERENCE_COLOR[0], REFERENCE_COLOR[1], REFERENCE_COLOR[2]);
  circle(screenPos3.x, screenPos3.y, 3*worldToPixels(OBJECTS_SIZE));
  
  fill(REFERENCE_COLOR[2], REFERENCE_COLOR[1], REFERENCE_COLOR[2]);
  strokeWeight(2);
  circle(screenPos2.x, screenPos2.y, worldToPixels(OBJECTS_SIZE));
}

void drawMovingElements()
{
  fill(OBJECTS_COLOR[1], OBJECTS_COLOR[1], OBJECTS_COLOR[0]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);

  circle(screenPos.x, screenPos.y, worldToPixels(OBJECTS_SIZE));
}

void PrintInfo()
{
  println("Energy: " + _energy + " J");
  println("Elapsed time = " + _elapsedTime + " s");
  println("Simulated time = " + _simTime + " s \n");
}

void initSimulation()
{
  _simTime = 0.0;
  _elapsedTime = 0.0;
  
  _s = _s0.copy();
  _v.set(0.0, 30.75E3);
  _a.set(0.0, 0.0);
}

void updateSimulation()
{
  switch (integrator)
  {
  case EXPLICIT_EULER:
    updateSimulationExplicitEuler();
    break;

  case SIMPLECTIC_EULER:
    updateSimulationSimplecticEuler();
    break;

  case HEUN:
    updateSimulationHeun();
    break;

  case RK2:
    updateSimulationRK2();
    break;

  case RK4:
    updateSimulationRK4();
    break;
  }
  
  _simTime += SIM_STEP;
}

void updateSimulationExplicitEuler()
{
  _a = calculateAcceleration(_s, _v);
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(_a, SIM_STEP));
  
}

void updateSimulationSimplecticEuler()
{
   _a = calculateAcceleration(_s, _v);
  _v.add(PVector.mult(_a, SIM_STEP));
  _s.add(PVector.mult(_v, SIM_STEP));
}

void updateSimulationHeun(){
  _a = calculateAcceleration(_s, _v);
  PVector _s2 = PVector.add(_s, PVector.mult(_v, SIM_STEP));    
  PVector _v2 = PVector.add(_v, PVector.mult(_a, SIM_STEP));
     
  PVector v_promedio =  PVector.add(_v, _v2);    
  _s.add(PVector.mult(v_promedio, SIM_STEP*0.5));

  PVector _a2 = calculateAcceleration(_s2, _v2);
  PVector a_promedio = PVector.add(_a, _a2);
   
  _v.add(PVector.mult(a_promedio, SIM_STEP*0.5));
}

void updateSimulationRK2(){ 
  _a = calculateAcceleration(_s, _v);
  PVector _k1v = PVector.mult(_a, SIM_STEP);
  PVector _k1s = PVector.mult(_v, SIM_STEP);

  PVector _v2 = PVector.add(_v, PVector.mult(_k1v, 0.5));
  PVector _s2 = PVector.add(_s, PVector.mult(_k1s, 0.5));
  PVector _a2 = calculateAcceleration(_s2, _v2);
  PVector _k2v = PVector.mult(_a2, SIM_STEP);
  PVector _k2s = PVector.mult(PVector.add(_v, PVector.mult(_k1v, 0.5)), SIM_STEP);
  
  _s.add(_k2s);    
  _v.add(_k2v);
}

void updateSimulationRK4()
{
  _a = calculateAcceleration(_s, _v);
  PVector _k1v = PVector.mult(_a, SIM_STEP);
  PVector _k1s = PVector.mult(_v, SIM_STEP);

  PVector _v2 = PVector.add(_v, PVector.mult(_k1v, 0.5));
  PVector _s2 = PVector.add(_s, PVector.mult(_k1s, 0.5));
  PVector _a2 = calculateAcceleration(_s2, _v2);
  
  PVector _k2v = PVector.mult(_a2, SIM_STEP);
  PVector _k2s = PVector.mult(PVector.add(_v, PVector.mult(_k1v, 0.5)), SIM_STEP);
  
  PVector _v3 = PVector.add(_v, PVector.mult(_k2v, 0.5));
  PVector _s3 = PVector.add(_s, PVector.mult(_k2s, 0.5));
  PVector _a3 = calculateAcceleration(_s3, _v3);
  
  PVector _k3v = PVector.mult(_a3, SIM_STEP);
  PVector _k3s = PVector.mult(PVector.add(_v, PVector.mult(_k2v, 0.5)), SIM_STEP);

  PVector _v4 = PVector.add(_v, _k3v);
  PVector _s4 = PVector.add(_s, _k3s);
  PVector _a4 = calculateAcceleration(_s4, _v4);
  PVector _k4v = PVector.mult(_a4, SIM_STEP);
  PVector _k4s = PVector.mult(PVector.add(_v, _k3v), SIM_STEP);
    
  _v.add(PVector.mult(_k1v, 1/6.0));
  _v.add(PVector.mult(_k2v, 1/3.0));
  _v.add(PVector.mult(_k3v, 1/3.0));
  _v.add(PVector.mult(_k4v, 1/6.0));
  
  _s.add(PVector.mult(_k1s, 1/6.0));
  _s.add(PVector.mult(_k2s, 1/3.0));
  _s.add(PVector.mult(_k3s, 1/3.0));
  _s.add(PVector.mult(_k4s, 1/6.0));
}

PVector calculateAcceleration(PVector s, PVector v)
{
  PVector radio = PVector.sub(s, _s_e);
  float radioMag = radio.mag();
  float radio2 = radioMag * radioMag;
  float GMe = -Gc * Me;
  float div = GMe / radio2;
  PVector radioNorm = radio.normalize();
  PVector Fgrav = PVector.mult(radioNorm, div);
  PVector a = Fgrav;
  return a;
}

void calculateEnergy()
{  
  float vMag = _v.mag();
  float v2 = vMag * vMag;
  float MpMedios = Mp / 2;
  float Ecin = v2 * MpMedios;
  
  float GMe = -Gc * Me;
  float radio = _s.mag();
  float div = GMe / radio;
  float Epot = div * Mp;
  
  _energy = Ecin + Epot;
}

void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen();
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  initSimulation();
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");

  if (REAL_TIME)
  {
    float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
    float expectedIterations = expectedSimulatedTime/SIM_STEP;
    int iterations = 0; 

    for (; iterations < floor(expectedIterations); iterations++)
      updateSimulation();

    if ((expectedIterations - iterations) > random(0.0, 1.0))
    {
      updateSimulation();
      iterations++;
    }

    //println("Expected Simulated Time: " + expectedSimulatedTime);
    //println("Expected Iterations: " + expectedIterations);
    //println("Iterations: " + iterations);
  } 
  else
    updateSimulation();

  drawStaticEnvironment();
  drawMovingElements();

  calculateEnergy();
  PrintInfo();
}

void mouseClicked() 
{
  _s = new PVector(mouseX, mouseY);
  screenToWorld(_s, _s);
  _a = new PVector(0.0, 0.0);
}

void keyPressed()
{
  if (key == 'i' || key == 'I'){
    initSimulation();
  }  
  if (key == 's' || key == 'S'){
    integrator = IntegratorType.SIMPLECTIC_EULER;
  } 
  if (key == 'e' || key == 'E'){
    integrator = IntegratorType.EXPLICIT_EULER;
  }
  if (key == 'h' || key == 'H'){
    integrator = IntegratorType.HEUN;
  }
  if (key == 'k' || key == 'K'){
    integrator = IntegratorType.RK2;
  }
  if (key == 'r' || key == 'R'){
    integrator = IntegratorType.RK4;
  }
}

void stop()
{
  // ...
  // ...
  // ...  
}
