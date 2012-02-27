class PlayerController extends PolygonController {
  PVector mousePosition;

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
  }

  void update(float mousex, float mousey) {
    if (null != poly) {
      mousePosition.x = mousex;
      mousePosition.y = mousey;

      PVector pos = getPosition();
      PVector lookAt = PVector.sub(pos, mousePosition); //FIXME: Use workvector placeholders if this creates too much garbage
      lookAt.normalize();
      getHeading(); //update this.heading

      float angleBetween = -PVector.dot(lookAt, heading);

      poly.setAngularVelocity(angleBetween * turnSpeed);

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
        println("heading: " + heading + " headingNormal: " + headingNormal);
      }
    }
  }
}
