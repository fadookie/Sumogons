/**
 * Taken from the Spectrum Game Engine
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class IntroState extends GameState {
  //'Virtual' methods to be overriden in subclasses
  void setup() {
    //Make the world
    world = new FWorld();
    world.setGrabbable(false);
    world.setGravity(0, 0);
    world.setEdges();
    world.setEdgesRestitution(0.5);

    //Make an enemy
    EnemyController enemy = new EnemyController(3, 50.0, world);
    enemy.setPosition(width/3, height/3);
    enemy.updateShape();
    enemies.add(enemy);
  }

  void cleanup() {
  }

  void pause() {
  }

  void resume(GameState previousState) {
  }

  void update() {
    for (EnemyController enemy : enemies) {
      enemy.update();
    }
  }

  void draw() {
    background(99);
    textAlign(CENTER);
    fill(255);
    textFont(omnesSem48);
    text("SumoGONS!", width/2, 200); 
    textFont(omnesSem29);
    text("Press Space", width/2, (height/2 + 300)); 

    world.draw();
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
    if ((ENTER == key) ||
        (RETURN == key) ||
        (' ' == key)
      ) {
      engineChangeState(new InstructionState());
    }
  }

}
