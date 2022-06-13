let video;
let poseNet;
let pose;
let skeleton;
let img;
let shapeX;
let shapeY;
let shapeMove = false; //if mouse on shape and clicked
let particles = []; //array for particles
let lang = navigator.language || 'en-US';
let speechRec = new p5.SpeechRec(lang, gotSpeech);
let newFont;
const radius = 160;
const diameter = radius*2;
const num = 1000; //no. of particles
const noiseScale = 0.01/2;
var resultS;
var sampleLine;
var time;
var resultS = "";
//var blueColor = ['#78cbc2'];

function preload() {
  newFont = loadFont('fonts/YesevaOne.ttf');
}



function setup() {
   createCanvas(windowWidth, windowHeight);
    
     video = createCapture(VIDEO);
  video.hide();
  poseNet = ml5.poseNet(video, modelLoaded);
  poseNet.on('pose', gotPoses);
    textFont(newFont, 20);
    

    
        shapeX = width/2;
    shapeY = height/2; //put shape in middle of screen height
    for (let i = 0; i < num; i++){
        particles.push(createVector(random(width), random(height)));
    }

   
    stroke(255);
    
  speechRec.start();
    
    
    

}

function gotPoses(poses) {
  console.log(poses); 
    if (poses.length > 0){
        pose = poses[0].pose;
    }
}


function modelLoaded() {
  console.log('poseNet ready');
}

  function gotSpeech() {
    if (speechRec.resultValue) {
      createP(speechRec.resultString);
        console.log(speechRec); 
        resultS = speechRec.resultString;
    }
  }






function draw() {
    background( 0, 10);
    //rectMode(CORNER);
    
     angleMode(DEGREES);
    rectMode(CENTER);
   // noFill();
    stroke(255);
    
//push();
//    translate(width /2, height/2);
//    
//    for (var i = 0; i <60; i++){
//        push()
//        rotate(sin(frameCount + i) * 100)
//        var r = map(sin(frameCount), -2, 1, 10, 255)
//        var g = map(cos(frameCount / 2), -1,1,10,333)
//        var b = map(sin(frameCount / 4),-7, 1, 10,10)
//        
//        stroke(r,g,b);
//        
//        rect(0,0,450 -i*2, 450 -i*2, 200-i);
//        pop();
//        
//
//    }
//    pop();
    
 
           
    

    //if its empty, circle in middle and time
    if(resultS === ""){
      //handObject(shapeX, shapeY, diameter);
        circle(shapeX, shapeY, diameter); 
        time = millis();
    } else{//string isng emppty
        //draw the pose cause the string is full
    
        //wait one second first
        if(millis() <= time + 3000){
            //a second hasnt passed
            //just show circle with text
            circle(shapeX, shapeY, diameter); 
           // handObject(shapeX, shapeY, diameter); 
           // fill("white");
             text(speechRec.resultString, shapeX, shapeY, 280, 20);
            
        } else{
            //after one second, drawn pose
             if (pose){
    //image(img, pose.leftWrist.x, pose.leftWrist.y, 134);
      
    circle(width - pose.rightWrist.x, pose.rightWrist.y, diameter);
                 
                // handObject(width - pose.rightWrist.x, pose.rightWrist.y, diameter);
                 
          //fill("white");      
         text(speechRec.resultString, width - pose.rightWrist.x, pose.rightWrist.y, 680, 380);
             }
        }
    }

      angleMode(RADIANS);
    rectMode(CORNER);
    
    for (let i = 0; i <num; i++){
        let p = particles[i];
        point(p.x, p.y);
        let n = noise(p.x * noiseScale, p.y * noiseScale);
        let a = TAU * n; //2xpi
        p.x += cos(a);
        p.y += sin(a);
        
        
        //if off screen, put it back random
        if(!onScreen(p)){
            p.x = random(width);
            p.y = random(height);
        }
    }
}
    
    

function handObject(x, y, d){
    
    push();
    translate(width /2, height/2);
    
    for (var i = 0; i <60; i++){
        push()
        rotate(sin(frameCount + i) * 100)
        var r = map(sin(frameCount), -2, 1, 120, 140)
        var g = map(cos(frameCount / 2), -1,1,203,204)
        var b = map(sin(frameCount / 4),-7, 1, 194,240)
        
        stroke(r,g,b);
        
        //translate(x, y);
        rect(0, 0,450 -i*2, 450 -i*2, 200-i);
        
        pop();
        
     

    }
    pop();
    
}


function mousePressed(){
    let d = dist(mouseX, mouseY, shapeX,shapeY);
    if(d<radius){
        shapeMove = true;
    } else{
        shapeMove = false;
    }
}

function mouseReleased(){
    shapeMove = false;
}

function doubleClicked(){
         drawingContext.shadowBlur = 32;
    drawingContext.shadowColor = color(100,149,237);
    shapeX();
    shapeY();
}

//check if mouse if moving
function mouseDragged(){
    shapeX = mouseX;
    shapeY = mouseY;
    //shape xy is mouse xy position
}


//if vector is still on screen
function onScreen(v){
    return v.x >= 0 && v.x <= width && v.y >= 0 && v.y <= height;
}

