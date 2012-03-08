class Input {
  boolean useMouse = false;

  boolean centerKeyDown = false;
  boolean upKeyDown = false;
  boolean downKeyDown = false;
  boolean leftKeyDown = false;
  boolean rightKeyDown = false;
  boolean turnLeftKeyDown = false;
  boolean turnRightKeyDown = false;
  boolean scaleModKeyDown = false;

  PVector heading;

  Key CENTER_KEY;
  Key UP_KEY;
  Key DOWN_KEY;
  Key LEFT_KEY;
  Key RIGHT_KEY;
  Key SCALE_MOD_KEY;
  Key TURN_LEFT_KEY;
  Key TURN_RIGHT_KEY;

  Input() {
    heading = up.get();
    CENTER_KEY = new Key();
    UP_KEY = new Key();
    DOWN_KEY = new Key();
    LEFT_KEY = new Key();
    RIGHT_KEY = new Key();
    SCALE_MOD_KEY = new Key();
    TURN_LEFT_KEY = new Key();
    TURN_RIGHT_KEY = new Key();
  }

  Input(Input otherInput) {
    scaleModKeyDown = otherInput.scaleModKeyDown;
    upKeyDown = otherInput.upKeyDown;
    downKeyDown = otherInput.downKeyDown;
    leftKeyDown = otherInput.leftKeyDown;
    rightKeyDown = otherInput.rightKeyDown;
    turnLeftKeyDown = otherInput.turnLeftKeyDown;
    turnRightKeyDown = otherInput.turnRightKeyDown;

    CENTER_KEY = otherInput.CENTER_KEY;
    UP_KEY = otherInput.UP_KEY;
    DOWN_KEY = otherInput.DOWN_KEY;
    LEFT_KEY = otherInput.LEFT_KEY;
    RIGHT_KEY = otherInput.RIGHT_KEY;
    SCALE_MOD_KEY = otherInput.SCALE_MOD_KEY;
    TURN_LEFT_KEY = otherInput.TURN_LEFT_KEY;
    TURN_RIGHT_KEY = otherInput.TURN_RIGHT_KEY;
  }

  void keyPressed(Key k) {
    setKeyDown(k, true);
  }

  void keyReleased(Key k) {
    setKeyDown(k, false);
  }

  private void setKeyDown(Key k, boolean down) {
    if (CENTER_KEY.equals(k)) {
      centerKeyDown = down;
    } else if (UP_KEY.equals(k)) {
      upKeyDown = down;
    } else if (DOWN_KEY.equals(k)) {
      downKeyDown = down;
    } else if (LEFT_KEY.equals(k)) {
      leftKeyDown = down;
    } else if (RIGHT_KEY.equals(k)) {
      rightKeyDown = down;
    } else if (SCALE_MOD_KEY.equals(k)) {
      scaleModKeyDown = down;
    } else if (TURN_LEFT_KEY.equals(k)) {
      turnLeftKeyDown = down;
    } else if (TURN_RIGHT_KEY.equals(k)) {
      turnRightKeyDown = down;
    }
  }
}
