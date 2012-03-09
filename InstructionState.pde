/**
 * Taken from the Spectrum Game Engine
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class InstructionState extends GameState {
  String message;
  GameState nextState;
  boolean resetStateStack = false;
  color backgroundColor = color(66);
  int verticalOffset = -50;

  InstructionState() {
    nextState = new NewGameState();
  }

  void setup() {
  }

  void draw() {
    smooth();
    background(backgroundColor);
    textAlign(CENTER);
    fill(255);
    textFont(omnesSem48);
    text("SumoGONS!", width/2, 200); 
    textFont(omnesSem29);
    text("Knock the other player's center off the screen 3 times to win.", width/2, (height/2 + verticalOffset)); 
    text("Red moves with arrow keys, changes shape with IJKL keys.", width/2, (height/2 + verticalOffset + 100)); 
    text("Blue moves with WASD keys, changes shape with TFGH keys.", width/2, (height/2 + verticalOffset + 200)); 
    text("Press space to start.", width/2, (height/2 + verticalOffset + 300)); 
  }

  void mousePressed() {
  }

  void goToNextState() {
    if (resetStateStack) {
      engineResetToState(nextState);
    } else {
      engineChangeState(nextState);
    }
  }

  void keyPressed() {
    if ((ENTER == key) ||
        (RETURN == key) ||
        (' ' == key)
      ) {
      goToNextState();
    }
  }
}
