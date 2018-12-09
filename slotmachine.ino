#include <Wire.h>
#include <slots.h>

void setup() {
 Wire.begin(8); // join i2c bus with address #8
 Wire.onReceive(receiveEvent); // register event
 Serial.begin(9600); // start serial for output
 Serial.println("Start Game");
 run();
}

void loop() {
// delay(100);
  main_loop();
}

// Executes whenever data is received from controller
void receiveEvent(int howMany) {
 int x = Wire.read(); // receive byte as an integer
 Serial.println(x); // print the integer
 stopLight(x); 
}

// Sends appropriate stop command depending on what number was recieved
void stopLight(int x){
  if(x == 1){
    stop_one();
  }else if(x == 2){
    stop_two();
  }else if(x == 3){
    stop_three();
  }
}
