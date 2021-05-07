class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  float _Kd;
  final float Cr1 = 0.95;
  final float Cr2 = 0.98;

  ParticleSystem(float Kd)  
  {
    _particles = new ArrayList<Particle>();
    _n = 0;
    
    _Kd = Kd;   
  }

  void addParticle(int id, PVector initPos, PVector initVel, float mass, float radius) 
  { 
    _particles.add(new Particle(_system, id, initPos, initVel, mass, radius));
    _n += 1;
  }
  
  void restart()
  {
    for (int i = 0; i < _n; i++){
      Particle p = _particles.get(i);
      p._s.set(posOrigin.get(i));
      p._v.set(new PVector(0,0));
      p._a.set(new PVector(0,0));
      _lastTimeDraw = millis();   
      _deltaTimeDraw = 0.0;   
      _simTime = 0.0;
      _elapsedTime = 0.0;  
    }
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
        if(_typeCollision == 1)
           p.particleCollisionVelocityModel();
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
