/**
 * Taken from the Spectrum Game Engine
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class InterstitialState extends GameState {
  String message;
  GameState nextState;
  boolean resetStateStack = false;
  color backgroundColor = color(66);
  int verticalOffset = -50;
  float displayLengthMs = -1;
  float displayStartMs = 0;

  InterstitialState(String _message, GameState _nextState) {
    super();
    message = _message;
    nextState = _nextState;
  }

  InterstitialState(String _message, GameState _nextState, float _displayLengthMs) {
    super();
    message = _message;
    nextState = _nextState;
    displayLengthMs = _displayLengthMs;
  }

  InterstitialState(String _message, GameState _nextState, int _verticalOffset) {
    super();
    message = _message;
    nextState = _nextState;
    verticalOffset = _verticalOffset;
  }

  InterstitialState(String _message, GameState _nextState, boolean _resetStateStack) {
    super();
    message = _message;
    nextState = _nextState;
    resetStateStack = _resetStateStack;
  }

  InterstitialState(String _message, GameState _nextState, boolean _resetStateStack, color _backgroundColor) {
    super();
    message = _message;
    nextState = _nextState;
    resetStateStack = _resetStateStack;
    backgroundColor = _backgroundColor;
  }

  void setup() {
  }

  void update() {
    if (displayLengthMs >= 0) {
      if (displayStartMs == 0) {
        displayStartMs = millis(); //Set timer
      } else {
        if((millis() - displayStartMs) > displayLengthMs) {
          //Timer's up, close this message
          goToNextState();
        }
      }
    }
  }

  void draw() {
    smooth();
    background(backgroundColor);
    textFont(omnesSem48);
    textAlign(CENTER);
    fill(255);
    text(message, width/2, (height/2 + verticalOffset)); 
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
