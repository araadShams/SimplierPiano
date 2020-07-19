//Araad Shams, Screaming Piano
//Does exactly what it says, its a screaming piano


import themidibus.*;
import javax.sound.midi.MidiMessage; 
import processing.serial.*;
import processing.sound.*;

SoundFile siren;
SoundFile scream1;
SoundFile scream2;
SoundFile scream3;
SoundFile scream4;

long millisTracker = 0;
MidiBus myBus; 
boolean letItGo = false;

int currentColor = 0;
int midiDevice  = 0;

boolean[] dontDo = new boolean[]{false,false,false,false,false};

boolean screamingStarted = false;


int[] incorrectNotes = new int[]{13,15,18,20,22};
Serial myPort = new Serial(this, Serial.list()[6], 9600);
void setup() {
  print(Serial.list()[6]);
  siren = new SoundFile(this, "Siren.mp3");
  scream1 = new SoundFile(this, "Scream1.mp3");
  scream2 = new SoundFile(this, "Scream2.mp3");
  scream3 = new SoundFile(this, "Scream3.mp3");
  scream4 = new SoundFile(this, "Scream4.mp3");
  background(#000000);
  size(1440, 900);
  textSize(60);
  text("Choose a song!", 500,100);
  rect(430,250,600,120);
  rect(430,400,600,120);
  rect(430,550,600,120);
  fill(0);
  text("Q-Mary Had A Sheep", 500,350);
  text("W-Caillou Song", 540,500);
  text("E-Let It Go", 570,650);
  myBus = new MidiBus(this, midiDevice, 1); 
}

void draw() {
  if(screamingStarted && millis() - millisTracker > 2000 && dontDo[4] == false)
  {
    scream1.play();
    scream2.play();
    scream3.play();
    scream4.play();
    dontDo[4] = true;
  }
  if(screamingStarted && millis() - millisTracker > 350 && dontDo[0] == false)
  {
    scream2.play();
    siren.play();
    dontDo[0] = true;
  }
  if(screamingStarted && millis() - millisTracker > 700 && dontDo[1] == false)
  {
    scream1.play();
      scream2.play();
     siren.play();
     dontDo[1] = true;
  }
  if(screamingStarted && millis() - millisTracker > 1000 && dontDo[2] == false)
  {
     siren.play();
     dontDo[2] = true;
  }
  if(screamingStarted && millis() - millisTracker > 1200 && dontDo[3] == false)
  {
      scream1.play();
      scream3.play();
      scream4.play();
     siren.play();
     dontDo[3] = true;
  }
}



void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
    
  int type = (message.getMessage()[0] & 0xFF) ;
  

  if(type == 144)
  {
    int note = (int)(message.getMessage()[1] & 0xFF) ;
    if(!noteCorrect(note))
    {
      print("trigger");
      millisTracker = millis();
      myPort.write(115);
      screamingStarted = true;
      siren.play();
    }
  }
}

boolean noteCorrect(int num)
{
  for(int i = 0; i < 9; i++)
  {
    for(int j = 0; j < 5; j++)
    {
     int transformedNote = incorrectNotes[j] + (i*12);
     if(transformedNote == num) return false;
    }
  }
  return true;
}


void keyPressed() {
  rect(0,0,1400,900);
  textSize(200);
  fill(#00FF00);
  text("PLAY!",400,350);
  incorrectNotes = new int[]{13,15,18,20,22};
  int shift  = 0;
  switch(Character.toUpperCase(key))
  {
    //C MAJOR
    case 'Q':
    shift = 0;
    break;
    
    case 'W':
    //C MAJOR
    shift = 0;
    break;
    
    case 'E':
    //E FLAT MAJOR + ACCIDENTALS(LET IT GO BOOL)
    shift = 8;
    letItGo = true;
    break;
  }
  for(int i = 0; i < 5; i ++)
  {
   if(letItGo && (i==1 || i == 4))
   {
     incorrectNotes[i] = -1000;
   }
   else
   {
     incorrectNotes[i] = incorrectNotes[i] + shift;
   }
  }

}
