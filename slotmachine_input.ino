#include <Wire.h>

int timesPressed = 0;

void setup() {
  pinMode(2, INPUT); //pin 2 recieves the button press
  pinMode(13, OUTPUT); //onboard LED used to confirm button press

  Wire.begin();
  
}

byte x = 0;

void loop() {
  int buttonState = digitalRead(2);

  if(buttonState == HIGH){
    digitalWrite(13, HIGH); // light onboard LED
    sendButtonPress();
  }else{
    digitalWrite(13, LOW); // turn off onboard LED
  }

}

void sendButtonPress() {
  timesPressed++;
  if(timesPressed > 3){
    timesPressed = 1;
  }
  Wire.beginTransmission(8);
  Wire.write(timesPressed);
  Wire.endTransmission();
  delay(500);
}


