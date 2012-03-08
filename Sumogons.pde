/**
 *  Polygons
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create polygon bodies.
 */

import fisica.*;

Stack states;
FWorld world;
PlayerController[] players;
ArrayList<PolygonController> shapes;
ArrayList<EnemyController> enemies;

int numPlayers = 2;

int numSides = 3;
int minSides = 3;
PVector scale; //Scale of the player & newly spawned debug objects
PVector up;
PVector down;
PVector left;
PVector right;
float scaleAdjustFactor = 0.3; //0.1 for mouse
float movementForce = 1000000;

//Re-using some PVector objects to reduce garbage during calcs in a tight loop
PVector gWorkVectorA;

static final boolean DEBUG = true;

boolean disableEnemyUpdate = false;

void setup() {
  size(1024, 768);
  //smooth();
  
  states = new Stack();
  shapes = new ArrayList<PolygonController>();
  enemies = new ArrayList<EnemyController>();
  scale = new PVector(1,1);
  up = new PVector(0, 1);
  down = new PVector(0, -1);
  left = new PVector(1, 0);
  right = new PVector(-1, 0);
  players = new PlayerController[numPlayers];
  gWorkVectorA = new PVector();

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

  //Begin initial game state
  engineChangeState(new PlayState());
}

/**
 * Listener for Mouse wheel movement
 */
void mouseWheel(int delta) {
  /*
  //println(delta); 
  PlayerController player = players[0];
  Input input = player.getInput();
  //if (input.scaleModKeyDown) {
  //  scale.y += delta * scaleAdjustFactor;
  //} else {
  //  scale.x += delta * scaleAdjustFactor;
  //}
  scale.x += delta * scaleAdjustFactor;
  scale.y += delta * scaleAdjustFactor;
  player.setScale(scale.x, scale.y);
  player.updateShape();
  */
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

PApplet getMainInstance () {
  //Stupid hack because some libraries require a reference to the main PApplet
  return this;
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

void draw() {
  engineGetState().update();
  engineGetState().draw();
}

GameState engineGetState() {
  if (!states.isEmpty()) {
    return (GameState)states.peek(); 
  } else {
    return null;
  }
}

void engineChangeState(GameState state) {
  //Cleanup current state
  if (!states.isEmpty()) {
    GameState currentState = (GameState)states.peek();
    currentState.cleanup();
    states.pop();
  }

  //Store and setup new state
  states.push(state);
  state.setup();
}

void enginePushState(GameState state) {
  //Cleanup current state
  if (!states.isEmpty()) {
    GameState currentState = (GameState)states.peek();
    currentState.pause();
  }

  //Store and setup new state
  states.push(state);
  state.setup();
}

void enginePopState() {
  GameState previousState = null;
  //Cleanup current state
  if (!states.isEmpty()) {
    GameState currentState = (GameState)states.peek();
    currentState.cleanup();
    previousState = currentState;
    states.pop();
  }

  //Resume previous state
  if (!states.isEmpty()) {
    GameState currentState = (GameState)states.peek();
    currentState.resume(previousState);
  }
}

/**
 * Clear the state stack in reverse order, 
 */
void engineResetToState(GameState state) {
  //Empty out current state stack, giving each state a chance to run cleanup()
  if (!states.isEmpty()) {
    for (int i = states.size(); i > 0;) {
      GameState currentState = (GameState)states.peek();
      currentState.cleanup();
      states.pop();
      i = states.size();
    }
  }

  engineChangeState(state);
}
