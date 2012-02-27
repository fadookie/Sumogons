class EnemyController extends PolygonController {
  float turnSpeed = 4;

  EnemyController(int numSides, float radius) {
    super(numSides, radius);
    construct();
  }
  
  EnemyController(int numSides, float radius, FWorld world) {
    super(numSides, radius, world);
    construct();
  }

  void construct() {
    invincible = false;
  }

  void update() {
    if (null != poly) {
      PVector playerPosition = player.getPosition();

      PVector pos = getPosition();
      PVector lookAt = PVector.sub(pos, playerPosition); //FIXME: Use workvector placeholders if this creates too much garbage
      lookAt.normalize();
      getHeading(); //update this.heading

      float angleBetween = -PVector.dot(lookAt, heading);

      poly.setAngularVelocity(angleBetween * turnSpeed);
    }
  }
}
