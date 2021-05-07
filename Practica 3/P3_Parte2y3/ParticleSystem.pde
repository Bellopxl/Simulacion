class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  // ... (G, Kd, Ke, Cr, etc.)
  final float _Kd = 0.05;
  final float _Ke = 0.6;
  final float Cr = 0.95;
  final float Gc = 9.801;   // Gravity constant (m/(s*s))
  final PVector G = new PVector(0.0, Gc);   // Acceleration due to gravity (m/(s*s))

  ParticleSystem()  
  {
      _particles = new ArrayList<Particle>();
    _n = 0;  
    
    grid = new Grid(10, 10);
    tablaHash = new HashTable(2*numBalls, 80);
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
      _elapsedTime = 0.0;
      _simTime = 0.0;   
      _collisionStructureTime = 0.0;
      _collisionTime = 0.0;  
      _calcuteSimTime = 0.0;
      _drawSimTime = 0.0;
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
    int beforeCalculate = millis();
  
    for (int i = 0; i < _n; i++){
      Particle p = _particles.get(i);
      p.update();
    }
    
    int afterCalculate = millis();
    _calcuteSimTime = (afterCalculate - beforeCalculate);
    text("Calcular simulación = " + _calcuteSimTime + " ms", width*0.5 , height*0.15);
  }
  
  void computeCollisions(ArrayList<PlaneSection> planes, boolean computeParticleCollision) 
  { 
    if(computeParticleCollision){
      int beforeStructures = millis();
      // Actualizar estructuras de datos de gestión de colisiones
      if(_typeStructure == 1){
        // Borrar e insertar las particulas en la Grid 
        grid.borrado();
        for (Particle p : _particles) {
          p.celdaG = grid.insertar(p._s, p);
        }
      }
      else if(_typeStructure == 2){
        // Borrar e insertar las partículas en la tabla Hash 
        tablaHash.borrado();
        for (Particle p : _particles) {
          p.celdaH = tablaHash.insertar(p._s, p);
        }
      }
      int afterStructures = millis();
      _collisionStructureTime = (afterStructures - beforeStructures);
      text("Actualizar estructuras de datos = " + _collisionStructureTime + " ms", width*0.5, height*0.1);

      // Gestión de colisiones
      int beforeCollision = millis();
      for (Particle p: _particles) {
        p.planeCollision(planes);
        ArrayList<Particle> vecinos = _particles;
        // Colisión con Grid
        if(_typeStructure == 1){
          vecinos = grid.getVecinos(p._s);
        }
        // Colisión con tabla Hash
        else if(_typeStructure == 2){
          vecinos = tablaHash.getVecinos(p._s);
        }
        for(Particle q: vecinos){
          if(_typeCollision == 2)
            p.particleCollisionSpringModel(q);
        }
      }
      int afterCollision = millis();
      _collisionTime = (afterCollision - beforeCollision);  
      text("Cómputo de colisiones = " + _collisionTime + " ms", width*0.2 , height*0.2);
    }
  }
    
  void display() 
  {
    int beforeDraw = millis();

    for (int i = 0; i < _n; i++) 
    {
      Particle p = _particles.get(i);      
      p.display();
    }  
    
    int afterDraw = millis();
    _drawSimTime = (afterDraw - beforeDraw);
    fill(0);
    text("Dibujar simulación = " + _drawSimTime + " ms", width*0.5 , height*0.2);
  }
}
