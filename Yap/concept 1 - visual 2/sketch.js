let shapeX;
let shapeY;
let lang = navigator.language || 'en-US';
let speechRec = new p5.SpeechRec(lang, gotSpeech);
let newFont;
const radius = 160;
const diameter = radius*2;
var resultS;
var sampleLine;

function preload() {
  newFont = loadFont('fonts/SpecialElite.ttf');
}

function setup() {
// createCanvas(2000,1000);
   createCanvas(windowWidth, windowHeight);
       
    stroke(255);
     //fill('white');
    textFont(newFont, 20);
    
    noFill();
    angleMode(DEGREES);
    rectMode(CENTER);

        shapeX = width/2;
    shapeY = height/2; //put shape in middle of screen height
  speechRec.start();
    

}

  function gotSpeech() {
    if (speechRec.resultValue) {
      createP(speechRec.resultString);
        console.log(speechRec); 
        resultS = speechRec.resultString;
    }
  }

function draw() {
    background(10, 20, 30);

    
    translate(width /2, height/2);
    
    for (var i = 0; i <200; i++){
        push()
        rotate(sin(frameCount + i) * 100)
        var r = map(sin(frameCount), -1, 1, 50, 255)
        var g = map(cos(frameCount / 2), -1,1,50,255)
        var b = map(sin(frameCount / 4),-1, 1, 50,255)
        
        stroke(r,g,b);
        
        rect(0,0,600 -i*3, 600 -i*3, 200-i);
        pop();
        
    
    }
    
   // rect(shapeX, shapeY, diameter);
    text(speechRec.resultString, shapeX, shapeY, 1580, 780); 

}
