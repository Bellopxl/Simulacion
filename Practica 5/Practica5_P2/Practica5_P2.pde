// Use PeasyCam for 3D rendering
import peasy.*;

// Problem parameters:

final int _MAP_SIZE_X = 100;
final int _MAP_SIZE_Y = 100;
final float _MAP_CELL_SIZE = 10;

float amplitud_d = 10;
float amplitud_r = 10;

float longitud = 30;

PVector centro_d = new PVector(5, 0, 5);
PVector centro_r = new PVector(0, 0, 0);

float periodo_d = 70;
float periodo_r = 10;

float factor_atenuacion = 5;
int s_timer = 0;

// Display stuff:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)

final float FOV = 60;   // Field of view (º)
final float NEAR = 0.01;   // Camera near distance (m)
final float FAR = 100000.0;   // Camera far distance (m)

final color BACKGROUND_COLOR = color(242, 242, 242);   // Background color (RGB)
boolean _viewmode = true;
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
  
  img = loadImage("water.jpg");
  
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
  float timer = random(0.01, 0.5);
  
  int p_time = millis()/1000 - s_timer;
  if(p_time > timer){
    for(int i = 0; i < random(2,6); i++)
      _heightMap.addWave(new WaveRadial(millis()/1000, amplitud_r, new PVector(random(-_MAP_SIZE_X*_MAP_CELL_SIZE/2, _MAP_SIZE_X*_MAP_CELL_SIZE/2), 0.0,random(-_MAP_SIZE_Y*_MAP_CELL_SIZE/2, _MAP_SIZE_Y*_MAP_CELL_SIZE/2)), longitud, longitud / periodo_r));
    s_timer = millis()/1000;
  }  
  printInfo();
}

void keyPressed()
{ 
  if(key == 'r' || key == 'R')
    if(_viewmode)
      _viewmode = false;
    else
      _viewmode = true;
      
  if(key == 'c' || key == 'C')
    _clear = true;
}
