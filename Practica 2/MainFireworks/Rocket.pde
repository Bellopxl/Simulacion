public class Rocket 
{
  RocketType _type;

  Particle _casing;
  ArrayList<Particle> _particles;
  ArrayList<SmokeParticle> _smparticles;
 
  PVector _launchPoint;
  PVector _launchVel;  
  PVector _explosionPoint;
  PImage img;

  color _color;
  boolean _hasExploded;

  Rocket(RocketType type, PVector pos, PVector vel, color c) 
  {
    _type = type;
    _particles = new ArrayList<Particle>();
    _smparticles = new ArrayList<SmokeParticle>();
    
    _launchPoint = pos.copy();
    _launchVel = vel.copy();
    _explosionPoint = new PVector(0.0, 0.0, 0.0);
    
    _color = c;
    _hasExploded = false;
    img = loadImage("texture.png");

    createCasing();
  }
  
  void createCasing()
  {
    // Codigo para crear la carcasa
    int _ttl_casing = 50;
    
    _casing = new Particle(ParticleType.CASING, _launchPoint, _launchVel, (int)30, _ttl_casing, _color);
  }

  void explosion() 
  {
    // Codigo para utilizar el vector de partículas, creando particulas en él con diferentes velocidades para recrear distintos tipos de palmeras
    PVector _explosionVel = new PVector(0, 0);
    float _explosionAng = 0;
    switch (_type)
    {
      case EXPLOSION:
        for (int i=0; i<360; i++){
          int _ttl_particle = int(random(50,150));
          
          _explosionVel.x = cos(_explosionAng)*20 + random(-20,60);
          _explosionVel.y = sin(_explosionAng)*20 + random(-20,60);
          
          _particles.add(new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, _explosionVel, (int)15, _ttl_particle, _color));
          
          _explosionAng += 4 * 2 * PI / 360;
         }
      break;
      case ELIPSE:
        for (int i=0; i<360; i++){
          int _ttl_particle = int(random(50,150));
          
          _explosionVel.x = cos(_explosionAng+100)*20;
          _explosionVel.y = sin(_explosionAng)*20;
          
          _particles.add(new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, _explosionVel, (int)15, _ttl_particle, _color));
          
          _explosionAng += 4 * 2 * PI / 360;
        }
      break;
      case SATURN:
        for (int i=0; i<360; i++){
          int _ttl_particle = int(random(50,150));
          
          if(i <= 90){
            _explosionVel.x = cos(_explosionAng*_explosionAng);
            _explosionVel.y = cos(_explosionAng*_explosionAng);           
          }
          if(i > 90 && i <= 180){
            _explosionVel.x = cos(_explosionAng*_explosionAng)*20;
            _explosionVel.y = sin(_explosionAng*_explosionAng)*20;           
          }
          if(i > 180 && i <= 270){
            _explosionVel.x = cos(_explosionAng*_explosionAng);
            _explosionVel.y = sin(_explosionAng*_explosionAng);           
          }
          if(i > 270){
            _explosionVel.x = cos(_explosionAng*_explosionAng)*20;
            _explosionVel.y = cos(_explosionAng*_explosionAng)*20;           
          }
          
          _particles.add(new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, _explosionVel, (int)15, _ttl_particle, _color));
          
          _explosionAng += 4 * 2 * PI / 360;
        }
      break;
    }
  }

  void run() 
  {
    // Codigo con la lógica de funcionamiento del cohete. En principio no hay que modificarlo.
    // Si la carcasa no ha explotado, se simula su ascenso.
    // Si la carcasa ha explotado, se genera su explosión y se simulan después las partículas creadas.
    // Cuando una partícula agota su tiempo de vida, es eliminada.
    
    if (!_casing.isDead()){
      _casing.run();
      // Añadir las particulas de humo a la carcasa mientras esta va subiendo
      _smparticles.add(new SmokeParticle(_casing.getPosition().copy(), img, 15));
      for (int i = _smparticles.size()-1; i >= 0; i--) {
        SmokeParticle p = _smparticles.get(i);
        p.run();
      }
    }
    else if (_casing.isDead() && !_hasExploded)
    {
      _numParticles--;
      _hasExploded = true;

      _explosionPoint = _casing.getPosition().copy();
      explosion();
    }
    else
    {
      for (int i = _particles.size() - 1; i >= 0; i--) 
      {
        Particle p = _particles.get(i);
        p.run();
        
        if (p.isDead()) 
        {
          _numParticles--;
          _particles.remove(i);
        }
      }
      // Bucle para eliminar las particulas de humo de la carcasa
      for (int i = _smparticles.size()-1; i >= 0; i--) {
        SmokeParticle p = _smparticles.get(i);
        p.run();
        
        if (p.isDead()) 
        {
          _smparticles.remove(i);
          _numParticles--;
        }
      }/*
      if(_numParticles == 0){
        fin = true;
      }
      else{
        fin = false;
      }*/
    }
  }
}
