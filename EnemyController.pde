class EnemyController extends PolygonController {
  float turnSpeed = 4;
  float patrolRadius = 5;

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
    super.update();

    if (null != poly) {
      //Patrol
      float velocityX, velocityY;
      velocityX = cos(deltaTime) * patrolRadius * movementForce; //movementCenterX + sin(counter) * moveRadius;
      velocityY = sin(deltaTime) * patrolRadius * movementForce; //movementCenterY + cos(counter) * moveRadius;
      setForce(velocityX, velocityY);
      println(this + " setForce("+velocityX+", "+velocityY+")");

      //Look at the player
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
