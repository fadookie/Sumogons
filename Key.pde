class Key {
  boolean coded = false;
  char myKey = 0;
  int myKeyCode = 0; 

  Key() {
  }

  Key(char _key, int _keyCode) {
    coded = (CODED == key);
    myKey = _key;
    myKeyCode = _keyCode;
  }

  Key(char _key) {
    myKey = _key; 
    coded = false;
  }

  Key(int _keyCode, boolean _coded) {
    coded = _coded;
    myKeyCode = _keyCode;
    if (!coded) {
      println("Unexpected invocation of Key(int, boolean) with boolean set to false. Continuing.");
    }
  }


  boolean equals(Key k) {
    if (coded && k.coded) {
      return myKeyCode == k.myKeyCode;
    } else if (!coded && !k.coded) {
      return myKey == k.myKey;
    }
    return false;
  }

  String toString() {
    return "Key : " + myKey + " KeyCode : " + myKeyCode + " Coded : " + coded;
  }
}
