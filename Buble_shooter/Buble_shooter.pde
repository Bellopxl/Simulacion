PVector pos, pos_canon;
float x, y, radio_elipse, dt, vel, dx, dy;
boolean disp;
float ang;
 
void setup() {
  size(600,600);
  radio_elipse = 60; // Radio de la base del cañón
  pos = new PVector(0,0);
  ang = -HALF_PI; // ángulo
  dt = 0.1;
  vel = 0.01; // Velocidad del disparo
  pos_canon = new PVector(); // Posición del extremo del cañón
  // Posición base del disparo
  dx = 0.0;
  dy = 0.0;
  disp = false; // Booleano del disparo
}
void draw() { 
  background(218, 247, 166);
   
  // Base del cañón
  ellipse (width / 2, height, radio_elipse, radio_elipse);
  stroke (88, 24, 69); // Borde de la elipse
  fill (255, 87, 51); // Relleno elipse
   
  // Movimiento del cañón
  pos_canon.x = radio_elipse * cos(ang);
  pos_canon.y = radio_elipse * sin(ang);
  // Posición del cañón
  translate(width / 2, height - 10);
  line(0, 0, pos_canon.x, pos_canon.y); // Cañón
  stroke (88, 24, 69); // Borde
  
  // Disparar
  if (disp == true){
    // Formato del disparo
    ellipse(dx, dy, 15, 15);
    stroke (88, 24, 69); // Borde de la elipse
    fill (255, 87, 51); // Relleno elipse
    // Cambio de posición del disparo
    dx += vel * dt + pos.x;
    dy += vel * dt + pos.y; 
  }
}

void keyPressed() {
  // Disparar
  if (key == ' ') {
    disp = true;
    // Reestablecer la posición inicial del disparo
    dx = 0.0;
    dy = 0.0;
    // Velocidad del disparo
    pos.x = pos_canon.x / 4;
    pos.y = pos_canon.y / 4;
  }
  // Mover cañón hacia la derecha
  if (keyCode == RIGHT) {
    // Evitar que apunte a zonas fuera de la pantalla
    if (ang < 0)
      ang += 0.01;
  }
  // Mover cañón hacia la izquierda
  if (keyCode == LEFT) {
    // Evitar que apunte a zonas fuera de la pantalla
    if (ang > -PI)
      ang -= 0.01;
  }
}
