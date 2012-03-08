class PlayState extends GameState {

  void setup() {
    {
      //Make player 0
      PlayerController player = new PlayerController(numSides, 50.0, world);
      player.setPosition(width / 2, height / 2);
      player.setScale(scale.x, scale.y);
      player.setFill(new PVector(255, 0, 0));
      player.updateShape();
      player.tag = "0";

      Input input = player.getInput();

      input.CENTER_KEY = new Key('/');
      input.UP_KEY = new Key(UP, true);
      input.DOWN_KEY = new Key(DOWN, true);
      input.LEFT_KEY = new Key(LEFT, true);
      input.RIGHT_KEY = new Key(RIGHT, true);
      input.SCALE_MOD_KEY = new Key(ALT, true);
      input.SCALE_X_NEGATIVE_KEY = new Key('j');
      input.SCALE_X_POSITIVE_KEY = new Key('l');
      input.SCALE_Y_NEGATIVE_KEY = new Key('k');
      input.SCALE_Y_POSITIVE_KEY = new Key('i');
      //input.useMouse = true;

      player.setInput(input);

      players[0] = player;
    }

    {
      //Make player 1
      PlayerController player = new PlayerController(numSides, 50.0, world);
      player.setPosition((width / 2) + 100, (height / 2) + 100);
      player.setScale(scale.x, scale.y);
      player.setFill(new PVector(0, 0, 255));
      player.updateShape();
      player.tag = "1";

      Input input = player.getInput();

      input.CENTER_KEY = new Key('c');
      input.UP_KEY = new Key('w');
      input.DOWN_KEY = new Key('s');
      input.LEFT_KEY = new Key('a');
      input.RIGHT_KEY = new Key('d');
      input.SCALE_MOD_KEY = new Key(SHIFT, true);
      input.SCALE_X_NEGATIVE_KEY = new Key('f');
      input.SCALE_X_POSITIVE_KEY = new Key('h');
      input.SCALE_Y_NEGATIVE_KEY = new Key('g');
      input.SCALE_Y_POSITIVE_KEY = new Key('t');

      player.setInput(input);

      players[1] = player;
    }

    //Make an enemy
    //EnemyController enemy = new EnemyController(3, 50.0, world);
    //enemy.setPosition(width/3, height/3);
    //enemy.updateShape();
    //enemies.add(enemy);
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
    background(255);

    world.step();
    world.draw(getMainInstance());  

    //Debug draw
    if (DEBUG) {
      for (EnemyController enemy : enemies) {
        enemy.drawPath();
      }
    }

    for (PlayerController player : players) {
    //for (int i = 0; i < players.length; i++) {
    //  PlayerController player = players[i];
      Input input = player.getInput();

      /* //Rotation keys are now default, commenting out. 
      if (player.input.useMouse) {
        PVector mousePosition = gWorkVectorA;
        mousePosition.x = mouseX;
        mousePosition.y = mouseY;

        PVector pos = player.getPosition();
        PVector lookAt = PVector.sub(pos, mousePosition); //FIXME: Use workvector placeholders if this creates too much garbage
        lookAt.normalize();

        input.heading = lookAt;
      } else {
        //Process rotation keys if we're not using mouselook
        if (input.turnLeftKeyDown) {
        } else if (input.turnRightKeyDown) {
        }
      }*/

      //Set movement forces
      float xForce = 0;
      float yForce = 0;

      if (input.upKeyDown) {
        yForce = -movementForce;
      } else if (input.downKeyDown) {
        yForce = movementForce;
      }

      if (input.rightKeyDown) {
        input.rotation = radians(player.turnMagnitude);
      } else if (input.leftKeyDown) {
        input.rotation = radians(-player.turnMagnitude);
      } else {
        input.rotation = radians(0);
      }

      PVector playerScale = player.getScale();

      if (input.scaleXNegativeKeyDown) {
        playerScale.x -= scaleAdjustFactor;
      } else if (input.scaleXPositiveKeyDown) {
        playerScale.x += scaleAdjustFactor;
      }

      if (input.scaleYNegativeKeyDown) {
        println(player+"scaleY-");
        playerScale.y -= scaleAdjustFactor;
      } else if (input.scaleYPositiveKeyDown) {
        playerScale.y += scaleAdjustFactor;
      }

      player.setScale(playerScale.x, playerScale.y);

      if (input.centerKeyDown) {
        player.resetScale();
      }

      player.updateShape();

      player.setRelativeForce(xForce, yForce);
      player.update();
    }

    if (!disableEnemyUpdate) {
      for (EnemyController enemy : enemies) {
        enemy.update();
      }
    }
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
