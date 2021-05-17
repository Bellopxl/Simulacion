// Cámara 3D
import peasy.*;
PeasyCam cam;

// Mallas
Malla m1, m2, m3;
final int STRUCTURED = 1;
final int BEND = 2;
final int SHEAR = 3;
int puntosX, puntosY;

// Simulación
float dt = 0.1;
PVector g = new PVector (0, 0, 0);
PVector viento = new PVector (0, 0, 0);
boolean vientoActivo = false;
boolean gravedadActivo = false;

public void settings(){
  System.setProperty("jogl.disable.openglcore", "true");
  fullScreen(P3D);
}

void setup(){
  smooth();
  
  // Cámara
  cam = new PeasyCam(this, 350);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(500);
  
  // Mallas
  puntosX = 50;
  puntosY = 30;
  m1 = new Malla(STRUCTURED, puntosX, puntosY);
  m2 = new Malla(BEND, puntosX, puntosY);
  m3 = new Malla(SHEAR, puntosX, puntosY);
}

void draw(){
  background(255, 255, 255);
  translate(-200, -100, -200);
  
  // Datos
  fill(0, 0, 100);
  text("Tecla V: Activa / Desactiva el viento", -90, -85, 0);
  text("Tecla G: Activa / Desactiva la gravedad", -90, -70, 0);
  text("Fuerzas:", 600, -100, 0);
  
  // Viento
  if (vientoActivo){
    text("Viento activado", 600, -85, 0);
    viento.x = 0.5 - random(10, 60) * 0.1; 
    viento.y = 0.1 + random(0, 20) * 0.1;
    viento.z = 0.5 + random(10, 60) * 0.1;
  }
  else {
    text("Viento desactivado", 600, -85, 0);
    viento.x = 0; 
    viento.y = 0;
    viento.z = 0;
  }
  
  // Gravedad
  if (gravedadActivo){
    text("Gravedad activada", 600, -70, 0);
    g.y = 4.8;
  }
  else {
    text("Gravedad desactivada", 600, -70, 0);
    g.y = 0;
  }
  
  // Bandera
  //   Structured
  m1.update();
  m1.display();
  fill(0, 0, 100);
  text("Malla de tipo: Structured", 10, 270, 0);
  text("Constante elástica:" + m1.k, 10, 285, 0);
  text("Damping:" + m1.mDamping, 10, 300, 0);
  
  //   Bend
  m2.update();
  pushMatrix();
  translate(250, 0, 0);
  m2.display();
  fill(0, 0, 100);
  text("Malla de tipo: Bend", 10, 270, 0);
  text("Constante elástica:" + m2.k, 10, 285, 0);
  text("Damping:" + m2.mDamping, 10, 300, 0);
  popMatrix();
  
  //   Shear
  m3.update();
  pushMatrix();
  translate(500, 0, 0);
  m3.display();
  fill(0, 0, 100);
  text("Malla de tipo: Shear", 10, 270, 0);
  text("Constante elástica:" + m3.k, 10, 285, 0);
  text("Damping:" + m3.mDamping, 10, 300, 0);
  popMatrix();
}

void keyPressed()
{
  // Código para manejar la interfaz de teclado
  if(key == 'v' || key == 'V'){
    if(vientoActivo)
      vientoActivo = false;
    else
      vientoActivo = true;
  }
  if(key == 'g' || key == 'G'){
    if(gravedadActivo)
      gravedadActivo = false;
    else
      gravedadActivo = true;
  }
}
