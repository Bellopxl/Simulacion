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
float         SIM_STEP = 0.01;   // Simulation time-step (s)
IntegratorType integrator = IntegratorType.EXPLICIT_EULER;   // ODE integration method

// Display values:
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 600;   // Display height (pixels)

// Draw values:
final int [] BACKGROUND_COLOR = {200, 200, 255};
final int [] REFERENCE_COLOR = {0, 255, 0};
final int [] OBJECTS_COLOR = {255, 0, 0};

final float OBJECTS_SIZE = 1.0;   // Size of the objects (m)
final float PIXELS_PER_METER = 20.0;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)


// Parameters of the problem:
final float M = 10.0;   // Particle mass (kg)
final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))
final float   K = 0.2; // Constante de rozamiento

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
final PVector S0 = new PVector(-10.0, -10.0);   // Particle's start position (m)

float _simTime = 0.0;

PVector s_a = new PVector();
PVector _v0 = new PVector();

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
  
  _s = S0.copy();
  _v.set(8.0, 20.0, 0.0);
  _a.set(0.0, 0.0, 0.0);
  
  s_a = S0.copy();
  _v0.set(8.0, 20.0, 0.0);
}

void updateSimulation(){
  switch (integrator){
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
  
  // Solucion analitica la posicion: doble integracion 
  // s_a.x = S0.x + (M*_v0.x/K)*(1-exp((-K/M)*_simTime));
  // s_a.y = S0.y + (M/K)*((M*Gc/K) + _v0.y)*(1-exp((-K/M)*_simTime)) - (M*Gc*_simTime)/K;
  s_a.x = S0.x + (M*_v0.x/K)*(1-exp((-K/M)*_simTime));
  s_a.y = S0.y + (M/K)*((M*Gc/K) + _v0.y)*(1-exp((-K/M)*_simTime)) - (M*Gc*_simTime)/K;
  println("Error: ", _simTime, PVector.sub(_s, s_a).mag());
  if(_simTime > 4)
    exit();
}

void updateSimulationExplicitEuler(){
  // s(t+h) = s(t) + h*v(t)
  // v(t+h) = v(t) + h*a(s(t),v(t))
  
  _a = calculateAcceleration(_s, _v);
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(_a, SIM_STEP));
  
}

void updateSimulationSimplecticEuler(){
  // v(t+h) = v(t) + h*a(s(t),v(t))
  // s(t+h) = s(t) + h*v(t+h) 
  
  _a = calculateAcceleration(_s, _v);
  _v.add(PVector.mult(_a, SIM_STEP));
  _s.add(PVector.mult(_v, SIM_STEP));
}

void updateSimulationHeun(){

  // Integración numérica de la velocidad
    // Calcular aceleracion _a (s_i, v_i)
    // Paso de Euler -> actualizo s2, v2 
    
  _a = calculateAcceleration(_s, _v);
  PVector _s2 = PVector.add(_s, PVector.mult(_v, SIM_STEP));    
  PVector _v2 = PVector.add(_v, PVector.mult(_a, SIM_STEP));
    
    // v_promedio = (_v + v2)/2
    // actualizar _s con la pendiente de v_promedio
 
  PVector v_promedio =  PVector.add(_v, _v2);    
  _s.add(PVector.mult(v_promedio, SIM_STEP*0.5));
 
 // Integrar la aceleracíon
   // Calcular la aceleración al final del intervalo
   // a2 = a(s2,v2)
   // Promedio de aceleleraciones --> (_a, a2)
   // Actualizar la velocidad, _v,  con la aceleración promediada
   
 PVector _a2 = calculateAcceleration(_s2, _v2);
 PVector a_promedio = PVector.add(_a, _a2);
 _v.add(PVector.mult(a_promedio, SIM_STEP*0.5));
}

void updateSimulationRK2(){
  
  // Metodo original:
  // k1v = a(s(t),v(t))*h
  // k1s = v(t)*h

  // k2v = a(s(t)+k1s/2, v(t)+k1v/2)*h
  // k2s = (v(t)+k1v/2)*h
  
  //_v.add(k2v);
  //_s.add(k2s);
  
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
  
  // Metodo equivalente:
  // inicio(a,s,v)
  // calular s_mitad, v_mitad a partir de v, a (h/2)
  // calcular a_mitad(s_mitad, v_mitad)
  // actualizar s (s_fin), v (v_fin) a partir de a_mitad, v_mitad (h) 
}

void updateSimulationRK4(){
  // k1v = a(s(t),v(t))*h
  // k1s = v(t)*h

  // k2v = a(s(t)+k1s/2, v(t)+k1v/2)*h
  // k2s = (v(t)+k1v/2)*h

  // k3v = a(s(t)+k2s/2, v(t)+k2v/2)*h
  // k3s = (v(t)+k2v/2)*h

  // k4v = a(s(t)+k3s, v(t)+k3v)*h
  // k4s = (v(t)+k3v)*h

  // v(t+h) = v(t) + (1/6)*k1v + (1/3)*k2v + (1/3)*k3v +(1/6)*k4v  
  // s(t+h) = s(t) + (1/6)*k1s + (1/3)*k2s + (1/3)*k3s +(1/6)*k4s  
  
  /*
   _v.add(PVector.mult(k1v, 1/6.0));
  _v.add(PVector.mult(k2v, 1/3.0));
  _v.add(PVector.mult(k3v, 1/3.0));
  _v.add(PVector.mult(k4v, 1/6.0));
  
  _s.add(PVector.mult(k1s, 1/6.0));
  _s.add(PVector.mult(k2s, 1/3.0));
  _s.add(PVector.mult(k3s, 1/3.0));
  _s.add(PVector.mult(k4s, 1/6.0));
 */
 
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

PVector calculateAcceleration(PVector s, PVector v){
  PVector Froz   = PVector.mult(v,-K);
  PVector Fpeso  = PVector.mult(G, M); 

  PVector f = PVector.add(Fpeso, Froz);
  //f.add(...);
  
  PVector a = PVector.div(f, M);
  return a;
}

//-------------------------------------------------------
void draw(){
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  
  updateSimulation();

  drawScene();
}

void drawScene(){
  fill(OBJECTS_COLOR[0], OBJECTS_COLOR[1], OBJECTS_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);
  circle(screenPos.x, screenPos.y, worldToPixels(OBJECTS_SIZE));
  
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
