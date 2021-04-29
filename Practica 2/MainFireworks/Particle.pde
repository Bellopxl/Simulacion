public class Particle 
{
  ParticleType _type;

  PVector _s;   // Position (m)
  PVector _v;   // Velocity (m/s)
  PVector _a;   // Acceleration (m/(s*s))
  PVector _F;   // Force (N)
  float _m;   // Mass (kg)

  int _ttl;   // Time to live (iterations)
  color _color;   // Color (RGB)
  
  final static int _particleSize = 2;   // Size (pixels)
  final static int _casingLength = 25;   // Length (pixels)

  Particle(ParticleType type, PVector s, PVector v, float m, int ttl, color c) 
  {
    _type = type;
    
    _s = s.copy();
    _v = v.copy();
    _m = m;

    _a = new PVector(0.0 ,0.0, 0.0);
    _F = new PVector(0.0, 0.0, 0.0);
   
    _ttl = ttl;
    _color = c;
    _numParticles++;
  }

  void run() 
  {
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
    /*PVector vdir = _v.copy().normalize();
    PVector wdir = _windVelocity.copy().normalize();
    if( vdir != wdir){
      PVector _Fwind = PVector.mult(PVector.add(_windVelocity, _v), -WIND_CONSTANT);
      _F = PVector.add(_Fgrav, _Fwind);
    }
    else{
      _F = _Fgrav.copy();
    }*/
    float ang = acos(_v.dot(_windVelocity) / (_v.mag()*_windVelocity.mag()));
    if( ang != 0){
      PVector _Fwind = PVector.mult(PVector.add(_windVelocity, _v), -WIND_CONSTANT);
      _F = PVector.add(_Fgrav, _Fwind);
    }
    else{
      _F = _Fgrav.copy();
    }
  }
  
  PVector getPosition()
  {
    return _s;
  }

  void display() 
  {
    // Codigo para dibujar la partícula. Se debe dibujar de forma diferente según si es la carcasa o una partícula normal
    if (_type == ParticleType.REGULAR_PARTICLE){
       stroke(_color, _ttl);
       fill(_color, _ttl);
       ellipse(_s.x, _s.y, _particleSize, _particleSize);
    }
    else{
      stroke(255);
      fill(255);
      ellipse(_s.x, _s.y, _casingLength, _casingLength);
    }
  }
  
  boolean isDead() 
  {
    if (_ttl < 0.0)
      return true;
    else
      return false;
  }
}
