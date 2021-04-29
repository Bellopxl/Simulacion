enum RocketType 
{
  // Introducir aquí los tipos de palmera que se implementarán
  EXPLOSION,  
  SATURN,
  ELIPSE;
}

final int NUM_ROCKET_TYPES = RocketType.values().length;

enum ParticleType 
{
  CASING,
  REGULAR_PARTICLE 
}

// Particle control:

FireWorks _fw;   // Main object of the program
int _numParticles = 0;   // Number of particles of the simulation

// Problem variables:

final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, Gc);   // Acceleration due to gravity (m/(s*s))
PVector _windVelocity = new PVector(10.0, 0.0);   // Wind velocity (m/s)
final float WIND_CONSTANT = 1.0;   // Constant to convert apparent wind speed into wind force (Kg/s) (Kd)

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)
final float SIM_STEP = 0.02;   // Simulation step (s)

/* Graficas 

boolean fin = false; // Valor que indica que todas las partículas han muerto para detener la simulación. 
int numParts = 45000; // Valor utilizado en la creación de las explosiones para controlar el número de partículas. 
PrintWriter _output;
final String FILE_NAME = numParts + "_rockets.txt";*/

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

  _fw = new FireWorks();
  _numParticles = 0;
}

void printInfo()
{
  fill(255);
  text("Number of particles : " + _numParticles, width*0.025, height*0.05);
  text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.075);
  text("Elapsed time = " + _elapsedTime + " s", width*0.025 , height*0.1);
  text("Simulated time = " + _simTime + " s ", width*0.025, height*0.125);
  text("Wind direction = (" + _windVelocity.x + ", " + _windVelocity.y + ")" , width*0.025, height*0.15);
  text("Para controlar el viento: ", width*0.8, height*0.05);
  text("- Tecla w (aumenta en +Y) ", width*0.8, height*0.075);
  text("- Tecla d (aumenta en +X) ", width*0.8, height*0.1);
  text("- Tecla s (aumenta en -Y) ", width*0.8, height*0.125);
  text("- Tecla a (aumenta en -X) ", width*0.8, height*0.15);
  /*
  _output.println((_elapsedTime - _simTime) + "\t" + (1.0/_deltaTimeDraw));
  _output.flush(); // Write the remaining data
  if (fin){
    _output.close();
    exit();
  }*/
    
}

void drawWind()
{
  // Código para dibujar el vector que representa el viento
  strokeWeight(1);
  stroke(255);
  // Eje +X
  line(width*0.075,height*0.2,width*0.1,height*0.2);
  pushMatrix();
    translate(width*0.1,height*0.2);
    float a1 = atan2(width*0.075-width*0.1,height*0.2-height*0.2);
    rotate(a1);
    line(0,0,-3,-3);
    line(0,0,3,-3);
  popMatrix();
  // Eje +Y
  line(width*0.075,height*0.175,width*0.075,height*0.2);
  pushMatrix();
    translate(width*0.075,height*0.175);
    float a2 = atan2(width*0.075-width*0.075, height*0.175-height*0.2);
    rotate(a2);
    line(0,0,-3,-3);
    line(0,0,3,-3);
  popMatrix();
    // Eje -X
  line(width*0.075,height*0.2,width*0.05,height*0.2);
  pushMatrix();
    translate(width*0.05,height*0.2);
    float a3 = atan2(width*0.05,height*0.2-height*0.2);
    rotate(a3);
    line(0,0,-3,-3);
    line(0,0,3,-3);
  popMatrix();
  // Eje -Y
  line(width*0.075,height*0.2,width*0.075,height*0.225);
  pushMatrix();
    translate(width*0.075,height*0.225);
    float a4 = atan2(width*0.075-width*0.075, height*0.225);
    rotate(a4);
    line(0,0,-3,-3);
    line(0,0,3,-3);
  popMatrix();
  
  strokeWeight(3);
  line(width*0.075,height*0.2,width*0.075+_windVelocity.x,height*0.2-_windVelocity.y);
  pushMatrix();
    translate(width*0.075+_windVelocity.x,height*0.2-_windVelocity.y);
    float a5 = atan2(-_windVelocity.x,-_windVelocity.y);
    rotate(a5);
    line(0,0,-5,-5);
    line(0,0,5,-5);
  popMatrix();
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  
  _fw.run();
  printInfo();  
  drawWind();
}

void mousePressed()
{
  PVector pos = new PVector(mouseX, mouseY);
  PVector vel = new PVector((pos.x - width/2), (pos.y - height));
    //for (int i=0; i<numRockets; i++){  

  color c = color(random(255),random(255),random(255));

  int type = (int)(random(NUM_ROCKET_TYPES)); 
    _fw.addRocket(RocketType.values()[type], new PVector(width/2, height), vel, c);
 // }
}

void keyPressed()
{
  // Código para manejar la interfaz de teclado
  if(key == 'w'){
    _windVelocity.y += 1;
  }
  if(key == 's'){
    _windVelocity.y -= 1;
  }
  if(key == 'a'){
    _windVelocity.x -= 1;
  }
  if(key == 'd'){
    _windVelocity.x += 1;
  }
}
