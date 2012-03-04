class EnemyController extends PolygonController {
  float turnSpeed = 4;
  float patrolRadius = 5;

  Path path;
  int nextPathNodeIndex = 0;
  static final float targetNodeDistance = 150.0;
  float enemyMovementForce;

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
    enemyMovementForce = movementForce / 350;
    path = new Path();
    path.add(new PVector(0, height/2));
    path.add(new PVector(width/2, height));
    path.add(new PVector(width, height/2));
    path.add(new PVector(width/2, 0));
  }

  void update() {
    super.update();


    if (null != poly) {
      PVector pos = getPosition();

      //Patrol
      if (path.size() > 0) {
        PVector nextNode = path.get(nextPathNodeIndex);
        if (null != nextNode) {
          //Figure out where we're going
          PVector moveVector = PVector.sub(nextNode, pos);
          float distanceToNode = moveVector.mag();

          //Amplify & apply movement force
          moveVector.mult(enemyMovementForce);
          setForce(moveVector.x, moveVector.y);

          //If we're close enough to this node, switch to the next one.
          if (distanceToNode <= targetNodeDistance) {
            nextPathNodeIndex++;
            if (!(nextPathNodeIndex < path.size())) {
              //Loop back to beginning of path
              nextPathNodeIndex = 0;
            }
          }
        }
      }

      //Look at the player
      PVector playerPosition = player.getPosition();

      PVector lookAt = PVector.sub(pos, playerPosition); //FIXME: Use workvector placeholders if this creates too much garbage
      lookAt.normalize();
      getHeading(); //update this.heading

      float angleBetween = -PVector.dot(lookAt, heading);

      //poly.setAngularVelocity(angleBetween * turnSpeed);
    }

  }

  void drawPath() {
    path.draw();
  }
}
