class Particle  //<>//
{
  ParticleSystem _ps;
  int _id;

  PVector _s;
  PVector _v;
  PVector _a;
  PVector Felas = new PVector(0.0, 0.0);

  float _m;
  float _radius;
  color _color;
  
  int celdaH;
  int celdaG;
  
  Particle(ParticleSystem ps, int id, PVector initPos, PVector initVel, float mass, float radius) 
  {
    _ps = ps;
    _id = id;

    _s = initPos.copy();
    _v = initVel.copy();
    _a = new PVector(0.0, 0.0);

    _m = mass;
    _radius = radius;
    _color = color(0, 157, 255);
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
    PVector Froz = PVector.mult(_v, - _ps._Kd);
    PVector Fgrav = PVector.mult(_ps.G, _m);
    PVector _f = PVector.add(Fgrav, Froz);
    _a = PVector.div(_f, _m);
  }

 void planeCollision(ArrayList<PlaneSection> planes){ 
    for(PlaneSection p: planes){      
      PVector n = p.getNormal();
      float dcol = abs(PVector.dot(PVector.sub(_s, p.getPoint1()), n));
        
      PVector plano = PVector.sub(p.getPoint2(), p.getPoint1());
      float modulo_plano = plano.mag();
      float p1 = PVector.sub(p.getPoint1(), _s).dot(plano) / modulo_plano;    
      float p2 = PVector.sub(p.getPoint2(), _s).dot(plano) / modulo_plano;
      
      if(dcol < _radius/2 && abs(p1) < modulo_plano && abs(p2) < modulo_plano){
        dcol = _radius/2 - dcol;
        PVector Prepos = PVector.mult(n, dcol);
        _s.add(Prepos);

        float nv = PVector.dot(n, _v);
        PVector vn = PVector.mult(n, nv);
        PVector vt = PVector.sub(_v, vn);
        _v = PVector.mult(PVector.sub(vt, vn), _ps.Cr);
      }
    }  
  } 
  
  void particleCollisionSpringModel(Particle q)
  { 
    if (q._id != _id) {
      PVector dist1 = PVector.sub(q._s, _s);
      PVector dist2 = PVector.sub(_s, q._s);
      float distance = dist1.mag()*2;
      
      if(distance < minDist){
        PVector dir1 = dist1.normalize();
        PVector dir2 = dist2.normalize();

        Felas = PVector.mult(dir1, (minDist-distance)*(-_ps._Ke));  
        _a = PVector.div(Felas, _m);
        _v.add(PVector.mult(_a, SIM_STEP));
        
        q.Felas = PVector.mult(dir2, (minDist-distance)*(-_ps._Ke));  
        q._a = PVector.div(q.Felas, q._m);
        q._v.add(PVector.mult(q._a, SIM_STEP));
      }
    }
  }
  
  void display() 
  {
    strokeWeight(2);
    fill(0,0,0);
    //text(_id,  _s.x, _s.y);
    
    if(_typeStructure == 1)
      fill(_color = grid._colors[grid.getCell(_s)]);
    else if(_typeStructure == 2)
      fill(_color = tablaHash._colors[celdaH]);
    else 
      fill(_color);

    circle(_s.x, _s.y, _radius);
  }
}
