// Authors: 
// Lluís Bello Alventosa

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 800;   // Display width (pixels)
int DISPLAY_SIZE_Y = 800;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {20, 16, 24};
final float PIXELS_PER_METER = 300;   // Display length that corresponds with 1 meter (pixels)
PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)
float screenAncho;
float screenLargo;

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)
final float SIM_STEP = 0.01;   // Simulation step (s)

// Particle control:

ParticleSystem _system;   // Particle system
ArrayList<PlaneSection> _planes;    // Planes representing the limits
ArrayList<Particle> _particles;
boolean _computePlaneCollisions = true;
int _typeCollision = 1; // 1: Velocidades; 2: Muelle

// Problem Parameters

final float masa = 0.22;
int numBalls = 1;
final float radBalls = 0.04;
final float Kd = 0.2;
final float vel = -3000;
final float ancho = 1.27;
final float largo = 2.54;

// Auxiliary variables

int idBall;

// Pimball control
boolean izq = false;
boolean der = false;

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
    
    DISPLAY_CENTER.x = displayWidth/2;
    DISPLAY_CENTER.y = displayHeight/2;
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  
  worldToScreen(DISPLAY_CENTER, DISPLAY_CENTER);
  
  screenAncho = worldToPixels(ancho);
  screenLargo = worldToPixels(largo);
  
  initSimulation();
}

void initSimulation()
{  
  _system = new ParticleSystem();
  _planes = new ArrayList<PlaneSection>();

    // Tablero
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/3, DISPLAY_CENTER.y - screenAncho/1.2, DISPLAY_CENTER.x - screenLargo/0.85 + screenLargo, DISPLAY_CENTER.y - screenAncho, true));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x + screenLargo/6, DISPLAY_CENTER.y - screenAncho, DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo, DISPLAY_CENTER.y - screenAncho/1.2, true));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/3.75, DISPLAY_CENTER.y - screenAncho/1.5, DISPLAY_CENTER.x - screenLargo/3.75, DISPLAY_CENTER.y - screenAncho/3.65 + screenAncho, false));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/3.75, DISPLAY_CENTER.y - screenAncho/1.5, DISPLAY_CENTER.x - screenLargo/3.75, DISPLAY_CENTER.y - screenAncho/3.65 + screenAncho, true));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x/0.8, DISPLAY_CENTER.y - screenLargo/10, DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo, DISPLAY_CENTER.y - screenLargo/4, false));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x/0.8, DISPLAY_CENTER.y - screenLargo/10, DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo, DISPLAY_CENTER.y/0.9, true));

  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/0.85 + screenLargo, DISPLAY_CENTER.y - screenAncho, DISPLAY_CENTER.x + screenLargo/6, DISPLAY_CENTER.y - screenAncho, true));
  
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/3, DISPLAY_CENTER.y - screenAncho/1.2, DISPLAY_CENTER.x - screenLargo/3, DISPLAY_CENTER.y - screenAncho/3 + screenAncho, false));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo, DISPLAY_CENTER.y - screenAncho/1.2, DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo, DISPLAY_CENTER.y - screenAncho/3 + screenAncho, true));
  
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/3, DISPLAY_CENTER.y - screenAncho/3 + screenAncho,  (DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/2.5,  (DISPLAY_CENTER.y - screenAncho/5 + screenAncho), false));
  _planes.add(new PlaneSection((DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.2,  DISPLAY_CENTER.y - screenAncho/5 + screenAncho,  DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo, DISPLAY_CENTER.y - screenAncho/3 + screenAncho, false));
  
  _planes.add(new PlaneSection((DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/2.5,  (DISPLAY_CENTER.y - screenAncho/5 + screenAncho),  (DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.75,  DISPLAY_CENTER.y - screenAncho/10 + screenAncho, false));
  _planes.add(new PlaneSection((DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.5,  DISPLAY_CENTER.y - screenAncho/10 + screenAncho,  (DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.2,  DISPLAY_CENTER.y - screenAncho/5 + screenAncho, false));
  
  _planes.add(new PlaneSection((DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/2.5,  (DISPLAY_CENTER.y - screenAncho/5 + screenAncho),  (DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.75,  DISPLAY_CENTER.y - screenAncho/3 + screenAncho, false));
  _planes.add(new PlaneSection((DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.5,  DISPLAY_CENTER.y - screenAncho/3 + screenAncho,  (DISPLAY_CENTER.x - screenLargo/1.5 + screenLargo)/1.2,  DISPLAY_CENTER.y - screenAncho/5 + screenAncho, false));
  
  // Bolas
  float radio = worldToPixels(radBalls);
  _particles = _system.getParticleArray();
  PVector pos = new PVector(DISPLAY_CENTER.x - screenLargo/3.3, DISPLAY_CENTER.y - screenAncho/2.8 + screenAncho);
    /*if(_system.getNumParticles() > 0){
      for(int j = 0; j < _particles.size(); j++){
        Particle p = _particles.get(j);
        while((PVector.sub(p._s,pos)).mag() < 2 * radio){  
          pos = new PVector(random((DISPLAY_CENTER.x - screenLargo/2) + radio, (DISPLAY_CENTER.x - screenLargo/2 + screenLargo) - radio), random(( DISPLAY_CENTER.y - screenAncho/2) + radio, (DISPLAY_CENTER.y - screenAncho/2 + screenAncho) - radio));
          j = 0;
        }
      }
    }*/
  _system.addParticle(0, pos, new PVector(0, vel), masa, radio );
  _particles = _system.getParticleArray();
}

void drawStaticEnvironment()
{
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  strokeWeight(0);
  noStroke();
  fill(132, 96, 166);
  triangle(_planes.get(0)._pos1.x, _planes.get(0)._pos1.y, _planes.get(0)._pos2.x, _planes.get(0)._pos1.y, _planes.get(0)._pos2.x, _planes.get(0)._pos2.y);
  triangle(_planes.get(1)._pos1.x, _planes.get(1)._pos1.y, _planes.get(1)._pos2.x, _planes.get(1)._pos2.y, _planes.get(1)._pos1.x, _planes.get(0)._pos1.y);
  triangle(_planes.get(0)._pos1.x, _planes.get(7)._pos2.y, _planes.get(8)._pos2.x, _planes.get(8)._pos2.y, _planes.get(11)._pos2.x/0.925, _planes.get(11)._pos2.y/0.95);
  rect(_planes.get(0)._pos1.x, _planes.get(0)._pos1.y, _planes.get(8)._pos2.x - _planes.get(0)._pos1.x, _planes.get(8)._pos2.y -_planes.get(0)._pos1.y);  
  rect(_planes.get(0)._pos2.x, _planes.get(0)._pos2.y, _planes.get(1)._pos1.x/2, _planes.get(0)._pos1.y);
  fill(0, 0, 0);
  triangle(_planes.get(5)._pos2.x, _planes.get(4)._pos2.y, _planes.get(5)._pos2.x, _planes.get(5)._pos2.y, _planes.get(5)._pos1.x, _planes.get(4)._pos1.y);
  
  
  for(int i = 0; i < _planes.size()-4; i++){
    PlaneSection p = _planes.get(i);
    p.draw();
  }
  if (!izq){
    PlaneSection p = _planes.get(_planes.size()-4);
    p.draw();
  }
  else if (izq){
    PlaneSection p = _planes.get(_planes.size()-2);
    p.draw();
  }
  if (!der){
    PlaneSection p = _planes.get(_planes.size()-3);
    p.draw();
  }
  else if (der){
    PlaneSection p = _planes.get(_planes.size()-1);
    p.draw();
  }
  
}

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

void draw() 
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;
  
  drawStaticEnvironment();
  
  _system.run();
  _system.computeCollisions(_planes, _computePlaneCollisions);  
  _system.display(); 
  printInfo();  

  _simTime += SIM_STEP;
}

void printInfo()
{
  fill(255);
  textSize(14);
  text("Number of particles : " + numBalls, width*0.025, height*0.025);
  text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.05);
  text("Elapsed time = " + _elapsedTime + " s", width*0.725 , height*0.025);
  text("Simulated time = " + _simTime + " s ", width*0.725, height*0.05);
  
  text("Tecla B: Lanzar pelota", width*0.025, height*0.9);
  text("Tecla I: Reinicio", width*0.025, height*0.95);
  
  textSize(22);
  text("A", width*0.35, height*0.95);
  text("L", width*0.65, height*0.95);
  
  /*text("- Tecla r / R: Genera un movimiento aleatorio simultáneo de las bolas ", width*0.025, height*0.80);
  text("- Tecla c / C: Se computan o se ignoran las colisiones entre bolas ", width*0.025, height*0.85);
  text("- Tecla i / I: Reinicia la simulación ", width*0.025, height*0.90);
  text("- Tecla f / F: Genera una fuerza de atracción en una de las esquinas ", width*0.025, height*0.95);
*/}

void keyPressed()
{
  // Código para manejar la interfaz de teclado
  if(key == 'i' || key == 'I'){
    _system.restart();
  }
  
  if(key == 'a' || key == 'A'){
    izq = true;
  }
  if(key == 'l' || key == 'L'){
    der = true;
  }
  if(key == 'b' || key == 'B'){
    float radio = worldToPixels(radBalls);
    _particles = _system.getParticleArray();
    PVector pos = new PVector(DISPLAY_CENTER.x - screenLargo/3.3, DISPLAY_CENTER.y - screenAncho/2.8 + screenAncho);
    _system.addParticle(numBalls, pos, new PVector(0, vel), masa, radio);
    numBalls++;
  }
}
  
void keyReleased()
{
  if (key == 'a' || key == 'A'){
    izq = false;
  }
  if (key == 'l' || key == 'L'){
    der = false;
  }
}
 
void stop()
{
}
