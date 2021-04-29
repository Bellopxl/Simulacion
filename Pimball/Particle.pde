class Particle  //<>//
{
  ParticleSystem _ps;
  int _id;

  PVector _s;
  PVector _v;
  PVector _a;

  float _m;
  float _radius;
  color _color;
  
  Particle(ParticleSystem ps, int id, PVector initPos, PVector initVel, float mass, float radius) 
  {
    _ps = ps;
    _id = id;

    _s = initPos.copy();
    _v = initVel.copy();
    _a = new PVector(0.0, 0.0);

    _m = mass;
    _radius = radius;
    _color = color(random(0,255), random(0,255), random(0,255));
  }

  void update() 
  {  
    updateForce();
   
    // Codigo con la implementación de las ecuaciones diferenciales para actualizar el movimiento de la partícula
    _v.add(PVector.mult(_a, SIM_STEP));
    _s.add(PVector.mult(_v, SIM_STEP));
  }

  void updateForce()
  {  
    //PVector Froz = PVector.mult(_v, - _ps._Kd);
    PVector Fgrav = PVector.mult(_ps.G, _m);
    PVector _f = Fgrav; //PVector.add(Fgrav, Froz);
    _a = PVector.div(_f, _m);
  }

 void planeCollision(ArrayList<PlaneSection> planes)
  { 
    for(int i=0; i < planes.size()-4;i++){
      PlaneSection p = planes.get(i);
      
      PVector n = p.getNormal();
      float d = (p.getDistance(_s) * n.mag()) - _radius;
            
      PVector plano = PVector.sub(p.getPoint2(), p.getPoint1());
      float modulo_plano = plano.mag();
  
      float p1 = PVector.sub(p.getPoint1(), _s).dot(plano) / modulo_plano;    
      float p2 = PVector.sub(p.getPoint2(), _s).dot(plano) / modulo_plano;
      
      if(abs(p1) < modulo_plano && abs(p2) < modulo_plano && d < 0){
        PVector ds = PVector.mult(n, d * (1+_ps._Kd));
        _s = PVector.sub(_s, ds);
        
        float nv = PVector.dot(n, _v);
        PVector vn = PVector.mult(n, nv);
        PVector vt = PVector.sub(_v, vn);
        _v = PVector.mult(PVector.sub(vt, PVector.mult(vn, _ps._Kd)), _ps.Cr);
      }
    }
    if (!izq){
        PlaneSection p = _planes.get(_planes.size()-4);
        PVector n = p.getNormal();
        float d = (p.getDistance(_s) * n.mag()) - _radius;
        PVector plano = PVector.sub(p.getPoint2(), p.getPoint1());
        float modulo_plano = plano.mag();
        float p1 = PVector.sub(p.getPoint1(), _s).dot(plano) / modulo_plano;    
        float p2 = PVector.sub(p.getPoint2(), _s).dot(plano) / modulo_plano;
        
        if(abs(p1) < modulo_plano && abs(p2) < modulo_plano && d < 0){
          PVector ds = PVector.mult(n, d * (1+_ps._Kd));
          _s = PVector.sub(_s, ds);
          
          float nv = PVector.dot(n, _v);
          PVector vn = PVector.mult(n, nv);
          PVector vt = PVector.sub(_v, vn);
          _v = PVector.mult(PVector.sub(vt, PVector.mult(vn, _ps._Kd)), _ps.Cr);
        }
      }
      else if (izq){
        PlaneSection p = _planes.get(_planes.size()-2);
        PVector n = p.getNormal();
        float d = (p.getDistance(_s) * n.mag()) - _radius;
        PVector plano = PVector.sub(p.getPoint2(), p.getPoint1());
        float modulo_plano = plano.mag();
        float p1 = PVector.sub(p.getPoint1(), _s).dot(plano) / modulo_plano;    
        float p2 = PVector.sub(p.getPoint2(), _s).dot(plano) / modulo_plano;
        
        if(abs(p1) < modulo_plano && abs(p2) < modulo_plano && d < 0){
          PVector ds = PVector.mult(n, d * (1+_ps._Kd));
          _s = PVector.sub(_s, ds);
          
          float nv = PVector.dot(n, _v);
          PVector vn = PVector.mult(n, nv);
          PVector vt = PVector.sub(_v, vn);
          _v = PVector.mult(PVector.sub(vt, PVector.mult(vn, _ps._Kd)), _ps.Cr);
        }
      }
      if (!der){
        PlaneSection p = _planes.get(_planes.size()-3);
        PVector n = p.getNormal();
        float d = (p.getDistance(_s) * n.mag()) - _radius;
        PVector plano = PVector.sub(p.getPoint2(), p.getPoint1());
        float modulo_plano = plano.mag();
        float p1 = PVector.sub(p.getPoint1(), _s).dot(plano) / modulo_plano;    
        float p2 = PVector.sub(p.getPoint2(), _s).dot(plano) / modulo_plano;
        
        if(abs(p1) < modulo_plano && abs(p2) < modulo_plano && d < 0){
          PVector ds = PVector.mult(n, d * (1+_ps._Kd));
          _s = PVector.sub(_s, ds);
          
          float nv = PVector.dot(n, _v);
          PVector vn = PVector.mult(n, nv);
          PVector vt = PVector.sub(_v, vn);
          _v = PVector.mult(PVector.sub(vt, PVector.mult(vn, _ps._Kd)), _ps.Cr);
        }
      }
      else if (der){
        PlaneSection p = _planes.get(_planes.size()-1);
        PVector n = p.getNormal();
        float d = (p.getDistance(_s) * n.mag()) - _radius;
        PVector plano = PVector.sub(p.getPoint2(), p.getPoint1());
        float modulo_plano = plano.mag();
        float p1 = PVector.sub(p.getPoint1(), _s).dot(plano) / modulo_plano;    
        float p2 = PVector.sub(p.getPoint2(), _s).dot(plano) / modulo_plano;
        
        if(abs(p1) < modulo_plano && abs(p2) < modulo_plano && d < 0){
          PVector ds = PVector.mult(n, d * (1+_ps._Kd));
          _s = PVector.sub(_s, ds);
          
          float nv = PVector.dot(n, _v);
          PVector vn = PVector.mult(n, nv);
          PVector vt = PVector.sub(_v, vn);
          _v = PVector.mult(PVector.sub(vt, PVector.mult(vn, _ps._Kd)), _ps.Cr);
        }
      }
  } 
  
  void particleCollisionVelocityModel()
  {
    ArrayList<Particle> _array = _ps.getParticleArray();
    for(int i=_id+1; i < numBalls; i++){
      Particle p = _array.get(i);
      PVector vec_d = PVector.sub(_s, p._s);
      float d = vec_d.mag();
      
      if(d < (_radius + p._radius)){
        PVector d_unit = vec_d.copy();
        d_unit.normalize();
        
        PVector n1 = PVector.mult(d_unit, PVector.dot(_v, vec_d)/d);
        PVector t1 = PVector.sub(_v, n1);
        PVector n2 = PVector.mult(d_unit, PVector.dot(p._v, vec_d)/d);
        PVector t2 = PVector.sub(p._v, n2);       
        
        // Restitución
        float L = _radius + p._radius - d;
        float vrel = PVector.sub(n1, n2).mag();
        
        if(vrel != 0.0){
          _s.add(PVector.mult(n1, -L/vrel));
          p._s.add(PVector.mult(n2, -L/vrel));
        } 
        
        // Velocidades de salida
        float u1 = PVector.dot(n1, vec_d) / d;
        float u2 = PVector.dot(n2, vec_d) / d;
        
        float v1 = ((_m - p._m)*u1 + (2*p._m*u2))/(_m+p._m);
        n1 = PVector.mult(d_unit, v1);
        float v2 = ((p._m - _m)*u2 + (2*_m*u1))/(_m+p._m);
        n2 = PVector.mult(d_unit, v2);
        
        _v = PVector.mult(PVector.add(n1, t1), _ps.Cr2);
        p._v = PVector.mult(PVector.add(n2, t2), _ps.Cr2);
      }
    }
  }
  
  void particleCollisionSpringModel()
  { 
    ArrayList<Particle> _array = _ps.getParticleArray();
    
    if (numBalls > 1){
      for(int i=_id+1; i < numBalls; i++){
        Particle p = _array.get(i);
        PVector dist = PVector.sub(p._s, _s);
        float distance = dist.mag();
        float dm = p._radius + _radius;
        
        if(distance < dm){
          float angle = atan2(dist.y, dist.x);
          PVector target = new PVector(_s.x + cos(angle)*dm, _s.y + sin(angle)*dm);
          PVector accel = PVector.mult(PVector.sub(target, p._s), _ps._Ke);
          _v = PVector.mult(PVector.sub(_v, accel), _ps._Kd);
          p._v = PVector.mult(PVector.add(p._v, accel), _ps._Kd);
        }
      }
    }
  }
  
  void display() 
  {
    PVector screenPos = new PVector();
    worldToScreen(_s, screenPos);
    strokeWeight(2);
    
    fill(_color);
    circle(_s.x, _s.y, 2.0*_radius);
  }
}
