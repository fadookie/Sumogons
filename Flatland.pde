/**
 *  Polygons
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create polygon bodies.
 */

import fisica.*;

FWorld world;
PlayerController player;
ArrayList<PolygonController> shapes;
int numSides = 3;
int minSides = 3;
PVector scale;
PVector up;
float scaleAdjustFactor = 0.1;
float movementForce = 1000000;

boolean scaleModKeyDown = false;
boolean upKeyDown = false;
boolean downKeyDown = false;
boolean leftKeyDown = false;
boolean rightKeyDown = false;

static final char CENTER_KEY = 'c';
static final char UP_KEY = 'w';
static final char DOWN_KEY = 's';
static final char LEFT_KEY = 'a';
static final char RIGHT_KEY = 'd';
static final char SCALE_MOD_KEY = SHIFT;

void setup() {
  size(1024, 768);
  smooth();
  
  shapes = new ArrayList<PolygonController>();
  scale = new PVector(1,1);
  up = new PVector(0, 1);

  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
  }}); 

  Fisica.init(this);

  //Make the world
  world = new FWorld();
  world.setGrabbable(false);
  world.setGravity(0, 0);
  world.setEdges();
  //world.remove(world.left);
  //world.remove(world.right);
  //world.remove(world.top);
  world.setEdgesRestitution(0.5);

  //Make the player
  player = new PlayerController(numSides, 50.0, world);
  player.setPosition(width / 2, height / 2);
  player.setScale(scale.x, scale.y);
  player.updateShape();

  //Make an enemy
  EnemyController enemy = new EnemyController(6, 50.0, world);
  enemy.setPosition(width/3, height/3);
  enemy.updateShape();
}

void draw() {
  background(255);

  world.step();
  world.draw(this);  

  //Set movement forces
  float xForce = 0;
  float yForce = 0;

  if (upKeyDown) {
    yForce = -movementForce;
  } else if (downKeyDown) {
    yForce = movementForce;
  }

  if (rightKeyDown) {
    xForce = movementForce;
  } else if (leftKeyDown) {
    xForce = -movementForce;
  }

  player.setForce(xForce, yForce);
  player.update(mouseX, mouseY);
}

/**
 * Listener for Mouse wheel movement
 */
void mouseWheel(int delta) {
  //println(delta); 
  if (scaleModKeyDown) {
    scale.y += delta * scaleAdjustFactor;
  } else {
    scale.x += delta * scaleAdjustFactor;
  }
  player.setScale(scale.x, scale.y);
  player.updateShape();
}

void keyPressed() {
  if (CODED == key) {
    if (SCALE_MOD_KEY == keyCode) {
      scaleModKeyDown = true;
    }
  } else {
    if (UP_KEY == key) {
      upKeyDown = true;
    } else if (DOWN_KEY == key) {
      downKeyDown = true;
    } else if (LEFT_KEY == key) {
      leftKeyDown = true;
    } else if (RIGHT_KEY == key) {
      rightKeyDown = true;
    } else if (CENTER_KEY == key) {
      scale.x = 1;
      scale.y = 1;
      player.resetScale();
      player.updateShape();
      //println("resetting scale");

    //DEBUG keys
    } else if ('=' == key) {
      numSides++;
      player.setNumSides(numSides);
      player.updateShape();
      println("numSides = " + numSides);
    } else if ('-' == key) {
      numSides--;
      numSides = constrain(numSides, minSides, 999);
      player.setNumSides(numSides);
      player.updateShape();
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

void keyReleased() {
  if (CODED == key) {
    if (SHIFT == keyCode) {
      scaleModKeyDown = false;
    }
  } else {
    if (UP_KEY == key) {
      upKeyDown = false;
    } else if (DOWN_KEY == key) {
      downKeyDown = false;
    } else if (LEFT_KEY == key) {
      leftKeyDown = false;
    } else if (RIGHT_KEY == key) {
      rightKeyDown = false;
    }
  }
}
