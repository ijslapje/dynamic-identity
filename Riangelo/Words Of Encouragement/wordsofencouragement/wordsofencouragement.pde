


/**
 * This sketch demonstrates how to use an AudioRecorder to record audio to disk
 * and then immediately play it back by creating a new FilePlayer using the AudioRecordingStream
 * returned by the save method.
 * <p>
 * To use this sketch you need to have something plugged into the line-in on your computer.<br/>
 * Press 'r' to toggle recording on and off and the press 's' to save to disk.<br/>
 * The recorded file will be placed in the main folder of the sketch.
 * <p>
 * For more information about Minim and additional features, visit http://code.compartmental.net/minim/
 */

import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;
//import processing.video.*;
import processing.sound.*;
//Capture cam;

//Minim minim;

// for recording
//AudioInput in;
//AudioRecorder recorder;


// for playing back
//AudioOutput out;
//FilePlayer player;

//wave clock
//float centX, centY;
//float radius = 100;
//float angle;
float amountOfNoise;
//float x, y;
//float radVariance, thisRadius, rad;
PShape abstractShape ;//shape object

float lastX = -999;
float lastY = -999;

float radiusNoise;
float angleNoise;
//float angle = -PI/2;

float strokeCol = 254;
int strokeChange = -1;

int red = 242;
int green = 102;
int blue = 12;

int time ;

float radius = 300;
float squiggleRadius = 500;
float angle = 0;
float spiralRadius = 10;

float x, y;

float centX, centY;
float noiseVal;
float radiusVariance, thisRadius;



//PImage img;




boolean recording = false;

//serial port stufff
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

//waveform variables
int xspacing = 5;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude = 300.0;  // Height of wave
float period = 100.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave

int radiusWaveform = 100;
float xWaveform, yWaveform;
float waveAmplitude = 30;


//fluctuating circles variables
float fluctuateRadius = 15;
float newAngle = 0;
float circleRadius = 300;
float margin = 10;
boolean growing = false;
int colorCounter = 0;

//sound variables
processing.sound.Waveform waveform;
AudioIn in;

//voicelines
SoundFile startExplanation, cheeringWords, pastMessageExplanation, recordingExplanation, Bye, Beep, Saved;
int startExplanationDuration, cheeringWordsDuration, pastMessageExplanationDuration, recordingExplanationDuration, byeDuration, beepDuration, savedDuration;
Amplitude pastMessageAmp;
float pastMessageSum;
float smoothingFactor = 0.25;
float messageRadius = 300;
boolean playOnce = false;

// Define how many samples of the Waveform you want to be able to read at once
int samples = 100;

//recording variables
Minim minim;
AudioInput inRecord;
AudioRecorder recorder;
boolean recorded;
float messageSum;
Amplitude messageAmp;

// for playing back
AudioOutput out;
FilePlayer player;

//state variables
int state = 1;
int lastState =1;


void setup()
{
  fullScreen();
  in = new AudioIn(this, 0);

  // start the Audio Input
  in.start();
  // minim = new Minim(this);

  //// get a stereo line-in: sample buffer length of 2048
  //// default sample rate is 44100, default bit depth is 16
  //in = minim.getLineIn(Minim.STEREO, 2048);

  //// create an AudioRecorder that will record from in to the filename specified.
  //// the file will be located in the sketch's main folder.
  //recorder = minim.createRecorder(in, "myrecording.wav");

  //// get an output we can playback the recording on
  //out = minim.getLineOut( Minim.STEREO );

  textFont(createFont("Arial", 12));



  frameRate(30);
  centX = width/2;
  centY = height/2;
  amountOfNoise = random(10);
  noFill();
  strokeWeight(10);
  stroke(255, 0, 0);

  amountOfNoise = random(10);

  radiusNoise = random(10);
  angleNoise = random(10);

  time = millis();
  background(0);

  w = width/2+16;
  smooth();
  xWaveform = width/2;
  //frameRate(60);
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];

  // start the Audio Input


  waveform = new processing.sound.Waveform(this, samples);
  waveform.input(in);

  //setup fluctuating circles

  //setup voicelines
  startExplanation = new SoundFile(this, "StartExplanation.wav");
  startExplanationDuration = int(startExplanation.duration()) * 1000;

  pastMessageExplanation = new SoundFile(this, "PastMessageExplanation.wav");
  pastMessageExplanationDuration = int(pastMessageExplanation.duration()) * 1000;

  cheeringWords = new SoundFile(this, "CheeringWords.wav");
  cheeringWordsDuration = int(cheeringWords.duration()) * 1000;

  recordingExplanation = new SoundFile(this, "RecordingExplanation.wav");
  recordingExplanationDuration = int(recordingExplanation.duration()) * 1000;

  Bye = new SoundFile(this, "Bye.wav");
  byeDuration = int(Bye.duration()) * 1000;

  Beep = new SoundFile(this, "Beep.wav");
  beepDuration = int(Beep.duration()) * 1000;

  Saved = new SoundFile(this, "Saved.wav");
  savedDuration = int(Saved.duration()) * 1000;

  pastMessageAmp = new Amplitude(this);

  //recording setup
  minim = new Minim(this);

  //// get a stereo line-in: sample buffer length of 2048
  //// default sample rate is 44100, default bit depth is 16
  inRecord = minim.getLineIn(Minim.STEREO, 2048);

  //// create an AudioRecorder that will record from in to the filename specified.
  //// the file will be located in the sketch's main folder.
  recorder = minim.createRecorder(inRecord, "myrecording.wav");

  //// get an output we can playback the recording on
  out = minim.getLineOut( Minim.STEREO );

  messageAmp = new Amplitude(this);
}

void draw() {


  //if (myPort.available() > 0) {
  //  if ( (val = myPort.readStringUntil(ENTER)) != null )  val = trim(val);
  //  else return;
  //  if (val != null) {
  //    println(val);
  //  }
  //}

  //if ("CHANGE".equals(val) && !recording) {
  //  recording = true;

  //}

  //if ("CHANGEBACK".equals(val) && recording) {
  //  background(0);
  //  recording = false;

  //}

  //if ("RECORD".equals(val) && recording) {
  //  background(0);
  //  buttonPressed();

  //}

  //12states
  stateChanged();

  if (state ==1) {
    firstState();
  } else if (state ==2) {
    secondState();
  } else if (state ==3) {
    thirdState();
  } else if (state ==4) {
    fourthState();
  } else if (state ==5) {
    fifthState();
  } else if (state ==6) {
    sixthState();
  } else if (state ==7) {
    seventhState();
  } else if (state ==8) {
    eightState();
  } else if (state ==9) {
    ninthState();
  } else if (state ==10) {
    tenthState();
  } else if (state ==11) {
    eleventhState();
  } else if (state ==12) {
    twelfthState();
  }
  //if(!recording){

  //  fluctuatingCircles();
  //} else if(recording){
  //  background(0);


  ////waves fluctuating to sides
  //pushMatrix();
  ////rotate(PI/2);
  //calcWave();
  //renderWave();
  //popMatrix();
  //audioReflection();


  //}
}

void mousePressed() {
  //recording = !recording;
  background(0);
  state++;
  if (state > 12) {
    state = 1;
  }
}


void fluctuatingCircles() {
  background(0);

  translate(width/2, height/2);

  if (growing) {
    fluctuateRadius+= 3;
  } else {
    fluctuateRadius -= 3;
  }

  if (fluctuateRadius <= 0) {
    growing = !growing;
  } else if (fluctuateRadius >= 60) {
    growing = !growing;
  }

  for (float endRadius = circleRadius; endRadius>0; endRadius -= 15) {
    strokeWeight(3);
    stroke(255);
    decideColor();
    for (float angle = 0; angle<= 360; angle+=10) {
      float x= cos(radians(angle)) * endRadius + margin;
      float y = sin(radians(angle)) * endRadius + margin;
      ellipse(x, y, fluctuateRadius, fluctuateRadius);
    }
    //colorCounter++;
    //decideColor();
  }
}

void decideColor() {

  if (colorCounter == 3) {
    colorCounter = 0;
  }
  if (state ==2 || state ==3 || state == 11 || state==12) {
    if (colorCounter == 0) {
      fill(241, 102, 106);
    } else if (colorCounter ==1) {
      fill(167, 45, 35 );
    } else if (colorCounter ==2) {
      fill(120, 203, 194 );
    }
  } else {
    if (colorCounter == 0) {
      fill(247, 197, 199);
    } else if (colorCounter ==1) {
      fill(140, 204, 240 );
    } else if (colorCounter ==2) {
      fill(120, 203, 194 );
    }
  }
  colorCounter++;
}

void pastMessageCircle() {
  pastMessageSum += (pastMessageAmp.analyze() - pastMessageSum) * smoothingFactor;
  background(0);
  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a fixed scale factor
  float pastMessageSumScaled = pastMessageSum * (height/2) * 2;

  stroke(255);
  fill(255);
  // We draw a circle whose size is coupled to the audio analysis
  ellipse(width/2, height/2, pastMessageSumScaled, pastMessageSumScaled);
}

void messageCircle() {
}


void waveClock() {
  radiusNoise += 0.05;
  //F2B90C
  //rgb(242, 185, 12)
  drawSquiggle(242, 185, 12, 70);
  //F7C5C7
  //rgb(247, 197, 199)
  drawSquiggle(247, 197, 199, 100);


  radius = (noise(radiusNoise) * 550) + 1;
}

void unusedWaveclock() {
  angleNoise += 0.005;
  angle += (noise(angleNoise) * 6) -3;

  if (angle > 360) {
    angle -= 360;
  }

  if (angle < 0) {
    angle += 360;
  }

  //how do i map this,

  float centerX = width/2 ;
  float centerY = height/2 ;

  float rad = radians(angle);
  float x1 = centerX + (radius* cos(rad));
  float y1 = centerY + (radius* sin(rad));

  float opprad = rad + PI;
  float x2 = centerX + (radius *cos(opprad));
  float y2 = centerY + (radius * sin(opprad));



  time = millis();

  //if(millis() <= 5000){

  //}

  float moduloTime = time % 5000;

  float newGreen = map(moduloTime, 0, 5000, 102, 185);
  float newBlue = map(moduloTime, 0, 5000, 106, 12);


  //strokeCol += strokeChange;

  //if(strokeCol > 254){
  // strokeChange = -1;
  //}

  //if(strokeCol < 0){
  // strokeChange = 1;
  //}
  stroke(red, newGreen, newBlue, 60);
  strokeWeight(3);
  line(x1, y1, x2, y2);
}

//void cameraThings(){
//  if (cam.available()) {
//     cam.read();
//  }
//  //drawin wit cam
//  background(0);
//  fill(255);
//  noStroke();
//  float tiles = 200;
//  float tileSize = width/tiles;
//  translate(tileSize/2,tileSize/2);
//  for (int x = 0; x < tiles; x++) {
//    float  red = 241;
//      float  green = map(x, 0, tiles, 102, 185);
//      float  blue = map (x, 0, tiles, 106, 12);
//    for (int y = 0; y < tiles; y++) {
//      color c = cam.get(int(x*tileSize),int(y*tileSize));
//      float size = map(brightness(c),0,255,tileSize,0);


//      fill(red, green, blue);

//      ellipse(x*tileSize, y*tileSize, size, size);
//    }
//  }
//  stroke(255);



//  //if ( recorder.isRecording() )
//  //{
//  //  text("Now recording, press the r key to stop recording.", 5, 15);
//  //}
//  //else if ( !recorded )
//  //{
//  //  text("Press the r key to start recording.", 5, 15);
//  //}
//  //else
//  //{
//  //  text("Press the s key to save the recording to disk and play it back in the sketch.", 5, 15);
//  //}
//}

//void cameraSpiral(){
//  if (cam.available()) {
//     cam.read();
//  }
//  float moduloTime = time % 5000;

//  float newGreen = map(moduloTime, 0, 5000, 102, 185);
//  float newBlue = map(moduloTime, 0, 5000, 106, 12);

//   drawSquiggle(255, 255, 255, 100);
//   drawSquiggle(255, 255, 255, 150);
//   drawSquiggle(255, 255, 255, 175);
//   squiggleRadius = 300;
//  PGraphics maskVideo = createGraphics(width, height);
//        maskVideo.beginDraw();
//        maskVideo.rectMode(CORNER);
//        maskVideo.background(0) ;//black so only the shape draw
//        maskVideo.stroke(255);
//        maskVideo.strokeWeight(3);
//        //maskVideo.noFill();//draw with white so it gets shown
//        //for(int i=0; i<= height; i+= 10){
//        //  maskVideo.line(0, i, width, i);
//        //}

//        maskVideo.beginShape();
//   maskVideo.fill(255);
//   maskVideo.stroke(255 , 0, 0);
//   int multiplier = 30;
//  for(float newAngle = angle; newAngle <= angle+ 360; newAngle+=0.5){
//    noiseVal += 0.1;
//    float rad = radians(newAngle);
//    radiusVariance = multiplier * customNoise(noiseVal);
//    thisRadius = squiggleRadius + radiusVariance;



//    x  = centX + (cos(rad) * thisRadius /3*2);
//    y = centY + (sin(rad) * thisRadius/3  * 2);
//    maskVideo.curveVertex(x, y);



//  }
//  maskVideo.endShape();
//        maskVideo.endDraw();

//        cam.mask(maskVideo);
//        //tint(255,192,203);

//         tint(red, newGreen, newBlue);
//       image(cam,0,0,width,height);

//        fill(#ffffff);
//        noStroke();
//        rectMode(CENTER);
//}

void drawSquiggle(int red, int green, int blue, int multiplier) {
  beginShape();
  //fill(255);
  stroke(red, green, blue);
  for (float newAngle = angle; newAngle <= angle+ 360; newAngle+=0.5) {
    noiseVal += 0.1;
    float rad = radians(newAngle);
    radiusVariance = multiplier * customNoise(noiseVal);
    thisRadius = radius + radiusVariance;



    x  = centX + (cos(rad) * thisRadius/3 *2);
    y = centY + (sin(rad) * thisRadius /3 * 2);
    curveVertex(x, y);
  }
  endShape();


  //  saveFrame("output/carousel-####.png");
}



float customNoise(float value) {
  float retValue = pow(cos(value), 3);
  return retValue;
}

//wabeform code
void audioReflection() {

  stroke(255);
  fill(0);
  rectMode(CENTER);
  strokeWeight(3);
  ellipse(width/2, height/2, messageRadius, messageRadius);
  stroke(255);
  strokeWeight(4);
  noFill();

  // Perform the analysis
  waveform.analyze();

  beginShape();
  for (int i = 0; i < samples; i++) {
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1
    vertex(
      map(i, 0, samples, width/2 - 150, width/2 + 150),
      map(waveform.data[i], -1, 1, height/2 - 150, height/2 + 150)
      );
  }
  endShape();
}

void renderWave() {
  noStroke();
  fill(255);
  // A simple way to draw the wave with an ellipse at each location
  float lastWaveformX = -999;
  float lastWaveformY= yvalues[0];
  for (int x = 0; x < yvalues.length; x++) {
    if (lastWaveformX < 0) {
      lastWaveformX = x;
    } else {
      float radiusWaveformEllipse = map(x, 0, yvalues.length -1, 10, 30);
      //ellipse(x*xspacing + width/2, height/2+yvalues[x], radiusWaveformEllipse, radiusWaveformEllipse);
      //stroke(255);
      strokeWeight(radiusWaveformEllipse);

      //  if(colorCounter == 0){
      //  fill(241, 102 , 106);
      //} else if(colorCounter ==1){
      //  fill(167, 45, 35 );
      //} else if(colorCounter ==2){
      //  fill(120, 203, 194 );

      pushMatrix();
      translate(width/2, height/2);

      if (state == 1) {
        stroke(255);
      } else {
        stroke(241, 102, 106);
      }

      line(lastWaveformX*xspacing, lastWaveformY, x*xspacing, yvalues[x]);//line to the right
      
      if (state == 1) {
        stroke(255);
      } else {
        stroke(167, 43, 35);
      }
      
      line( - lastWaveformX * xspacing, lastWaveformY, - x*xspacing, yvalues[x]); //line to the left
      popMatrix();

      pushMatrix();
      translate(width * 0.785, height/2);//no idea why these translate amouunts work, but they do
      rotate(PI/2.0);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(246, 197, 199);
      }

      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the b
      popMatrix();

      pushMatrix();
      translate(width * 0.7, height * 0.1);//no idea why these translate amouunts work, but they do
      rotate(PI/4.0);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(120, 203, 194);
      }

      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the b
      popMatrix();

      pushMatrix();
      translate(width * 0.7, height * 0.85);//no idea why these translate amouunts work, but they do
      rotate(PI  * 0.75);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(120, 203, 194);
      }

      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the b
      popMatrix();

      pushMatrix();
      translate(width * 0.3, height * 0.85);//no idea why these translate amouunts work, but they do
      rotate(PI  * 1.25);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(120, 203, 194);
      }

      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the b
      popMatrix();

      pushMatrix();
      translate(width * 0.3, height * 0.85);//no idea why these translate amouunts work, but they do
      rotate(PI  * 1.25);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(120, 203, 194);
      }
      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the b
      popMatrix();

      pushMatrix();
      translate(width * 0.3, height * 0.15);//no idea why these translate amouunts work, but they do
      rotate(PI  * 1.75);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(120, 203, 194);
      }
      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the b
      popMatrix();


      pushMatrix();
      translate(width * 0.225, height/2);
      rotate(PI* 1.5);
      if (state == 1) {
        stroke(255);
      } else {
        stroke(246, 197, 199);
      }

      line(lastWaveformX*xspacing, lastWaveformY + height/2, x*xspacing, height/2 + yvalues[x]);//line to the right
      popMatrix();
      lastWaveformX = x;
      lastWaveformY = yvalues[x];
    }
  }
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.3;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    float tempAmplitude = map(x, theta, x + dx * yvalues.length, 0, amplitude);
    yvalues[i] = sin(x)* tempAmplitude;
    //based on the position in the wave i want to relatively calculate the y value
    //at the center the wave has a amplitude of 0 and at the right edge of the screen the radiusWaveform is just the amplitude

    x+=dx;
  }
}


//ALL THE STATES
void stateChanged() {
  if (lastState != state) {
    playOnce = false;
    lastState++;
    time = millis();
    if (state ==4) {
      pastMessageAmp.input(cheeringWords);
    }


    if (state == 9) {

      if ( player != null )
      {
        player.unpatch( out );
        player.close();
      }
      player = new FilePlayer( recorder.save() );
      player.patch( out );

      state++;
    }
  }

  if (state > 12) {
    state=1;
  }
}
void firstState() {
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
}


void secondState() {
  if (!playOnce) {
    startExplanation.play();
    playOnce = true;
    println("HIIII");
  }

  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
}

void thirdState() {
  if (!playOnce) {
    pastMessageExplanation.play();
    playOnce = true;
  }

  if (millis() > time + pastMessageExplanationDuration) {
    state++;
  }

  println(millis(), time);

  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
}

void fourthState() {
  if (!playOnce) {
    cheeringWords.play();
    playOnce = true;
  }

  if (millis () < time + cheeringWordsDuration) {
    pastMessageCircle();
  } else {

    if (millis() < time + cheeringWordsDuration + 2500) {
      float tempRadius = map(millis(), time + cheeringWordsDuration, time + cheeringWordsDuration + 2500, 1, messageRadius);
      ellipse(width/2, height/2, tempRadius, tempRadius);
    } else {
      state++;
    }
  }
}

void fifthState() {
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();

  if (millis() > time + 1000) {
    state++;
  }
}

void sixthState() {
  if (!playOnce) {
    recordingExplanation.play();
    playOnce = true;
  }

  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
}

void seventhState() { //beep
  if (!playOnce) {
    Beep.play();
    playOnce = true;
  }
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();

  if (millis() > time + beepDuration) {
    state++;
  }
}

void eightState() { //recording
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();





  //in = null;

  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16


  if (!playOnce) {
    recorder.beginRecord();
    playOnce = true;
  }



  if (recorder.isRecording()) {
    println("YERR");
  }
  //if ( recorder.isRecording() )
  //  {
  //    recorder.endRecord();
  //   // recorded = true;
  //  }
  //  else
  //  {
  //    recorder.beginRecord();
  //  }
}

void ninthState() {
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
  if ( recorder.isRecording() )
  {

    recorder.endRecord();
    player.play();
    // recorded = true;
  }
}

void tenthState() { //saved

  if (player == null) {
    println("AINT SHIT HERE");
  }



  background(0);
  pushMatrix();
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
  println("SAVED");

  if (millis() > time +  200) {
    state++;
  }
}

void eleventhState() {
  if (!playOnce) {
    Saved.play();
    playOnce = true;
  }
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();
}


void twelfthState() { //end
  background(0);
  pushMatrix();
  ////rotate(PI/2);
  calcWave();
  renderWave();
  popMatrix();
  audioReflection();

  if (!playOnce) {
    Bye.play();
    playOnce = true;
  }


  if (millis() > time + byeDuration + 2000) {
    state =1;
    lastState =1;
  }
}
