class Malla{
  int tipo;
  PVector [][] vert;
  PVector [][] f;
  PVector [][] a;
  PVector [][] v;
  int sx, sy;
  float distDir, distObl;
  float k, mDamping;
  
  // Constructor
  Malla(int t, int x, int y){
    tipo = t;
    sx = x;
    sy = y;
    vert = new PVector[sx][sy];
    a = new PVector[sx][sy];
    v = new PVector[sx][sy];
    f = new PVector[sx][sy];
    distDir = 3;
    distObl = sqrt(2 * distDir * distDir);
    
    switch (tipo){
      case 1:
        k = 400;
        mDamping = 3;
        break;
      case 2:
        k = 150;
        mDamping = 2;
        break;
      case 3:
        k = 300;
        mDamping = 2;
        break;
    }
    
    for(int i = 0; i < sx; i++)
      for(int j = 0; j < sy; j++){
        vert[i][j] = new PVector(i * distDir, j * distDir, 0);
        a[i][j] = new PVector(0, 0, 0);
        v[i][j] = new PVector(0, 0, 0);
        f[i][j] = new PVector(0, 0, 0);
      }
  }
  
  void update(){
    actualizarFuerzas();
    for(int i = 0; i < sx; i++)
      for(int j = 0; j < sy; j++){
        a[i][j].add(f[i][j].x * dt, f[i][j].y * dt, f[i][j].z * dt);
        v[i][j].add(a[i][j].x * dt, a[i][j].y * dt, a[i][j].z * dt);
        vert[i][j].add(v[i][j].x * dt, v[i][j].y * dt, v[i][j].z * dt);
        if((i == 0 && j == 0) || (i == 0 && j == sy - 1)){
          f[i][j].set(0, 0, 0);
          v[i][j].set(0, 0, 0);
          vert[i][j].set(i * distDir, j * distDir, 0);
        }
        a[i][j].mult(0);
      }
  }
  
  void actualizarFuerzas(){
    PVector vDamping = new PVector(0, 0, 0);
    for(int i = 0; i < sx; i++)
      for(int j = 0; j < sy; j++){
        f[i][j].set(0, 0, 0);
        PVector vertexPos = vert[i][j];
        // Fuerzas
        //   Gravedad
        f[i][j] = g;
        
        //   Viento
        PVector fViento = getfViento(vertexPos, i, j);
        f[i][j] = PVector.add(f[i][j], fViento);
        
        //   Internas
        switch(tipo){
          case STRUCTURED:
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-1, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+1, distDir, k));
            break;
          case BEND:
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-1, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+1, distDir, k));
            
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-2, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+2, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-2, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+2, distDir, k));
            break;
          case SHEAR:
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-1, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+1, distDir, k));
            
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j-1, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j+1, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j-1, distDir, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j+1, distDir, k));
            break;
        }
        
        //   Damping
        vDamping.set(v[i][j].x, v[i][j].y, v[i][j].z);
        vDamping.mult(-mDamping);
        f[i][j] = PVector.add(f[i][j], vDamping);
      }
  }
  
  PVector getfViento(PVector v, int i, int j){
    PVector fuerza = new PVector(0, 0, 0);
    PVector normal1 = new PVector(0, 0, 0);
    PVector normal2 = new PVector(0, 0, 0);
    PVector normal3 = new PVector(0, 0, 0);
    PVector normal4 = new PVector(0, 0, 0);
    PVector normal = new PVector(0, 0, 0);
    float proyeccion;
    
    normal1 = getNormal(v, i-1, j, i, j-1);
    normal2 = getNormal(v, i-1, j, i, j+1);
    normal3 = getNormal(v, i, j+1, i+1, j);
    normal4 = getNormal(v, i+1, j, i, j-1);
    
    int cont = 0;
    if(normal1.mag() > 0)
      cont++;
    if(normal2.mag() > 0)
      cont++;
    if(normal3.mag() > 0)
      cont++;
    if(normal4.mag() > 0)
      cont++;
      
    normal = PVector.add(PVector.add(normal1, normal2), PVector.add(normal3, normal2));
    normal.div(cont);
    normal.normalize();
    
    proyeccion = normal.dot(viento);
    fuerza.set(abs(proyeccion * viento.x), proyeccion * viento.y, proyeccion * viento.z);
    return fuerza;
  }
  
  PVector getForce(PVector VertexPos, int i, int j, float m_Distance, float k)
  {
    PVector fuerza = new PVector(0.0, 0.0, 0.0);
    PVector distancia = new PVector(0.0, 0.0, 0.0);
    float elongacion = 0.0;
    
    if (i >= 0 && i < sx && j >= 0 && j < sy) {
      distancia = PVector.sub(VertexPos, vert[i][j]);
      elongacion = distancia.mag() - m_Distance;
      distancia.normalize();
      fuerza = PVector.mult(distancia, -k * elongacion);
    }
    else
      fuerza.set(0.0, 0.0, 0.0);
    
    return fuerza;
  }
  
  void display(){
    noStroke();
    fill(246, 70, 70);
    for(int i = 0; i < sx - 1; i++){
      beginShape(QUAD_STRIP);
      for(int j = 0; j < sy; j++){
        PVector pos1 = vert[i][j];
        PVector pos2 = vert[i+1][j];
        vertex(pos1.x, pos1.y, pos1.z);
        vertex(pos2.x, pos2.y, pos2.z);
      }
      endShape();
    }
  }
  
  PVector getNormal(PVector v, int a, int b, int c, int d){
    PVector n = new PVector(0, 0, 0);
    if(a >= 0 && a <= sx - 1 && b >= 0 && b <= sy - 1 && c >= 0 && c <= sx - 1 && d >= 0 && d <= sy - 1){
      PVector v1 = PVector.sub(vert[a][b], v);
      PVector v2 = PVector.sub(vert[c][d], v);
      n = v1.cross(v2);
    }
    return n;
  }
}
