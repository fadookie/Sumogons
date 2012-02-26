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

      //see http://www.euclideanspace.com/maths/algebra/vectors/angleBetween/index.htm
      float angle = atan2(lookAt.y, lookAt.x) - atan2(up.y, up.x);
      poly.setRotation(angle);
      println ("angle: " + angle);
    }
  }
}
