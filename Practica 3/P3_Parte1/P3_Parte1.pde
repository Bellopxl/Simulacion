// Authors: 
// Lluís Bello Alventosa
// Raúl Sanz Jodar

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 800;   // Display width (pixels)
int DISPLAY_SIZE_Y = 800;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {200, 200, 255};
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
final int numBalls = 5;
final float radBalls = 0.0305;
final float Kd = 0.2;
final float vel = 2000;
final float ancho = 1.27;
final float largo = 2.54;
final float Fc = 2500;

// Auxiliary variables

PVector attrack;
boolean isAttrack = false;
int idBall;
PVector drag1 = new PVector();
PVector drag2 = new PVector();
color colorBall = color(255,255,255);
ArrayList<PVector> posOrigin;

/* Graficas 

PrintWriter _output;
final String FILE_NAME = numBalls + ".txt";*/

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
  //_output = createWriter (FILE_NAME);  

  worldToScreen(DISPLAY_CENTER, DISPLAY_CENTER);
  
  screenAncho = worldToPixels(ancho);
  screenLargo = worldToPixels(largo);
  _system = new ParticleSystem(Kd);
  _planes = new ArrayList<PlaneSection>();
  posOrigin = new ArrayList<PVector>();
  
  initSimulation();
}

void initSimulation()
{ 
    // Tablero
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/2, DISPLAY_CENTER.y - screenAncho/2, DISPLAY_CENTER.x - screenLargo/2 + screenLargo, DISPLAY_CENTER.y - screenAncho/2, true));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/2, DISPLAY_CENTER.y - screenAncho/2, DISPLAY_CENTER.x - screenLargo/2, DISPLAY_CENTER.y - screenAncho/2 + screenAncho, false));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/2,  DISPLAY_CENTER.y - screenAncho/2 + screenAncho,  DISPLAY_CENTER.x - screenLargo/2 + screenLargo,  DISPLAY_CENTER.y - screenAncho/2 + screenAncho, false));
  _planes.add(new PlaneSection(DISPLAY_CENTER.x - screenLargo/2 + screenLargo, DISPLAY_CENTER.y - screenAncho/2, DISPLAY_CENTER.x - screenLargo/2 + screenLargo, DISPLAY_CENTER.y - screenAncho/2 + screenAncho, true));
  
    // Bolas de billar
  float radio = worldToPixels(radBalls);
  for (int i = 0; i < numBalls; i++){
    _particles = _system.getParticleArray();
    PVector pos = new PVector(random((DISPLAY_CENTER.x - screenLargo/2) + radio, (DISPLAY_CENTER.x - screenLargo/2 + screenLargo) - radio), random(( DISPLAY_CENTER.y - screenAncho/2) + radio, (DISPLAY_CENTER.y - screenAncho/2 + screenAncho) - radio));
    if(_system.getNumParticles() > 0){
      for(int j = 0; j < _particles.size(); j++){
        Particle p = _particles.get(j);
        while((PVector.sub(p._s,pos)).mag() < 2 * radio){  
          pos = new PVector(random((DISPLAY_CENTER.x - screenLargo/2) + radio, (DISPLAY_CENTER.x - screenLargo/2 + screenLargo) - radio), random(( DISPLAY_CENTER.y - screenAncho/2) + radio, (DISPLAY_CENTER.y - screenAncho/2 + screenAncho) - radio));
          j = 0;
        }
      }
    }
    posOrigin.add(pos);
    _system.addParticle(i, pos, new PVector(0,0), masa, radio );
  }
  _particles = _system.getParticleArray();
}

void drawStaticEnvironment()
{
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  strokeWeight(0);

  fill(89, 198, 69);
  //rect (DISPLAY_CENTER.x - screenLargo/2, DISPLAY_CENTER.y - screenAncho/2, screenLargo, screenAncho);
  rect(_planes.get(0)._pos1.x, _planes.get(0)._pos1.y, _planes.get(_planes.size()-1)._pos2.x - _planes.get(0)._pos1.x, _planes.get(_planes.size()-1)._pos2.y -_planes.get(0)._pos1.y);  
  for(int i = 0; i < _planes.size(); i++){
    PlaneSection p = _planes.get(i);
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
  fill(0);
  textSize(16);
  text("Number of particles : " + numBalls, width*0.025, height*0.05);
  text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.1);
  text("Elapsed time = " + _elapsedTime + " s", width*0.025 , height*0.15);
  text("Simulated time = " + _simTime + " s ", width*0.025, height*0.2);
  
  text("Para golpear una bola hay que pulsar sobre ella", width*0.4, height*0.1);
  text("y 'estirar' en la dirección contraria al movimiento.", width*0.4, height*0.15);
  
  text("- Tecla r / R: Genera un movimiento aleatorio simultáneo de las bolas ", width*0.025, height*0.80);
  text("- Tecla c / C: Se computan o se ignoran las colisiones entre bolas ", width*0.025, height*0.85);
  text("- Tecla i / I: Reinicia la simulación ", width*0.025, height*0.90);
  text("- Tecla f / F: Genera una fuerza de atracción en una de las esquinas ", width*0.025, height*0.95);
  /*_output.println(abs(_elapsedTime - _simTime) + "\t" + (1.0/_deltaTimeDraw));
  _output.flush(); // Write the remaining data
  if(_elapsedTime > 10)
    exit();*/
}

void mousePressed() {
  Particle p = _particles.get(idBall);
  if(p.overBall) { 
    p.locked = true; 
    p._color = color(255,255,255);
  } else {
    p.locked = false;
  }
  drag1 = new PVector(mouseX, mouseY); 
}

void mouseDragged() {
  Particle p = _particles.get(idBall);
  if(p.locked) {
    drag2 = new PVector(mouseX - drag1.x, mouseY - drag1.y);
  }
}

void mouseReleased() {
  Particle p = _particles.get(idBall);
  if(p.locked){
    p.locked = false;
    p._color = colorBall;
    drag2.mult(-1).normalize();
    p._v.set(new PVector(drag2.x*vel, drag2.y*vel));
  }
}


void keyPressed()
{
  // Código para manejar la interfaz de teclado
  if(key == 'r' || key == 'R'){
    for(int i = 0; i < _particles.size();i++){
      _particles.get(i)._v.set(new PVector(random(-1,1)*random(500,vel), random(-1,1)*random(500,vel)));
    }
  }
  if(key == 'c' || key == 'C'){
    if(_typeCollision == 0)
      _typeCollision = 1;
    else
      _typeCollision = 0;
  }
  if(key == 'i' || key == 'I'){
    _system.restart();
  }
  if(key == 'f' || key == 'F'){
    if(!isAttrack)
      isAttrack = true;
    else
      isAttrack = false;
  }
  if(key == '1'){
    _typeCollision = 1;
  }
  if(key == '2'){
    _typeCollision = 2;
  }
}
  
void stop()
{
 // _output.close();
}
