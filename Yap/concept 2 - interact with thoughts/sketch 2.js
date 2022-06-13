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
    angleMode(DEGREES);
    rectMode(CENTER);
     textFont(newFont, 20, 140);
        shapeX = width/2;
    shapeY = height/2; //put shape in middle of screen height

    stroke(255);

    
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
    
    noFill();
    stroke(255);

    translate(width /2, height/2);
    
    for (var i = 0; i <60; i++){
        push()
        rotate(sin(frameCount + i) * 100)
        var r = map(sin(frameCount), -2, 1, 10, 255)
        var g = map(cos(frameCount / 2), -1,1,10,333)
        var b = map(sin(frameCount / 4),-7, 1, 10,10)
        
        stroke(r,g,b);
        
        rect(0,0,450 -i*2, 450 -i*2, 200-i);
        pop();
        
     

    }
    
   // rect(shapeX, shapeY, diameter);
    fill("white");
    text(speechRec.resultString, shapeX, shapeY, 1580, 780); 

}
