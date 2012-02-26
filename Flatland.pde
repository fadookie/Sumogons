/**
 *  Polygons
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create polygon bodies.
 */

import fisica.*;

FWorld world;
PolygonController poly;
ArrayList<PolygonController> shapes;
int numSides = 3;
int minSides = 3;

void setup() {
  size(800, 600);
  smooth();
  
  shapes = new ArrayList<PolygonController>();

  Fisica.init(this);

  world = new FWorld();
  world.setGravity(0, 800);
  world.setEdges();
  world.remove(world.left);
  world.remove(world.right);
  world.remove(world.top);
  
  world.setEdgesRestitution(0.5);
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


void mousePressed() {
//  if (world.getBody(mouseX, mouseY) != null) {
//    return;
//  }

  poly = new PolygonController(numSides, 50.0, world);
  poly.setPosition(mouseX, mouseY);
  poly.setWorld(world);
  shapes.add(poly);
  //poly.vertex(mouseX, mouseY);
}

void mouseDragged() {
}

void mouseReleased() {
}

void keyPressed() {
  if ('=' == key) {
    numSides++;
    println("numSides = " + numSides);
  } else if ('-' == key) {
    numSides--;
    numSides = constrain(numSides, minSides, 999);
    println("numSides = " + numSides);
  } else if (key == BACKSPACE) {
    FBody hovered = world.getBody(mouseX, mouseY);
    if ( hovered != null &&
         hovered.isStatic() == false ) {
      world.remove(hovered);
    }
  } 
  else {
    try {
      saveFrame("screenshot.png");
    } 
    catch (Exception e) {
    }
  }
}




