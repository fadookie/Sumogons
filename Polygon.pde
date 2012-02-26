class Polygon extends FPoly {
    int sideCount = 0;
  
    void setSideCount(int n) {
      sideCount = n;
    }
    
    int getSideCount() {
      return sideCount;
    }
  
    void draw(PGraphics applet) {
      super.draw(applet);
    }
}
