class PlayerController extends PolygonController {
  PVector mousePosition;
  Input input;
  float turnMagnitude = 135;

  PlayerController(int numSides, float radius) {
    super(numSides, radius);
    construct();
  }
  
  PlayerController(int numSides, float radius, FWorld world) {
    super(numSides, radius, world);
    construct();
  }

  void construct() {
    mousePosition = new PVector();
    invincible = false;
    input = new Input();
  }

  Input getInput() {
    //If better encapsulation / gurantee of non-mutation is needed, change this call to return a copy, eg:
    //return new Input(input);
    return input;
  }
  
  void setInput(Input newInput) {
    input = newInput;
  }

  void update() {
    super.update();

    if (null != poly) {

      //Calculate & apply rotation
      getHeading(); //update this.heading

      poly.setAngularVelocity(input.rotation);

      //Collision detection
      ArrayList<FContact> contacts = poly.getContacts();
      for (FContact c : contacts) {
        EnemyController enemy = findEnemy(c.getBody2());
        if (null == enemy) {
          //That wasn't it, let's try the first body...
          enemy = findEnemy(c.getBody1());
        }
        if (null != enemy) {
          line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
        }
      }
    }
  }

  void draw() {
    getPosition();

    pushStyle();
    fill(0);
    ellipse(position.x, position.y, centerDotRadius, centerDotRadius);
    popStyle();

    if (DEBUG) {
      getHeading();
      getPosition();
      PVector headingNormal = getHeadingNormal();
      pushStyle();
      strokeWeight(2);
      pushStyle();
      stroke(0, 255, 0);
      line(position.x, position.y, position.x + heading.x * 50, position.y + heading.y * 50);
      popStyle();
      pushStyle();
      stroke(255, 0, 0);
      line(position.x, position.y, position.x + headingNormal.x * 50, position.y + headingNormal.y * 50);
      popStyle();
      popStyle();
      //println("heading: " + heading + " headingNormal: " + headingNormal);
    }
  }
}
