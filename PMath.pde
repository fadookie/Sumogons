/**
 * Math helper library for Processing
 * @author Eliot Lash
 */
static class PMath {

  static PVector rotatePVector2DDebug(PVector _v, float theta) {
    PVector v = rotatePVector2D(_v, theta);
    println("_v " + _v + " theta " + theta + " v " +v);
    println("==========");
    return v;
  }

  /**
   * Based on code from http://www.shiffman.net/2011/02/03/rotate-a-vector-processing-js/
   */
  static PVector rotatePVector2D(PVector _v, float theta) {
    PVector v = _v.get();
    v.x = _v.x * cos(theta) - _v.y * sin(theta);
    v.y = _v.x * sin(theta) + _v.y * cos(theta);

    return v;
  }
}
