class NewGameState extends GameState{
  color backgroundColor = color(66);
  int verticalOffset = -50;

  void setup() {
    leaderboard = new ArrayList<String>();

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
      PlayerController player = new PlayerController(4, 50.0, world);
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
      PlayerController player = new PlayerController(numSides, 50.0, world);
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
  }

  void cleanup() {
  }

  void pause() {
  }

  void resume(GameState previousState) {
  }

  void update() {
    world.step();
  }

  void draw() {
    background(backgroundColor);
    textFont(omnesSem48);
    textAlign(CENTER);
    fill(255);
    text("Choose your sides!", width/2, (height/2 + verticalOffset)); 

    world.draw(getMainInstance());  
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

    if ((ENTER == key) ||
        (RETURN == key)
      ) {
      engineChangeState(new PlayState());
    }
  }

  void keyReleased() {
  }

}
