class Letter{
  String c;
  PFont[] fonts = {};
  int counter;
  int speedChange;
  int size;
  Letter(String letter, int speed, int sais){
   c = letter;
   counter = 0;
   speedChange = speed;
    size = sais;
  }
  
  void changeFont(){
    for(int i = 0; i< fonts.length; i++){
      if(i == counter){
        textFont(fonts[i], fontSize);
        break;
      }
      
    }
    counter++;
    if(counter > fonts.length){
     counter = 1; 
    }
  }
  
  void drawLetter(float x, float y){
    text(c, x, y);
    
  }
  
}
