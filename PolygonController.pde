class PolygonController {
  Polygon poly;
  FWorld world;
  int numSides;
  float radius;
  
  PolygonController(int numSides, float radius) {
    construct(numSides, radius, null);
  }
  
  PolygonController(int numSides, float radius, FWorld world) {
    construct(numSides, radius, world);
  }
  
  void construct(int numSides, float radius, FWorld world) {
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
    
    //Apply transformations here
    
    //Build physics object, copy old position+rotation
    poly = new Polygon();
    poly.setStrokeWeight(3);
    poly.setFill(120, 30, 90);
    poly.setDensity(10);
    poly.setRestitution(0.5);
    poly.setSideCount(numSides);
    for (int vertexNum = 0; vertexNum < sideCount; vertexNum++) {
      poly.vertex(vertices[vertexNum][0], vertices[vertexNum][1]);
    }
    
    if (null != world) {
      addToWorld();
    }
  }
}
