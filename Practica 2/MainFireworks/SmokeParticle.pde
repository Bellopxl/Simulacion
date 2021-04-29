
// A simple Particle class, renders the particle as an image

class SmokeParticle {
  PVector _s;
  PVector _v;
  PVector _a;
  float _m;
  int _ttl;
  PVector _F;
  PImage img;

  SmokeParticle(PVector l, PImage img_, float m) {
    _a = new PVector(0, 0);
    float vx = randomGaussian()*0.3;
    float vy = randomGaussian()*0.3 - 1.0;
    _v = new PVector(vx, vy);
    _s = l.copy();
    _m = m;
    _ttl = 90;
    img = img_;
    _numParticles++;
  }

void run() {
    update();
    display();
  }

void update() 
  {
    if (isDead())
      return;
      
    updateForce();
   
    // Codigo con la implementación de las ecuaciones diferenciales para actualizar el movimiento de la partícula
    _a = PVector.div(_F, _m);
    _v.add(PVector.mult(_a, SIM_STEP));
    _s.add(PVector.mult(_v, SIM_STEP));
    
    _ttl--;
  }
  
  void updateForce()
  {
    // Código para calcular la fuerza que actua sobre la partícula
    PVector _Fgrav = PVector.mult(G, _m);
    PVector _Fwind = PVector.mult(PVector.add(_windVelocity, _v), -WIND_CONSTANT);
    _F = PVector.add(_Fgrav, _Fwind);
  }

  // Method to display
  void display() {
    imageMode(CENTER);
    tint(255, _ttl);
    image(img, _s.x, _s.y);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (_ttl <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
