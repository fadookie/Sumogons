/**
 *  Polygons
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create polygon bodies.
 */

import fisica.*;

FWorld world;
PlayerController[] players;
ArrayList<PolygonController> shapes;
ArrayList<EnemyController> enemies;

int numPlayers = 2;

int numSides = 3;
int minSides = 3;
PVector scale; //Scale of the player & newly spawned debug objects
PVector up;
float scaleAdjustFactor = 0.1;
float movementForce = 1000000;

static final boolean DEBUG = true;

boolean disableEnemyUpdate = false;

void setup() {
  size(1024, 768);
  //smooth();
  
  shapes = new ArrayList<PolygonController>();
  enemies = new ArrayList<EnemyController>();
  scale = new PVector(1,1);
  up = new PVector(0, 1);
  players = new PlayerController[numPlayers];

  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
  }}); 

  Fisica.init(this);

  //Make the world
  world = new FWorld();
  world.setGrabbable(DEBUG); //Only allow mouse grabbing in debug mode
  world.setGravity(0, 0);
  world.setEdges();
  //world.remove(world.left);
  //world.remove(world.right);
  //world.remove(world.top);
  world.setEdgesRestitution(0.5);

  {
    //Make player 0
    PlayerController player = new PlayerController(numSides, 50.0, world);
    player.setPosition(width / 2, height / 2);
    player.setScale(scale.x, scale.y);
    player.setFill(new PVector(255, 0, 0));
    player.updateShape();

    Input input = player.getInput();

    input.CENTER_KEY = new Key('/');
    input.UP_KEY = new Key(UP, true);
    input.DOWN_KEY = new Key(DOWN, true);
    input.LEFT_KEY = new Key(LEFT, true);
    input.RIGHT_KEY = new Key(RIGHT, true);
    input.SCALE_MOD_KEY = new Key(ALT, true);

    player.setInput(input);

    players[0] = player;
  }

  {
    //Make player 1
    PlayerController player = new PlayerController(numSides, 50.0, world);
    player.setPosition((width / 2) + 100, (height / 2) + 100);
    player.setScale(scale.x, scale.y);
    player.setFill(new PVector(0, 0, 255));
    player.updateShape();

    Input input = player.getInput();

    input.CENTER_KEY = new Key('c');
    input.UP_KEY = new Key('w');
    input.DOWN_KEY = new Key('s');
    input.LEFT_KEY = new Key('a');
    input.RIGHT_KEY = new Key('d');
    input.SCALE_MOD_KEY = new Key(SHIFT, true);

    player.setInput(input);

    players[1] = player;
  }

  //Make an enemy
  EnemyController enemy = new EnemyController(3, 50.0, world);
  enemy.setPosition(width/3, height/3);
  enemy.updateShape();
  enemies.add(enemy);
}

void draw() {
  background(255);

  world.step();
  world.draw(this);  

  //Debug draw
  if (DEBUG) {
    for (EnemyController enemy : enemies) {
      enemy.drawPath();
    }
  }

  //Set movement forces
  float xForce = 0;
  float yForce = 0;

  for (PlayerController player : players) {
    Input input = player.getInput();

    if (input.upKeyDown) {
      yForce = -movementForce;
    } else if (input.downKeyDown) {
      yForce = movementForce;
    }

    if (input.rightKeyDown) {
      xForce = movementForce;
    } else if (input.leftKeyDown) {
      xForce = -movementForce;
    }

    if (input.centerKeyDown) {
      player.resetScale();
      player.updateShape();

      //For debugging
      scale.x = 1;
      scale.y = 1;
    }

    player.setRelativeForce(xForce, yForce);
    player.update(mouseX, mouseY);
  }

  if (!disableEnemyUpdate) {
    for (EnemyController enemy : enemies) {
      enemy.update();
    }
  }

}

/**
 * Listener for Mouse wheel movement
 */
void mouseWheel(int delta) {
  //println(delta); 
  PlayerController player = players[0];
  Input input = player.getInput();
  if (input.scaleModKeyDown) {
    scale.y += delta * scaleAdjustFactor;
  } else {
    scale.x += delta * scaleAdjustFactor;
  }
  player.setScale(scale.x, scale.y);
  player.updateShape();
}

void keyPressed() {
  Key k = new Key(key, keyCode);
  //println("Key pressed - " + k);

  for (PlayerController player : players) {
    Input input = player.getInput();
    input.keyPressed(k);
    player.setInput(input);
  }

  if (CODED == key) {
  } else {
    //DEBUG keys
    if (DEBUG) {
      if ('p' == key) {
          disableEnemyUpdate = !disableEnemyUpdate;
          println(disableEnemyUpdate);
      } else if ('=' == key) {
        numSides++;
        println("numSides = " + numSides);
      } else if ('-' == key) {
        numSides--;
        numSides = constrain(numSides, minSides, 999);
        println("numSides = " + numSides);
      } else if ('+' == key) { //Shift +
        scale.x += scaleAdjustFactor; 
        println("scale.x = " + scale.x);
      } else if ('_' == key) { //Shift =
        scale.x -= scaleAdjustFactor; 
        println("scale.x = " + scale.x);
      } else if ('0' == key) {
        PolygonController poly = new PolygonController(numSides, 50.0, world);
        poly.setPosition(mouseX, mouseY);
        poly.setWorld(world);
        poly.setScale(scale.x, scale.y);
        poly.updateShape();
        shapes.add(poly);
      } else if (key == BACKSPACE) {
        FBody hovered = world.getBody(mouseX, mouseY);
        if ( hovered != null &&
             hovered.isStatic() == false ) {
          //Destroy the body and PolygonController
          world.remove(hovered);

          PolygonController hoveredController = null;
          for (PolygonController p : shapes) {
            if (hovered == p.getPoly()) {
              hoveredController = p;
              break;
            }
          }
          if (null != hoveredController) {
            shapes.remove(hoveredController);
          }
        }
      }
    } 
  }
}

EnemyController findEnemy(FBody b) {
  for (EnemyController enemy : enemies) {
    if (enemy.getPoly() == b) {
      return enemy;
    }
  }
  return null;
}

void keyReleased() {
  Key k = new Key(key, keyCode);

  for (PlayerController player : players) {
    Input input = player.getInput();
    input.keyReleased(k);
    player.setInput(input);
  }
}
