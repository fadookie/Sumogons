class PlayState extends GameState {

  void setup() {
    //Make the world
    world = new FWorld();
    world.setGrabbable(DEBUG); //Only allow mouse grabbing in debug mode
    world.setGravity(0, 0);
    world.setEdgesRestitution(0.5);

    ellipseMode(RADIUS);

    {
      //Make player 0
      PlayerController player = new PlayerController(playerSides[0], 50.0, world);
      player.setPosition((width / 2) - 100, (height / 2) - 100);
      player.setScale(scale.x, scale.y);
      player.setFill(new PVector(255, 0, 0));
      player.updateShape();
      player.tag = "Red";

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
      PlayerController player = new PlayerController(playerSides[1], 50.0, world);
      player.setPosition((width / 2) + 100, (height / 2) + 100);
      player.setScale(scale.x, scale.y);
      player.setFill(new PVector(0, 0, 255));
      player.updateShape();
      player.tag = "Blue";

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

    //Obstacle
    PolygonController poly = new PolygonController(4, 25.0, world);
    poly.setPosition(width / 2, height / 2);
    poly.setScale(scale.x, scale.y);
    poly.tag = "peg";
    //poly.setStatic(true);
    poly.setDensity(9999999999.0);
    poly.updateShape();

    shapes.add(poly);

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
    for (PlayerController player : players) {
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

    //Check for win condition
    for (PlayerController player : players) {
      PVector position = player.getPosition();
      if (
          (position.x > width) ||
          (position.x < 0) ||
          (position.y > height) ||
          (position.y < 0)
         ) {
        println(width + "," + height);
        println(position);
        engineChangeState(new InterstitialState(player + " loses!", new PlayState()));
      }
    }

    world.step();
  }

  void draw() {
    background(255);

    world.draw(getMainInstance());  

    for (PlayerController player : players) {
      player.draw();
    }

    //Debug draw
    if (DEBUG) {
      for (EnemyController enemy : enemies) {
        enemy.drawPath();
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

  void keyReleased() {
    Key k = new Key(key, keyCode);

    for (PlayerController player : players) {
      Input input = player.getInput();
      input.keyReleased(k);
      player.setInput(input);
    }
  }
}
