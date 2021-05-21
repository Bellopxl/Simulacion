abstract class Wave{
  protected PVector tmp;
  
  protected float A, Vp, k, Q, w;
  protected PVector D; //Direction or centre
  
  public Wave(float _a, PVector _srcDir, float _L, float _Vp){
    tmp = new PVector();
    Vp = _Vp;
    A = _a;
    D = _srcDir.copy();
    k = PI * 2 / _L;
    Q = PI * A * k; //*C/_L; //3 * _a * k;
    w = Vp * k;
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
}

public class WaveRadial extends Wave{
  public WaveRadial(float _a, PVector _srcDir, float _L, float _Vp){
    super(_a, _srcDir, _L, _Vp);
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    float dist = (sqrt((x - D.x) * (x - D.x) + (z - D.z) * (z - D.z)));
    tmp.set(0, A * cos(k * (dist - time * Vp)), 0);
    return tmp;
  }  
}

public class WaveDirectional extends Wave{  
  public WaveDirectional(float _a, PVector _srcDir, float _L, float _Vp){
    super(_a, _srcDir, _L, _Vp);
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    tmp.set(0, A * sin((D.x * x + D.z * z) * k + time * Vp), 0);
    return tmp;
  }
}

public class WaveGerstner extends Wave{
    public WaveGerstner(float _a, PVector _srcDir, float _L, float _Vp){
    super(_a, _srcDir, _L, _Vp);
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
