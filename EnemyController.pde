class EnemyController extends PolygonController {
  float turnSpeed = 4;
  float patrolRadius = 5;
  Path path;

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
    path = new Path();
    path.add(new PVector(0, height/2));
    path.add(new PVector(width/2, height));
    path.add(new PVector(width, height/2));
    path.add(new PVector(width/2, 0));
    path.add(new PVector(0, height/2));
  }

  void update() {
    super.update();

    if (null != poly) {
      //Patrol
      float velocityX, velocityY;
      velocityX = cos(deltaTime) * patrolRadius * (movementForce / 2); //movementCenterX + sin(counter) * moveRadius;
      velocityY = sin(deltaTime) * patrolRadius * (movementForce / 2); //movementCenterY + cos(counter) * moveRadius;
      setForce(velocityX, velocityY);
      //println(this + " setForce("+velocityX+", "+velocityY+")");

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

  void drawPath() {
    path.draw();
  }
}
