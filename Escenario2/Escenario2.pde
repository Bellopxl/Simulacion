// -----------------------------------------------
// Plantilla para la implementación de integradores 
// numéricos en Simulación. Tema 1.
// 
// Sergio Casas & Miguel Lozano (Febrero 2021)
// Autor: Lluís Bello Alventosa
// --------------------------------------------------

// Definitions:
enum IntegratorType{
  NONE,
  EXPLICIT_EULER, 
  SIMPLECTIC_EULER, 
  HEUN, 
  RK2, 
  RK4
}

// Parameters of the numerical integration:
float         SIM_STEP = 0.1;   // Simulation time-step (s)
IntegratorType integrator = IntegratorType.EXPLICIT_EULER;   // ODE integration method

// Display values:
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 600;   // Display height (pixels)

// Draw values:
final int [] BACKGROUND_COLOR = {200, 200, 255};
final int [] REFERENCE_COLOR = {0, 255, 0};
final int [] OBJECTS_COLOR1 = {255, 0, 0};
final int [] OBJECTS_COLOR2 = {255, 255, 0};
final int [] OBJECTS_COLOR3 = {0, 255, 0};
final int [] OBJECTS_COLOR4 = {0, 0, 255};

final float OBJECTS_SIZE = 1.0;   // Size of the objects (m)
final float PIXELS_PER_METER = 20.0;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)


// Parameters of the problem:
final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))

final float L0 = 50;
/* Muelle 1
   Ks = 1    ---> Cuanto menor, se produce una elongación mayor del muelle, siendo este el segundo que más elongación consigue.
   Kd = 0.3  ---> Cuanto mayor, menos tiempo está en movimiento, siendo este, junto con el 3 los segundos que más duran.
*/
final float M1 = 5.0;   // Particle mass (kg)
final float Ks1 = 1; // Constante de elasticidad del muelle
final float Kd1 = 0.3; // Constante de amortiguación
PVector _s1 = new PVector();   // Position of the particle (m)
PVector _v1 = new PVector();   // Velocity of the particle (m/s)
PVector _a1 = new PVector();   // Accleration of the particle (m/(s*s))
final PVector S0_1 = new PVector(-20.0, 0.0);   // Particle's start position (m)
final PVector C1 = new PVector(-20.0, 5.0);

/* Muelle 2
   Ks = 1.1  ---> Cuanto menor, se produce una elongación mayor del muelle, siendo este el segundo que menos elongación consigue.
   Kd = 0.4  ---> Cuanto mayor, menos tiempo está en movimiento, siendo este el que menos dura.
*/
final float M2 = 5.0;   // Particle mass (kg)
final float Ks2 = 1.1; // Constante de elasticidad del muelle
final float Kd2 = 0.4; // Constante de amortiguación
PVector _s2 = new PVector();   // Position of the particle (m)
PVector _v2 = new PVector();   // Velocity of the particle (m/s)
PVector _a2 = new PVector();   // Accleration of the particle (m/(s*s))
final PVector S0_2 = new PVector(-10.0, 0.0);   // Particle's start position (m)
final PVector C2 = new PVector(-10.0, 5.0);

/* Muelle 3
   Ks = 1.15 ---> Cuanto menor, se produce una elongación mayor del muelle, siendo este el que menos elongación consigue.
   Kd = 0.3  ---> Cuanto mayor, menos tiempo está en movimiento, siendo este, junto con el 1 los segundos que más duran.
*/
final float M3 = 5.0;   // Particle mass (kg)
final float Ks3 = 1.15; // Constante de elasticidad del muelle
final float Kd3 = 0.3; // Constante de amortiguación
PVector _s3 = new PVector();   // Position of the particle (m)
PVector _v3 = new PVector();   // Velocity of the particle (m/s)
PVector _a3 = new PVector();   // Accleration of the particle (m/(s*s))
final PVector S0_3 = new PVector(10.0, 0.0);   // Particle's start position (m)
final PVector C3 = new PVector(10.0, 5.0);

/* Muelle 3
   Ks = 0.9  ---> Cuanto menor, se produce una elongación mayor del muelle, siendo este el que más elongación consigue.
   Kd = 0.1  ---> Cuanto mayor, menos tiempo está en movimiento, siendo este el que más dura.
*/
final float M4 = 5.0;   // Particle mass (kg)
final float Ks4 = 0.9; // Constante de elasticidad del muelle
final float Kd4 = 0.1; // Constante de amortiguación
PVector _s4 = new PVector();   // Position of the particle (m)
PVector _v4 = new PVector();   // Velocity of the particle (m/s)
PVector _a4 = new PVector();   // Accleration of the particle (m/(s*s))
final PVector S0_4 = new PVector(20.0, 0.0);   // Particle's start position (m)
final PVector C4 = new PVector(20.0, 5.0);

float _simTime = 0.0;

//------------------------------------------------------
// Inicialización

void settings(){
  if (FULL_SCREEN){
    fullScreen();
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup(){
  frameRate(DRAW_FREQ); 
  initSimulation();
}

//-------------------------------------------------------
// Simulation

void initSimulation(){
  _simTime = 0.0;
  
  _s1 = S0_1.copy();
  _v1.set(0.0, 5.0, 0.0);
  _a1.set(0.0, 0.0, 0.0);
  
  _s2 = S0_2.copy();
  _v2.set(0.0, 0.0, 0.0);
  _a2.set(0.0, 0.0, 0.0);
  
  _s3 = S0_3.copy();
  _v3.set(0.0, 0.0, 0.0);
  _a3.set(0.0, 0.0, 0.0);
  
  _s4 = S0_4.copy();
  _v4.set(0.0, 0.0, 0.0);
  _a4.set(0.0, 0.0, 0.0);
}

void updateSimulation(PVector _s, PVector _v, float Ks, float Kd, float M, PVector C, PVector _a){
  switch (integrator){
  case EXPLICIT_EULER:
    updateSimulationExplicitEuler(_s, _v, Ks, Kd, M, C, _a);
    break;

  case SIMPLECTIC_EULER:
    updateSimulationSimplecticEuler(_s, _v, Ks, Kd, M, C, _a);
    break;

  case HEUN:
    updateSimulationHeun(_s, _v, Ks, Kd, M, C, _a);
    break;

  case RK2:
    updateSimulationRK2(_s, _v, Ks, Kd, M, C, _a);
    break;

  case RK4:
    updateSimulationRK4(_s, _v, Ks, Kd, M, C, _a);
    break;
  }
  
  _simTime += SIM_STEP;
  
  // Solucion analitica la posicion: doble integracion 
  // s_a.x = S0.x + (M*_v0.x/K)*(1-exp((-K/M)*_simTime));
  // s_a.y = S0.y + (M/K)*((M*Gc/K) + _v0.y)*(1-exp((-K/M)*_simTime)) - (M*Gc*_simTime)/K;
}

void updateSimulationExplicitEuler(PVector _s, PVector _v, float Ks, float Kd, float M, PVector C, PVector _a){
  _a = calculateAcceleration(_s, _v, Ks, Kd, M, C);
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(_a, SIM_STEP));
}

void updateSimulationSimplecticEuler(PVector _s, PVector _v, float Ks, float Kd, float M, PVector C, PVector _a){
  _a = calculateAcceleration(_s, _v, Ks, Kd, M, C);
  _v.add(PVector.mult(_a, SIM_STEP));
  _s.add(PVector.mult(_v, SIM_STEP));
}

void updateSimulationHeun(PVector _s, PVector _v, float Ks, float Kd, float M, PVector C, PVector _a){
  _a = calculateAcceleration(_s, _v, Ks, Kd, M, C);
  PVector _s2 = PVector.add(_s, PVector.mult(_v, SIM_STEP));    
  PVector _v2 = PVector.add(_v, PVector.mult(_a, SIM_STEP));
  PVector v_promedio =  PVector.add(_v, _v2);    
  _s.add(PVector.mult(v_promedio, SIM_STEP*0.5));
  PVector _a2 = calculateAcceleration(_s2, _v2, Ks, Kd, M, C);
  PVector a_promedio = PVector.add(_a, _a2);
  _v.add(PVector.mult(a_promedio, SIM_STEP*0.5));
}

void updateSimulationRK2(PVector _s, PVector _v, float Ks, float Kd, float M, PVector C, PVector _a){
  _a = calculateAcceleration(_s, _v, Ks, Kd, M, C);
  PVector _k1v = PVector.mult(_a, SIM_STEP);
  PVector _k1s = PVector.mult(_v, SIM_STEP);

  PVector _v2 = PVector.add(_v, PVector.mult(_k1v, 0.5));
  PVector _s2 = PVector.add(_s, PVector.mult(_k1s, 0.5));
  PVector _a2 = calculateAcceleration(_s2, _v2, Ks, Kd, M, C);
  PVector _k2v = PVector.mult(_a2, SIM_STEP);
  PVector _k2s = PVector.mult(PVector.add(_v, PVector.mult(_k1v, 0.5)), SIM_STEP);
  
  _s.add(_k2s);    
  _v.add(_k2v);
}

void updateSimulationRK4(PVector _s, PVector _v, float Ks, float Kd, float M, PVector C, PVector _a){
  _a = calculateAcceleration(_s, _v, Ks, Kd, M, C);
  PVector _k1v = PVector.mult(_a, SIM_STEP);
  PVector _k1s = PVector.mult(_v, SIM_STEP);

  PVector _v2 = PVector.add(_v, PVector.mult(_k1v, 0.5));
  PVector _s2 = PVector.add(_s, PVector.mult(_k1s, 0.5));
  PVector _a2 = calculateAcceleration(_s2, _v2, Ks, Kd, M, C);
  
  PVector _k2v = PVector.mult(_a2, SIM_STEP);
  PVector _k2s = PVector.mult(PVector.add(_v, PVector.mult(_k1v, 0.5)), SIM_STEP);
  
  PVector _v3 = PVector.add(_v, PVector.mult(_k2v, 0.5));
  PVector _s3 = PVector.add(_s, PVector.mult(_k2s, 0.5));
  PVector _a3 = calculateAcceleration(_s3, _v3, Ks, Kd, M, C);
  
  PVector _k3v = PVector.mult(_a3, SIM_STEP);
  PVector _k3s = PVector.mult(PVector.add(_v, PVector.mult(_k2v, 0.5)), SIM_STEP);

  PVector _v4 = PVector.add(_v, _k3v);
  PVector _s4 = PVector.add(_s, _k3s);
  PVector _a4 = calculateAcceleration(_s4, _v4, Ks, Kd, M, C);
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

//-----------------------------------------------------------
// Aceleración del problema dy/dx = dv/dt, función a integrar

// Problema - Tiro parabólico

// Ecuacion Diferencial:
// s' = v(t)
// v' = a(s(t), v(t))
// siendo: 
//      a(s(t), v(t)) = [Froz(v(t)) + Fpeso ]/m
//      Froz = -k·v(t)
//      Fpeso = mg; siendo g(0, -9.8) m/s²

PVector calculateAcceleration(PVector s, PVector v, float Ks, float Kd, float M, PVector C){
  PVector Felas = new PVector(0, 0);
  PVector Froz = new PVector(0, 0);
  PVector Fpeso = new PVector(0, 0);
  PVector Ft = new PVector(0, 0);
  PVector Ff = new PVector(0, 0);
  PVector a = new PVector(0, 0);
  
  Froz   = PVector.mult(v, Kd);
  Fpeso  = PVector.mult(G, M);
  
  Felas  = PVector.mult(new PVector(Felas.x, s.y - L0), -Ks);
  
  Ft = PVector.sub(Felas, Froz);
  Ff = PVector.add(Ft, Fpeso);
  a = PVector.div(Ff, M);
  return a;
}

//-------------------------------------------------------
void draw(){
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  updateSimulation(_s1, _v1, Ks1, Kd1, M1, C1, _a1);
  updateSimulation(_s2, _v2, Ks2, Kd2, M2, C2, _a2);
  updateSimulation(_s3, _v3, Ks3, Kd3, M3, C3, _a3);
  updateSimulation(_s4, _v4, Ks4, Kd4, M4, C4, _a4);
  drawScene();
}

void drawScene(){
  strokeWeight(1);

  PVector screenPos1 = new PVector();
  PVector screenPos2 = new PVector();
  PVector screenPos3 = new PVector();
  PVector screenPos4 = new PVector();
  
  pushMatrix();
    line(0.0, 5, width, 5);
  popMatrix();
  pushMatrix();
    fill(OBJECTS_COLOR1[0], OBJECTS_COLOR1[1], OBJECTS_COLOR1[2]);
    worldToScreen(_s1, screenPos1);
    line(screenPos1.x, 5, screenPos1.x, screenPos1.y);
    circle(screenPos1.x, screenPos1.y, worldToPixels(OBJECTS_SIZE));
  popMatrix();
  pushMatrix();
    fill(OBJECTS_COLOR2[0], OBJECTS_COLOR2[1], OBJECTS_COLOR2[2]);
    worldToScreen(_s2, screenPos2);
    line(screenPos2.x, 5, screenPos2.x, screenPos2.y);
    circle(screenPos2.x, screenPos2.y, worldToPixels(OBJECTS_SIZE));
  popMatrix();
  pushMatrix();
    fill(OBJECTS_COLOR3[0], OBJECTS_COLOR3[1], OBJECTS_COLOR3[2]);
    worldToScreen(_s3, screenPos3);
    line(screenPos3.x, 5, screenPos3.x, screenPos3.y);
    circle(screenPos3.x, screenPos3.y, worldToPixels(OBJECTS_SIZE));
  popMatrix();
  pushMatrix();
    fill(OBJECTS_COLOR4[0], OBJECTS_COLOR4[1], OBJECTS_COLOR4[2]);
    worldToScreen(_s4, screenPos4);
    line(screenPos4.x, 5, screenPos4.x, screenPos4.y);
    circle(screenPos4.x, screenPos4.y, worldToPixels(OBJECTS_SIZE));
  popMatrix();
}

//-----------------------------------------------------
// World2Screen functions ...

// Converts distances from world length to pixel length
float worldToPixels(float dist){
  return dist*PIXELS_PER_METER;
}

// Converts distances from pixel length to world length
float pixelsToWorld(float dist){
  return dist/PIXELS_PER_METER;
}

// Converts a point from world coordinates to screen coordinates
void worldToScreen(PVector worldPos, PVector screenPos){
  screenPos.x = 0.5*DISPLAY_SIZE_X + (worldPos.x - DISPLAY_CENTER.x)*PIXELS_PER_METER;
  screenPos.y = 0.5*DISPLAY_SIZE_Y - (worldPos.y - DISPLAY_CENTER.y)*PIXELS_PER_METER;
}

// Converts a point from screen coordinates to world coordinates
void screenToWorld(PVector screenPos, PVector worldPos){
  worldPos.x = ((screenPos.x - 0.5*DISPLAY_SIZE_X)/PIXELS_PER_METER) + DISPLAY_CENTER.x;
  worldPos.y = ((0.5*DISPLAY_SIZE_Y - screenPos.y)/PIXELS_PER_METER) + DISPLAY_CENTER.y;
}

//-----------------------------------------------------
// Interaction

void keyPressed(){
  if (key == 'r' || key == 'R'){
    initSimulation();
  }
  if (key == '+'){
    SIM_STEP *= 1.1;
  }
  if (key == '-'){
    SIM_STEP /= 1.1;
  }
}
