abstract class Wave{
  protected PVector tmp;
  
  protected float A, Vp, k, Q, w, L;
  protected PVector D; //Direction or centre
  public int ttl;
  
  public Wave(int t_creacion, float _a, PVector _srcDir, float _L, float _Vp){
    tmp = new PVector();
    ttl = t_creacion;
    Vp = _Vp;
    L = _L;
    A = _a;
    D = _srcDir.copy();
    k = PI * 2 / _L ;
    Q = PI * A * k; //*C/_L; //3 * _a * k;
    w = Vp * k;
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
}

public class WaveRadial extends Wave{
  public WaveRadial(int t_creacion, float _a, PVector _srcDir, float _L, float _Vp){
    super(t_creacion, _a, _srcDir, _L, _Vp);
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    float dist = (sqrt((x - D.x) * (x - D.x) + (z - D.z) * (z - D.z)));

    tmp.set(0, A * exp(-PI*dist/(factor_atenuacion*L)) * cos(k * (dist - time * Vp)), 0);
    return tmp;
  }  
}

public class WaveDirectional extends Wave{  
  public WaveDirectional(int t_creacion, float _a, PVector _srcDir, float _L, float _Vp){
    super(t_creacion, _a, _srcDir, _L, _Vp);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    tmp.set(0, A * sin((D.x * x + D.z * z) * k + time * Vp), 0);
    return tmp;
  }
}

public class WaveGerstner extends Wave{
    public WaveGerstner(int t_creacion, float _a, PVector _srcDir, float _L, float _Vp){
    super(t_creacion, _a, _srcDir, _L, _Vp);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    float dx = Q * A * D.x * cos(k * (D.x * x + D.z * z) + time * Vp);
    float dz = Q * A * D.z * cos(k * (D.x * x + D.z * z) + time * Vp);
    float dy = -A * sin(k * (D.x * x + D.z * z) + time * Vp);
    tmp.set(dx, dy, dz);
    return tmp;
  }
}
