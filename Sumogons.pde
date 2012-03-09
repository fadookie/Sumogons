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
int[] leaderboard;
int[] playerSides;
ArrayList<PolygonController> shapes;
ArrayList<EnemyController> enemies;
PFont omnesSem20;
PFont omnesSem29;
PFont omnesSem48;

int numPlayers = 2;
int maxScore = 3;

int numSides = 3;
int minSides = 3;
PVector scale; //Scale of the player & newly spawned debug objects
PVector up;
PVector down;
PVector left;
PVector right;
float scaleAdjustFactor = 0.3; //0.1 for mouse
float movementForce = 1000000;
float interstitialLengthMs = 1000;

//Re-using some PVector objects to reduce garbage during calcs in a tight loop
PVector gWorkVectorA;

static final boolean DEBUG = false;

boolean disableEnemyUpdate = false;

void setup() {
  size(1024, 768);
  smooth();
  
  states = new Stack();
  shapes = new ArrayList<PolygonController>();
  enemies = new ArrayList<EnemyController>();
  scale = new PVector(1,1);
  up = new PVector(0, 1);
  down = new PVector(0, -1);
  left = new PVector(1, 0);
  right = new PVector(-1, 0);
  players = new PlayerController[numPlayers];
  playerSides = new int[numPlayers];
  gWorkVectorA = new PVector();
  omnesSem20  = loadFont("Omnes-Semibold-20.vlw");
  omnesSem29  = loadFont("Omnes-Semibold-29.vlw");
  omnesSem48  = loadFont("Omnes-Semibold-48.vlw");

  /* //Not using mouse ATM
  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
  }});
  */

  Fisica.init(this);

  //Begin initial game state
  engineChangeState(new InstructionState());
}

/**
 * Listener for Mouse wheel movement
 */
/* //Not using mouse ATM
void mouseWheel(int delta) {
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
}
*/


void mouseDragged() {
  engineGetState().mouseDragged();
}

void mousePressed() {
  engineGetState().mousePressed();
}

void mouseReleased() {
  engineGetState().mouseReleased();
}

void keyPressed() {
  engineGetState().keyPressed();
}

void keyReleased() {
  engineGetState().keyReleased();
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
