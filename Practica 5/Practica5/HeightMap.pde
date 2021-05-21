public class HeightMap{
  private final int mapSizeX;
  private final int mapSizeY;
  private final float cellSize;
  
  private float initPos[][][];
  private float pos[][][];
  private float text[][][];
  protected ArrayList<Wave> waves;
  private Wave waveArray[];
  
  public HeightMap(int m_size_x, int m_size_y, float c_size){
    mapSizeX = m_size_x;
    mapSizeY = m_size_y;
    cellSize = c_size;
    
    initGridPositions();
    initTextValues();
    
    waves = new ArrayList<Wave>();
    waveArray = new Wave[0];   
  }
  
  private void initGridPositions(){
    float startPosX = -mapSizeX * cellSize / 2;
    float startPosY = -mapSizeY * cellSize / 2;
    pos = new float[mapSizeX][mapSizeY][3];
    initPos = new float[mapSizeX][mapSizeY][3];
    
    for(int i = 0; i < mapSizeX; i++){
      for(int j = 0; j < mapSizeY; j++){
        pos[i][j][0] = startPosX + j * cellSize;
        pos[i][j][1] = 0;
        pos[i][j][2] = startPosY + i * cellSize;
        
        initPos[i][j][0] = pos[i][j][0];
        initPos[i][j][1] = pos[i][j][1];
        initPos[i][j][2] = pos[i][j][2];
      }
    }
  }
  
  private void initTextValues(){
    text = new float[mapSizeX][mapSizeY][2];
    
    for(int i = 0; i < mapSizeX; i++){
      for(int j = 0; j < mapSizeY; j++){
        text[i][j][0] = img.width / mapSizeX * i;
        text[i][j][1] = img.height / mapSizeY * j;
      }
    }
  }
  
  public void update(){
    //Pass arraylist to array to iterate quicker
    waveArray = waves.toArray(waveArray);
    //Declarations
    int leng = waveArray.length;
    PVector variation;
    
    //Iterate over arrays
    for(int i = 0; i < mapSizeX; i++){
      for(int j = 0; j < mapSizeY; j++){
        //Reset positions
        pos[i][j][0] = initPos[i][j][0];
        pos[i][j][1] = initPos[i][j][1];
        pos[i][j][2] = initPos[i][j][2];
        
        //Iterate trough waves
        for(int k = 0; k < leng; k++){
          variation = waveArray[k].getVariation(pos[i][j][0], pos[i][j][1], pos[i][j][2], _elapsedTime);
          pos[i][j][0] += variation.x;
          pos[i][j][1] += variation.y;
          pos[i][j][2] += variation.z;        
        }
      }
    }
    display();
  }
  
  public void addWave(Wave ola){
    waves.add(ola);
  }
  
  public void clearWaves(){
    waves.clear();
    waveArray = new Wave[0];
  }
  
  public void display() {     
    for(int i = 0; i < mapSizeX-1; i++){     
      beginShape(QUAD_STRIP);
      if (!_viewmode){
        noStroke();
        texture(img);
      }
      else if (_viewmode) {
        stroke(0);
        fill(255,255,255);
        strokeWeight(1);
      }
        for(int j = 0; j < mapSizeY-1; j++){
          if ((pos[i][j] != null) && (pos[i+1][j] != null)){
            vertex(pos[i][j][0],pos[i][j][1],pos[i][j][2], text[i][j][0], text[i][j][1]);
            vertex(pos[i+1][j][0],pos[i+1][j][1],pos[i+1][j][2], text[i+1][j][0], text[i][j][1]); 
          }
        }
      endShape();
    }
  }
}
