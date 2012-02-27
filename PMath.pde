/**
 * Math helper library for Processing
 * @author Eliot Lash
 */
static class PMath {

  /**
   * Based on code from http://www.shiffman.net/2011/02/03/rotate-a-vector-processing-js/
   */
  static PVector rotatePVector2D(PVector _v, float theta) {
    PVector v = _v.get();
    v.x = v.x * cos(theta) - v.y * sin(theta);
    v.y = _v.x * sin(theta) + v.y * cos(theta);

    return v;
  }
}
