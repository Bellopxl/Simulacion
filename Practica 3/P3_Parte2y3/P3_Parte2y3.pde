// Authors: 
// Lluís Bello Alventosa
// Raúl Sanz Jodar

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {200, 200, 255};

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _collisionStructureTime = 0.0;
float _collisionTime = 0.0;   // Tiempo que tarda en computar las colisiones (ms)
float _calcuteSimTime = 0.0;
float _lastCalcuteSimTime = 0.0;
float _drawSimTime = 0.0;
float _elapsedTime = 0.0;   // Elapsed (real) time (s)
final float SIM_STEP = 0.05;   // Simulation step (ms)

// Particle control:

ParticleSystem _system;   // Particle system
ArrayList<PlaneSection> _planes;    // Planes representing the limits
HashTable tablaHash;
Grid grid;
boolean _computePlaneCollisions = true;
int _typeCollision = 2; // 0: Nada, 1: Velocidades; 2: Muelle
int _typeStructure = 1; // 0: Nada, 1: Grid; 2: Hash

// Problem Parameters

final float masa = 0.1;
final int numBalls = 1000;
final float radBalls = 15;
final float minDist = 2*radBalls;

// Auxiliary variables

boolean isRemove = false;
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
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  //_output = createWriter (FILE_NAME);  
  
  _system = new ParticleSystem();
  _planes = new ArrayList<PlaneSection>();
  posOrigin = new ArrayList<PVector>();
  
  initSimulation();
}

void initSimulation()
{  
    // Tablero
  _planes.add(new PlaneSection(width*0.2, height*0.25, width*0.75, height*0.25,true));
  _planes.add(new PlaneSection(width*0.2, height*0.25, width*0.055, height*0.375, false));
  _planes.add(new PlaneSection(width*0.75, height*0.25, width*0.895, height*0.375, true));
  _planes.add(new PlaneSection(width*0.055, height*0.375, width*0.425, height*0.75, false));
  _planes.add(new PlaneSection(width*0.895, height*0.375, width*0.525, height*0.75, true));
  _planes.add(new PlaneSection(width*0.425, height*0.75, width*0.525, height*0.75, false));

    // Bolas de billar
  for (int i = 0; i < numBalls; i++){
    PVector pos = new PVector(random(width*0.2 + radBalls, width*0.75 - radBalls), random(height*0.25 + radBalls, height*0.375 - radBalls));
    posOrigin.add(pos);
    _system.addParticle(i, pos, new PVector(0,0), masa, radBalls );
  }
}

void drawStaticEnvironment()
{
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  
  for(int i = 0; i < _planes.size(); i++){
    PlaneSection p = _planes.get(i);
    p.draw();
  }
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
  text("Number of particles : " + _system.getNumParticles(), width*0.35, height*0.05);
  text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.2, height*0.1);
  text("Simulated time = " + _simTime + " s ", width*0.2, height*0.15);

  if(_typeStructure == 0)
    text("Estructura actual: Sin estructura", width*0.7, height*0.75);
  else if(_typeStructure == 1)
    text("Estructura actual: Grid", width*0.7, height*0.75);
  else
    text("Estructura actual: HashTable", width*0.7, height*0.75);
  text("- Tecla 0: Sin estructura", width*0.7, height*0.8);
  text("- Tecla 1: Grid", width*0.7, height*0.85);
  text("- Tecla 2: HashTable", width*0.7, height*0.9);
  
  text("- Tecla p / P: Elimina el plano inferior para simular un fluido ", width*0.025, height*0.80);
  text("- Tecla c / C: Se computan o se ignoran las colisiones entre bolas ", width*0.025, height*0.85);
  text("- Tecla i / I: Reinicia la simulación ", width*0.025, height*0.90);
  
  /*_output.println((_collisionTime + _calcuteSimTime + _collisionStructureTime));
  _output.flush(); // Write the remaining data
  if(_elapsedTime > 10)
    exit();*/
}

void mouseClicked(){
  for (int i = 0; i < 100; i++){
    PVector pos = new PVector(random(width*0.2 + radBalls, width*0.75 - radBalls), random(height*0.25 + radBalls, height*0.375 - radBalls));
    posOrigin.add(pos);
    _system.addParticle(i, pos, new PVector(0,0), masa, radBalls );
  }
}

void keyPressed()
{
  // Código para manejar la interfaz de teclado
  if(key == 'c' || key == 'C'){
    if(_typeCollision == 0)
      _typeCollision = 2;
    else
      _typeCollision = 0;
  }
  if(key == 'i' || key == 'I'){
    _system.restart();
  }
  if(key == 'p' || key == 'P'){
    if(!isRemove){
      isRemove = true;
      _planes.remove(_planes.size()-1);
    }
    else{
      isRemove = false;
      _planes.add(new PlaneSection(width*0.425, height*0.75, width*0.525, height*0.75, false));
    }
  }
  if(key == '0'){
    _typeStructure = 0;
    for (Particle p : _system.getParticleArray()) {
      p._color = color(0, 157, 255);
    }
  }
  if(key == '1'){
    _typeStructure = 1;
  }
  if(key == '2'){
    _typeStructure = 2;
  }
}
  
void stop()
{
  //_output.close();
}
