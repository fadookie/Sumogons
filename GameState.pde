/**
 * Taken from the Spectrum Game Engine
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class GameState {
  //'Virtual' methods to be overriden in subclasses
  void setup() {
  }

  void cleanup() {
  }

  void pause() {
  }

  void resume(GameState previousState) {
  }

  void update() {
  }

  void draw() {
  }

  void mouseDragged() {
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }

  void keyPressed() {
  }

  void keyReleased() {
  }

}
