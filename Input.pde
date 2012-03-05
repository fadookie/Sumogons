class Input {
  boolean centerKeyDown = false;
  boolean upKeyDown = false;
  boolean downKeyDown = false;
  boolean leftKeyDown = false;
  boolean rightKeyDown = false;
  boolean turnLeftKeyDown = false;
  boolean turnRightKeyDown = false;
  boolean scaleModKeyDown = false;

  Key CENTER_KEY;
  Key UP_KEY;
  Key DOWN_KEY;
  Key LEFT_KEY;
  Key RIGHT_KEY;
  Key SCALE_MOD_KEY;

  Input() {
    CENTER_KEY = new Key();
    UP_KEY = new Key();
    DOWN_KEY = new Key();
    LEFT_KEY = new Key();
    RIGHT_KEY = new Key();
    SCALE_MOD_KEY = new Key();
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
  }

  void keyPressed(Key k) {
    if (CENTER_KEY.equals(k)) {
      centerKeyDown = true;
    } else if (UP_KEY.equals(k)) {
      upKeyDown = true;
    } else if (DOWN_KEY.equals(k)) {
      downKeyDown = true;
    } else if (LEFT_KEY.equals(k)) {
      leftKeyDown = true;
    } else if (RIGHT_KEY.equals(k)) {
      rightKeyDown = true;
    } else if (SCALE_MOD_KEY.equals(k)) {
      scaleModKeyDown = true;
    }
  }

  void keyReleased(Key k) {
    if (CENTER_KEY.equals(k)) {
      centerKeyDown = false;
    } else if (UP_KEY.equals(k)) {
      upKeyDown = false;
    } else if (DOWN_KEY.equals(k)) {
      downKeyDown = false;
    } else if (LEFT_KEY.equals(k)) {
      leftKeyDown = false;
    } else if (RIGHT_KEY.equals(k)) {
      rightKeyDown = false;
    } else if (SCALE_MOD_KEY.equals(k)) {
      scaleModKeyDown = false;
    }
  }
}
