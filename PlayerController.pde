class PlayerController extends PolygonController {
  PVector mousePosition;
  Input input;

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

  void update(float mousex, float mousey) {
    super.update();

    if (null != poly) {

      //Calculate & apply rotation
      mousePosition.x = mousex;
      mousePosition.y = mousey;

      PVector pos = getPosition();
      PVector lookAt = PVector.sub(pos, mousePosition); //FIXME: Use workvector placeholders if this creates too much garbage
      lookAt.normalize();
      getHeading(); //update this.heading

      float angleBetween = -PVector.dot(lookAt, heading);

      poly.setAngularVelocity(angleBetween * turnSpeed);

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
}
