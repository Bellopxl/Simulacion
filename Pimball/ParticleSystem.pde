class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  // ... (G, Kd, Ke, Cr, etc.)
  final float _Kd = 0.95;
  final float _Ke = 0.5;
  final float Cr = 0.95;
  final float Cr2 = 0.98;
  final float Gc = 9.801;   // Gravity constant (m/(s*s))
  final PVector G = new PVector(0.0, Gc);   // Acceleration due to gravity (m/(s*s))

  ParticleSystem()  
  {
    _particles = new ArrayList<Particle>();
    _n = 0;  
  }

  void addParticle(int id, PVector initPos, PVector initVel, float mass, float radius) 
  { 
    _particles.add(new Particle(_system, id, initPos, initVel, mass, radius));
    _n += 1;
  }
  
  void restart()
  {
      for (int i = _n - 1; i > 1; i--){
        _particles.remove(i);
      }
      Particle p = _particles.get(0);
      p._s.set(new PVector(DISPLAY_CENTER.x - screenLargo/3.3, DISPLAY_CENTER.y - screenAncho/2.8 + screenAncho));
      p._v.set(new PVector(0,-3000));
      p._a.set(new PVector(0,0));
      _lastTimeDraw = millis();   
      _deltaTimeDraw = 0.0;   
      _simTime = 0.0;
      _elapsedTime = 0.0;   
      numBalls = 1;
      _n = 1;
  }
  
  int getNumParticles()
  {
    return _n;
  }
  
  ArrayList<Particle> getParticleArray()
  {
    return _particles;
  }

  void run() 
  {
    for (int i = 0; i < _n; i++) 
    {
      Particle p = _particles.get(i);
      p.update();
    }
  }
  
  void computeCollisions(ArrayList<PlaneSection> planes, boolean computeParticleCollision) 
  { 
    if(computeParticleCollision){  
      for (int i = 0; i < _n; i++) {
        Particle p = _particles.get(i);
        p.planeCollision(planes);
        if(_typeCollision == 1){
           p.particleCollisionVelocityModel();
        }
      }
    }
  }
    
  void display() 
  {
    for (int i = 0; i < _n; i++) 
    {
      Particle p = _particles.get(i);      
      p.display();
    }         
  }
}
