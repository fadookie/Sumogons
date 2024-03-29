class PolygonController {
  Polygon poly;
  FWorld world;
  int numSides;
  float radius;
  PVector defaultScale;
  PVector scale;
  PVector position;
  PVector heading;
  float turnSpeed = 7;
  boolean invincible = true;
  int health = 50;
  PVector fillColor;
  String tag;
  static final float centerDotRadius = 3;
  boolean isStatic = false;
  float density = 10;

  /** Time delta since last update in milliseconds */
  float deltaTime = 0; 
  /** Time of last update in milliseconds */
  float lastUpdate = 0;

  static final float polyCalcRotationOffset = -1.5707964; //Rotation offset when creating the polygon so it 'points' at the cursor. -1.5707964 rads = -90 degrees.
  static final float scaleLimit = 0.02; //The distance the scale on any axis is allowed to be from 0, if it gets too close to 0 it causes the physics engine to glitch

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
    defaultScale = new PVector(1,1);
    scale = new PVector(1,1);
    position = new PVector();
    heading = new PVector();
    fillColor = new PVector(120, 30, 90);

    workVectorA = new PVector();
    workVectorB = new PVector();
    workVectorC = new PVector();

    this.numSides = numSides;
    this.radius = radius;
    
    if (null != world) {
      setWorld(world);
    }
  }
  
  void setPosition(float x, float y) {
    position.x = x;
    position.y = y;

    if (null != poly) {
      poly.setPosition(x, y);
    }
  }

  PVector getPosition() {
    if (null != poly) {
      position.x = poly.getX();
      position.y = poly.getY();
    }
    return position;
  }

  PVector getHeading() {
    if (null != poly) {
      float rotation = poly.getRotation();
      heading.x = cos(rotation);
      heading.y = sin(rotation);
    }
    return heading;
  }

  PVector getHeadingNormal() {
    return PMath.rotatePVector2D(heading, radians(90));
  }

  void setNumSides(int n) {
    numSides = n;
  }

  PVector getScale() {
    return scale.get();
  }
  void resetScale() {
    setScale(defaultScale.x, defaultScale.y);
  }

  void setScale(float u) {
    setScale(u, u);
  }

  void setScale(float x, float y) {
    float aspectRatio = x / y;
    //println("scaleX: " + x + " scaleY: " + y + " aspectRatio: " + aspectRatio);
    if (
        isFurtherThan(aspectRatio, 0, scaleLimit)
        && (aspectRatio < 33)
        && (aspectRatio > -33)
    ) {
      //println ("scale good.");
      scale.x = x;
      scale.y = y;
    }
  }

  boolean isFurtherThan(float a, float b, float range) {
    return (abs(a - b) > range);
  }

  void setForce(float fx, float fy) {
    poly.setForce(fx, fy);
  }

  void setRelativeForce(float fx, float fy) {
    PVector headingNormal = getHeadingNormal();
    getHeading();
    //Apply transformations
    //[a c
    // b d]
    workVectorA.x = heading.x; //a
    workVectorA.y = heading.y; //b

    workVectorB.x = headingNormal.x; //c
    workVectorB.y = headingNormal.y; //d

    //x(a,b) + y(c,d)
    workVectorA.mult(fx);
    workVectorB.mult(fy);
    PVector force = PVector.add(workVectorA, workVectorB); //If this adds too much garbage, try instance .add() on another work vector

    poly.setForce(force.x, force.y);
  }
  
  void setWorld(FWorld world) {
    this.world = world;
  }

  void setStatic(boolean s) {
    isStatic = s;
  }
  
  void addToWorld() {
    world.add(poly);
    //println("added " + this + " to world.");
  }

  //Workaround for color passing to fisica being buggy
  void setFill(PVector newColor) {
    fillColor = newColor;
  }
  
  FPoly getPoly() {
    return poly;
  }

  boolean isInvincible() {
    return invincible;
  }
  
  void setDensity(float _density) {
    density = _density;
  }
  /**
   * You MUST call updateShape before the new PolygonController is usable.
   */
  void updateShape() {
    int sideCount = numSides;
    float[][] vertices = new float[sideCount][2]; //[n][0] = x, [n][1] = y

    //Create an array of cartesian coords for a regular polygon of n sides
    //See http://stackoverflow.com/questions/7198144/how-to-draw-a-n-sided-regular-polygon-in-cartesian-coordinates
    for (int vertexNum = 0; vertexNum < sideCount; vertexNum++) {
      vertices[vertexNum][0] = radius * cos(2*PI*vertexNum/sideCount + polyCalcRotationOffset);
      vertices[vertexNum][1] = radius * sin(2*PI*vertexNum/sideCount + polyCalcRotationOffset);
    }
    
    Polygon oldPoly = poly;

    //Build new physics body
    poly = new Polygon();
    poly.setBullet(true);
    poly.setStrokeWeight(3);
    poly.setFill(fillColor.x, fillColor.y, fillColor.z);
    poly.setDensity(density);
    poly.setRestitution(0.5);
    poly.setStatic(isStatic);
    if (null != oldPoly) {
      //Copy the physics properties that are likely to be different from the old body.
      PVector oldPosition = workVectorC;
      oldPosition.x = oldPoly.getX();
      oldPosition.y = oldPoly.getY();
      
      if ((oldPosition.x == 0) && (oldPosition.y == 0)) {
        oldPosition = position;
      }

      poly.setPosition(oldPosition.x, oldPosition.y);
      //println("oldPosition: " + oldPoly.getX() + ", " + oldPoly.getY());
      poly.setRotation(oldPoly.getRotation());
      poly.setAngularVelocity(oldPoly.getAngularVelocity());
      poly.setForce(oldPoly.getForceX(), oldPoly.getForceY());
      poly.setVelocity(oldPoly.getVelocityX(), oldPoly.getVelocityY());
    } else {
      //No old body, use caller supplied position or default
      poly.setPosition(position.x, position.y);
    }
    poly.setSideCount(numSides);

    for (int vertexNum = 0; vertexNum < sideCount; vertexNum++) {
      PVector coords;
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
      world.remove(oldPoly);
      addToWorld();
    }
  }

  void update() {
    float ms = millis();
    deltaTime = ms - lastUpdate;
    lastUpdate = ms;
  }

  void draw() {
  }

  String toString() {
    if (null != tag) {
      return tag;
    } else {
      return super.toString();
    }
  }
}
