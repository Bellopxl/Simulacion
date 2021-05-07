class Grid 
{
  ArrayList<ArrayList<Particle>> _cells;
  
  int _nRows; 
  int _nCols; 
  int _numCells;
  float _cellSize;
  color[] _colors;
  
  Grid(int rows, int cols) 
  {
    _cells = new ArrayList<ArrayList<Particle>>();
    
    _nRows = rows;
    _nCols = cols;
    _numCells = _nRows*_nCols;
    _cellSize = width/_nCols;
    
    _colors = new color[_numCells];
    
    for (int i = 0; i < _numCells; i++) 
    {
      _cells.add(new ArrayList<Particle>());
      _colors[i] = color(int(random(0,256)), int(random(0,256)), int(random(0,256)));
    }
  }
 
  int insertar(PVector pos, Particle p) {
    PVector index = new PVector(floor(pos.x / _cellSize),floor(pos.y / _cellSize)) ;
    int cell = _nRows * int(index.y) + int(index.x);
     
    if (cell >= 0 && cell <= _numCells - 1) {
      _cells.get(cell).add(p);
    }
     
    return cell;
  }
  
  int getCell(PVector pos){
    PVector index = new PVector(floor(pos.x / _cellSize),floor(pos.y / _cellSize)) ;
    int cell = _nRows * int(index.y) + int(index.x);
    if (cell < 0) {
      cell += _numCells;
    }
    else if(cell > _numCells-1){
      cell -= _numCells;
    }
    return cell;
  }
  
  void borrado(){
    for (int i = 0; i < _numCells; i++)
    {
      _cells.get(i).clear();
    }
  }
   
  ArrayList getVecinos(PVector pos) {
    ArrayList<Particle> L = new ArrayList<Particle>();
    PVector index = new PVector(floor(pos.x / _cellSize),floor(pos.y / _cellSize)) ;
    int cell;
     
    for (int i = int(index.x)-1; i <= int(index.x)+1; i++) {
      for (int j = int(index.y)-1; j <= int(index.y)+1; j++) {
        cell = _nCols * j + i;
        if (cell >= 0 && cell <= _numCells - 1) {
          L.addAll(_cells.get(cell));
        }
      }
    }
     
    return L;
  }
}
