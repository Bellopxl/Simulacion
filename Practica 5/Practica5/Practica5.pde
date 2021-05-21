// Use PeasyCam for 3D rendering
import peasy.*;

// Problem parameters:

final int _MAP_SIZE_X = 50;
final int _MAP_SIZE_Y = 50;
final float _MAP_CELL_SIZE = 10;

float amplitud = 15;
float longitud = 150;

PVector centro_d = new PVector(5, 0, 5);
PVector centro_r = new PVector(0, 0, 0);
PVector centro_g = new PVector(5, 0, 5);

float periodo_d = 20;
float periodo_r = 1;
float periodo_g = 40;

// Display stuff:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)

final float FOV = 60;   // Field of view (º)
final float NEAR = 0.01;   // Camera near distance (m)
final float FAR = 100000.0;   // Camera far distance (m)

final color BACKGROUND_COLOR = color(242, 242, 242);   // Background color (RGB)
boolean _viewmode = false;
boolean _clear = false;
PImage img;  // Textura de la ola

PeasyCam _camera;   // mouse-driven 3D camera

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)

// Simulated entities:

HeightMap _heightMap;   // Mapa de altura 

// Main code:

void initSimulation()
{
  _elapsedTime = 0.0;
  _heightMap = new HeightMap(_MAP_SIZE_X, _MAP_SIZE_Y, _MAP_CELL_SIZE);
}

void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen(P3D);
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
  {
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
  }
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  
  float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);  
  perspective((FOV*PI)/180, aspect, NEAR, FAR);
  _camera = new PeasyCam(this, 1000);
  _camera.rotateX(0.58);
  _camera.rotateY(-0.7); // (-41*PI)/180
  _camera.rotateZ(0.36);
  
  img = loadImage("water_surface.png");
  
  lights();
  smooth();

  initSimulation();
}

void printInfo()
{
  pushMatrix();
  {
    camera();
    fill(0);
    textSize(20);
    
    text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.05);
    text("Elapsed time = " + _elapsedTime + " s", width*0.025, height*0.075);
    
    text("Teclas R/r: Alternar la vista entre rejilla o textura", width*0.4, height*0.05, 0);
    text("Teclas C/c: Eliminar las olas presentes", width*0.4, height*0.075, 0);
    text("Tecla 1: Añadir una ola direccional", width*0.4, height*0.125, 0);
    text("Tecla 2: Añadir una ola radial", width*0.4, height*0.15, 0);
    text("Tecla 3: Añadir una ola de Gestner", width*0.4, height*0.175, 0);
  }
  popMatrix();
}

void drawAxis()
{
  fill(255, 255, 255);
  sphere(5.0);

  fill(255, 0, 0);
  box(1000.0, 1, 1);

  fill(0, 255, 0);
  box(1, 1000.0, 1);

  fill(0, 0, 255);
  box(1, 1, 1000.0);
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  background(BACKGROUND_COLOR);
  //drawAxis();
  
  _heightMap.update();
  
  if(_clear){
    _heightMap.clearWaves();
    _clear = false;
  }  

  printInfo();
}

void keyPressed()
{ 
  if (key == '1')
    _heightMap.addWave(new WaveDirectional(amplitud, centro_d, longitud, longitud / periodo_d));

  if (key == '2')
    _heightMap.addWave(new WaveRadial(amplitud, centro_r, longitud, longitud / periodo_r));

  if (key == '3')
    _heightMap.addWave(new WaveGerstner(amplitud, centro_g, longitud, longitud / periodo_g));
    
  if(key == 'r' || key == 'R')
    if(_viewmode)
      _viewmode = false;
    else
      _viewmode = true;
      
   if(key == 'c' || key == 'C')
     _clear = true;
}
