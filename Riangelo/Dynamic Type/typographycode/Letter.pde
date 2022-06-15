class Letter {
  String c;
  PFont[] fonts = {};
  int counter;
  float speedChange;
  int size;
  int letterTime;
  float spacing;
  Letter(String letter, float speed, int sais) {
    c = letter;
    counter = 0;
    speedChange = speed;
    size = sais;
    letterTime = millis();
    spacing = map(size, 60, 200, 70, 120);
  }

  Letter(String letter, float speed, int sais, float spees) {
    c = letter;
    counter = 0;
    speedChange = speed;
    size = sais;
    letterTime = millis();
    spacing = spees;
  }

  void changeFont() {
    //for(int i = 0; i< fonts.length; i++){
    //  if(i == counter){
    //    textFont(fonts[i], fontSize);
    //    break;
    //  }

    //}
    counter++;
    if (counter > fonts.length - 1) {
      counter = 0;
    }
    letterTime = millis();
  }

  void drawLetter(float x, float y) {
    textFont(fonts[counter], size);
    textSize(size);
    text(c, x, y);
  }
}
