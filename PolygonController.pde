class PolygonController {
  Polygon poly;
  FWorld world;
  int numSides;
  float radius;
  PVector scale;

  //Re-using some PVector objects to reduce garbage during calcs in a tight loop
  PVector workVectorA;
  PVector workVectorB;
  PVector workVectorC;
  
  PolygonController(int numSides, float radius) {
    construct(numSides, radius, null);
  }
  
  PolygonController(int numSides, float radius, FWorld world) {
    construct(numSides, radius, world);
  }
  
  void construct(int numSides, float radius, FWorld world) {
    scale = new PVector(1,1);
    workVectorA = new PVector();
    workVectorB = new PVector();
    workVectorC = new PVector();

    this.numSides = numSides;
    this.radius = radius;
    
    if (null != world) {
      setWorld(world);
    }

    this.updateShape(); //Force an update so the shape is valid
  }
  
  void setPosition(float x, float y) {
    poly.setPosition(x, y);
  }

  void setScale(float u) {
    scale.x = u;
    scale.y = u;
  }

  void setScale(float x, float y) {
    scale.x = x;
    scale.y = y;
  }
  
  void setWorld(FWorld world) {
    this.world = world;
  }
  
  void addToWorld() {
    world.add(poly);
    println("added " + this + " to world.");
  }
  
  FPoly getPoly() {
    return poly;
  }
  
  void updateShape() {
    int sideCount = numSides;
    float[][] vertices = new float[sideCount][2]; //[n][0] = x, [n][1] = y
    for (int vertexNum = 0; vertexNum < sideCount; vertexNum++) {
      vertices[vertexNum][0] = radius * cos(2*PI*vertexNum/sideCount);
      vertices[vertexNum][1] = radius * sin(2*PI*vertexNum/sideCount);
    }
    
    if (null != world) {
      world.remove(poly);
    }

    //Build physics object, copy old position+rotation
    poly = new Polygon();
    poly.setStrokeWeight(3);
    poly.setFill(120, 30, 90);
    poly.setDensity(10);
    poly.setRestitution(0.5);
    poly.setSideCount(numSides);

    for (int vertexNum = 0; vertexNum < sideCount; vertexNum++) {
      PVector coords;// = workVectorC;
      float x = vertices[vertexNum][0]; 
      float y = vertices[vertexNum][1];

      //Apply transformations
      //[a c
      // b d]
      workVectorA.x = scale.x; //a
      workVectorA.y = 0; //b

      workVectorB.x = 0; //c
      workVectorB.y = scale.y; //d

      //x(a,b) + y(c,d)
      workVectorA.mult(x);
      workVectorB.mult(y);
      coords = PVector.add(workVectorA, workVectorB); //If this adds too much garbage, try instance .add() on another work vector

      poly.vertex(coords.x, coords.y);
    }
    
    if (null != world) {
      world.remove(poly);
      addToWorld();
    }
  }
}
