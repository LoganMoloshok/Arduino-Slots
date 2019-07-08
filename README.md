# Arduino-Slots
A simple slot machine game using two Arduino Uno and Two Wire Interface communication, created as a final project for CIS 126 Computer Architecture and Organization at Montgommery County Community College

### Arduino Setup
![alt text](https://i.imgur.com/wkuCJIH.png "Arduino setup")
One arduino is linked to a 4-digit LED display and the second is connected to a simple button circuit, with both boards conencted using the analog input pins.
This setup allows for the button (input) arduino to send a message to the LED (output) board when the button is pressed, triggering stopping of the slot machine rotation.

### Files
**slotmachine.ino** and **slotmachine_input.ino** contain the Arduino language files for the output and input boards, respectively.  These scrips primarily handle the analog communication.

**slots.S** and **slots.h** contain the assembly code that drives the overall game logic and the C header that allows the Arduino scrips to execute the assembly code.
