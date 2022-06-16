

//funkorama
//garet
//manuskript gothisch
//winsor
//futura HV BT heavy italic
//futura extra black bT
//psychedellic caps
//proxima nova

PFont funkorama, manuskript, winsor, futuraHeavyItalic, futuraExtraBlack, psychedellicCaps;
PFont germanica, eurostileNormal, eurostileBold, glaive;
PFont gothamBold, gothamBlack;
PFont deutschlander;
PFont lora;
PFont crimsonText, crimsonTextBold;
int fontSize = 128;
String message = "Innovation";
int messageLength = message.length();
int startX, startY;
int spacing;
int fontCounter = 0;
int time;
int timeMargin = 150;
boolean changeFontOnce = false;
PShape lab;
Letter I, N, N2, O, V, A, T, I2, O2, N3;
int iCounter = 0; //i, manusrkipt gotisch, germanica, winsor, biggesgt textize
int nCounter = 0; //n, eurostile, winbsor, glaive
int n2Counter = 0; //n gotham, deutschlander
int oCounter = 0; //o gotham, futura, deutschlander, larger textsize
int vCounter = 0; //v eurostile, futura, larger textsize but not bigger than o
int aCounter = 0;//a, futura gotham, normal text size
int tCounter = 0; //t , lora, crimsons text, very neutral, normal text size
int i2Counter = 0; //i, eurostile, deutschlander, big textsize so it can eseem tall
int o2Counter  = 0; //o, futura, lora , smaller text size
int n3Counter = 0; //n, blackletter, glaive, winsor, textsize just as big as I

int bigFontSize = 200;
Letter[] letters = {};
int normalChangeSpeed = 500;
void setup() {

  fullScreen();
  background(0);
  funkorama = createFont("Funkorama.otf", fontSize);
  manuskript  = createFont("ManuskriptGotisch.ttf", fontSize);
  winsor  = createFont("Winsor.otf", fontSize);
  futuraHeavyItalic  = createFont("Futura Heavy Italic.ttf", fontSize);
  futuraExtraBlack  = createFont("Futura Extra Black.ttf", fontSize);
  psychedellicCaps  = createFont("JMH Psychedelic CAPS.otf", fontSize);
  germanica = createFont("Plain Germanica.ttf", fontSize);
  eurostileNormal = createFont("EuroStyle Normal.ttf", fontSize);
  eurostileBold  = createFont("EurostileBold.ttf", fontSize);
  glaive  = createFont("FontsFree-Net-GlaiveRegular.ttf", fontSize);
  gothamBold  = createFont("Gotham-Bold.otf", fontSize);
  gothamBlack = createFont("Gotham-Black.otf", fontSize);
  deutschlander = createFont("Deutschlander-O5we.ttf", fontSize);
  lora = createFont("Lora-Regular.ttf", fontSize);
  crimsonText = createFont("CrimsonText-Regular.ttf", fontSize);
  crimsonTextBold = createFont("CrimsonText-Bold.ttf", fontSize);
  lab = loadShape("data/lab.svg");
  lab.scale(1.1);
  textFont(manuskript, fontSize);
  textAlign(CENTER);
  //text(message.toUpperCase(), width/2, height/2);
  startX = width/5;
  startY = height/2;
  spacing = width/25;
  time = millis();

  //intialize letters
  //I, N, N2, O, V, A, T, I2, O2, N3;
  ////I, manusrkipt gotisch, germanica, winsor, biggesgt text
  I = new Letter("I", normalChangeSpeed, bigFontSize);
  I.fonts = (PFont[])append(I.fonts, manuskript);
  I.fonts = (PFont[])append(I.fonts, germanica);
  I.fonts = (PFont[])append(I.fonts, winsor);

  //N, eurostile, winbsor, glaive
  N = new Letter("N", int(normalChangeSpeed * 0.3), int(bigFontSize * 0.75));
  N.fonts = (PFont[])append(N.fonts, eurostileBold);
  N.fonts = (PFont[])append(N.fonts, winsor);
  N.fonts = (PFont[])append(N.fonts, glaive);

  //n2,  gotham, deutschlander
  N2 = new Letter("N", int(normalChangeSpeed * 0.7), int(bigFontSize * 0.75), 120);
  N2.fonts = (PFont[])append(N2.fonts, gothamBold);
  N2.fonts = (PFont[])append(N2.fonts, deutschlander);

  //o gotham, futura, deutschlander, larger textsiz
  O = new Letter("O", int(normalChangeSpeed * 0.9), int(bigFontSize * 0.85), 110);
  O.fonts = (PFont[])append(O.fonts, gothamBold);
  O.fonts = (PFont[])append(O.fonts, futuraHeavyItalic);
  O.fonts = (PFont[])append(O.fonts, deutschlander);

  //v eurostile, futura, larger textsize but not bigger than
  V = new Letter("V", int(normalChangeSpeed * 0.9), int(bigFontSize * 0.80));
  V.fonts = (PFont[])append(V.fonts, eurostileBold);
  V.fonts = (PFont[])append(V.fonts, futuraHeavyItalic);

  //a, futura gotham, normal text size
  A = new Letter("A", normalChangeSpeed, int(bigFontSize * 0.75));
  A.fonts = (PFont[])append(A.fonts, gothamBold);
  A.fonts = (PFont[])append(A.fonts, futuraHeavyItalic);

  //t , lora, crimsons text, very neutral, normal text siz
  T = new Letter("T", normalChangeSpeed, int(bigFontSize * 0.75), 80);
  T.fonts = (PFont[])append(T.fonts, crimsonText);
  T.fonts = (PFont[])append(T.fonts, lora);

  //i, eurostile, deutschlander, big textsize so it can eseem tall
  I2 = new Letter("I", normalChangeSpeed, int(bigFontSize * 1.2), 80);
  I2.fonts = (PFont[])append(I2.fonts, eurostileNormal);
  I2.fonts = (PFont[])append(I2.fonts, deutschlander);

  //o, //o, futura, lora , smaller text size
  O2 = new Letter("O", int(normalChangeSpeed * 0.5), int(bigFontSize * 0.70), 130);
  O2.fonts = (PFont[])append(O2.fonts, futuraHeavyItalic);
  O2.fonts = (PFont[])append(O2.fonts, lora);

  //n, blackletter, glaive, winsor, textsize just as big as I
  N3 = new Letter("N", normalChangeSpeed, bigFontSize, 60);
  N3.fonts = (PFont[])append(N3.fonts, glaive);
  N3.fonts = (PFont[])append(N3.fonts, winsor);


  //add letters in array
  letters = (Letter[])append(letters, I);
  letters = (Letter[])append(letters, N);
  letters = (Letter[])append(letters, N2);
  letters = (Letter[])append(letters, O);
  letters = (Letter[])append(letters, V);
  letters = (Letter[])append(letters, A);
  letters = (Letter[])append(letters, T);
  letters = (Letter[])append(letters, I2);
  letters = (Letter[])append(letters, O2);
  letters = (Letter[])append(letters, N3);
}


void draw() {

  background(0);
  spacing = 90 ;
  //if(millis() > time + timeMargin){
  //  background(0);
  //  for(int i = 0; i < messageLength; i++){
  //  char c = message.charAt(i);




  //  text(c, startX, startY);
  //  startX += spacing;
  //  changeFont();


  //}

  for (int i= 0; i< letters.length; i++) {
    letters[i].drawLetter(startX, startY);
    if (millis() > letters[i].letterTime + letters[i].speedChange) {
      letters[i].changeFont();
    }
    startX+= letters[i].spacing;
  }

  shape(lab, startX, 425);
  //changeFontOnce = true;
  startX = width/5;
  time = millis();
}


// saveFrame("2/tries-###.png");



void changeFont() {

  if (fontCounter == 0) {
    textFont(winsor, fontSize);
  } else if (fontCounter ==2) {
    textFont(funkorama, fontSize);
  } else if (fontCounter ==3) {
    textFont(funkorama, fontSize);
  } else if (fontCounter ==4) {
    textFont(futuraHeavyItalic, fontSize);
  } else if (fontCounter ==5) {
    textFont(futuraHeavyItalic, fontSize);
  } else if (fontCounter ==6) {
    textFont(futuraHeavyItalic, fontSize);
  } else if (fontCounter ==7) {
    textFont(futuraHeavyItalic, fontSize);
  } else if (fontCounter ==8) {
    textFont(winsor, fontSize);
  } else if (fontCounter ==9) {
    textFont(psychedellicCaps, fontSize);
  } else if (fontCounter == 10) {
    textFont(futuraExtraBlack, fontSize);
  } else if (fontCounter ==11) {
    textFont(futuraExtraBlack, fontSize);
  } else if (fontCounter ==12) {
    textFont(psychedellicCaps, fontSize);
  } else if (fontCounter ==13) {
    textFont(psychedellicCaps, fontSize);
  }


  fontCounter++;
  if (fontCounter >message.length() - 1) {
    fontCounter = int(random(message.length() - 1));
  }
}
