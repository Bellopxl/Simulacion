class HashTable 
{
  ArrayList<ArrayList<Particle>> _table;
  
  int _numCells;
  float _cellSize;
  color[] _colors;
  
  HashTable(int numCells, float cellSize) 
  {
    _table = new ArrayList<ArrayList<Particle>>();
    
    _numCells = numCells; 
    _cellSize = cellSize;

    _colors = new color[_numCells];
    
    for (int i = 0; i < _numCells; i++)
    {
      ArrayList<Particle> cell = new ArrayList<Particle>();
      _table.add(cell);
      _colors[i] = color(int(random(0,256)), int(random(0,256)), int(random(0,256)));
    }
  }
  
  int hash(PVector pos) {
    long xd = int(floor(pos.x/_cellSize));
    long yd = int(floor(pos.y/_cellSize));
    long suma = 73856093 * xd + 19349663 * yd;
    int cell = int(suma % _numCells);

    if (cell < 0) {
      cell += _numCells;
    }

    return cell;
  }
  
  int insertar(PVector pos, Particle p) {
    getCell(pos).add(p);
    
    return hash(pos);
  }
  
  void borrado(){
    for (int i = 0; i < _numCells; i++)
    {
      _table.get(i).clear();
    }
  }
  
  ArrayList getCell(PVector pos) {
    int c = hash(pos);
    
    return _table.get(c);
  } 
  
  ArrayList getVecinos(PVector pos) {
    ArrayList<Particle> L = new ArrayList<Particle>();     
    L.addAll(getCell(pos));
     
    for (int i = 0; i < 8; i++) {
      PVector nPos = new PVector(pos.x + _cellSize * cos(QUARTER_PI * i), pos.y + _cellSize * sin(QUARTER_PI * i));
      L.addAll(getCell(nPos));
    }
     
    return L; //<>//
  }
}
