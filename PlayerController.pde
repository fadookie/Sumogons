class PlayerController extends PolygonController {
  PVector mousePosition;
  static final float turnSpeed = 7;

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
    }
  }
}
