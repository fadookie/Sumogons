class NewGameState extends GameState{
  color backgroundColor = color(66);
  int verticalOffset = -50;

  void setup() {
    leaderboard = new int[numPlayers];

    //Make the world
    world = new FWorld();
    world.setGrabbable(false);
    world.setGravity(0, 0);
    world.setEdges();
    world.setEdgesRestitution(0.5);

    for (int i = 0; i < numPlayers; i++) {
      playerSides[i] = 3;
    }

    {
      //Make player 0
      PlayerController player = new PlayerController(numSides, 50.0, world);
      player.setPosition((width / 2) - 100, (height / 2) + 100);
      player.setScale(scale.x, scale.y);
      player.setFill(new PVector(255, 0, 0));
      player.updateShape();
      player.tag = "Red";

      players[0] = player;
    }

    {
      //Make player 1
      PlayerController player = new PlayerController(numSides, 50.0, world);
      player.setPosition((width / 2) + 100, (height / 2) + 100);
      player.setScale(scale.x, scale.y);
      player.setFill(new PVector(0, 0, 255));
      player.updateShape();
      player.tag = "Blue";

      players[1] = player;
    }
  }

  void cleanup() {
  }

  void pause() {
  }

  void resume(GameState previousState) {
  }

  void update() {
    world.step();

    for (int i = 0; i < numPlayers; i++) {
      PlayerController player = players[i];
      int sides = playerSides[i];
      player.setNumSides(sides);
      player.updateShape();
    }
  }

  void draw() {
    background(backgroundColor);
    textFont(omnesSem48);
    textAlign(CENTER);
    fill(255);
    text("Choose your sides!", width/2, (height/2 - 100)); 
    textFont(omnesSem29);
    text("Red: Left & right arrow keys to select sides", width/2, (height/2 + 200)); 
    text("Blue: W&D keys to select sides", width/2, (height/2 + 250)); 
    text("Space to play", width/2, (height/2 + 300)); 

    world.draw(getMainInstance());  
  }

  void mouseDragged() {
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }

  void keyPressed() {
    //Key k = new Key(key, keyCode);

    //for (PlayerController player : players) {
    //  Input input = player.getInput();
    //  input.keyPressed(k);
    //  player.setInput(input);
    //}

    //HACK HACK HACK
    if (CODED == key) {
      if (LEFT == keyCode) {
        playerSides[0]--;
        playerSides[0] = constrain(playerSides[0], minSides, 999);
      } else if (RIGHT == keyCode) {
        playerSides[0]++;
        playerSides[0] = constrain(playerSides[0], minSides, 999);
      }
    } else {
      if ((ENTER == key) ||
          (RETURN == key) ||
          (' ' == key)
        ) {
        engineChangeState(new InterstitialState("Fight!", new PlayState(), interstitialLengthMs));
      } else if ('a' == key) {
        playerSides[1]--;
        playerSides[1] = constrain(playerSides[1], minSides, 999);
      } else if ('d' == key) {
        playerSides[1]++;
        playerSides[1] = constrain(playerSides[1], minSides, 999);
      }
    }
  }

  void keyReleased() {
  }

}
