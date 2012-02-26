/**
 *  Polygons
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create polygon bodies.
 */

import fisica.*;

FWorld world;
PolygonController player;
ArrayList<PolygonController> shapes;
int numSides = 3;
int minSides = 3;
PVector scale;
float scaleAdjustFactor = 0.1;
boolean shiftDown = false;

void setup() {
  size(800, 600);
  smooth();
  
  shapes = new ArrayList<PolygonController>();
  scale = new PVector(1,1);

  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
  }}); 

  Fisica.init(this);

  world = new FWorld();
  world.setGravity(0, 0);
  world.setEdges();
  //world.remove(world.left);
  //world.remove(world.right);
  //world.remove(world.top);
  
  world.setEdgesRestitution(0.5);

  player = new PolygonController(numSides, 50.0, world);
  player.setPosition(width / 2, height / 2);
  player.setWorld(world);
  player.setScale(scale.x, scale.y);
  player.updateShape();
  shapes.add(player);
}

void draw() {
  background(255);

  world.step();
  world.draw(this);  

  //FIXME: Shouldn't need to do this.
  for(PolygonController p : shapes) {
    p.getPoly().draw(this);
  }
}

/**
 * Listener for Mouse wheel movement
 */
void mouseWheel(int delta) {
  println(delta); 
  if (shiftDown) {
    scale.y += delta * scaleAdjustFactor;
  } else {
    scale.x += delta * scaleAdjustFactor;
  }
  player.setScale(scale.x, scale.y);
  player.updateShape();
}

void keyPressed() {
  if (CODED == key) {
    if (SHIFT == keyCode) {
      shiftDown = true;
    }
  } else {
    if ('=' == key) {
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

void keyReleased() {
  if (CODED == key) {
    if (SHIFT == keyCode) {
      shiftDown = false;
    }
  }
}




