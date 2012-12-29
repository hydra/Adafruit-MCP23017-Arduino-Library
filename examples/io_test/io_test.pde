#include <Wire.h>
#include "Adafruit_MCP23017.h"

/*
MCP23017 #12 to chipKip #21 (I2C SCL) and to 4.7k resistor, other end of resistor to +5V (pull up).
MCP23017 #13 to chipKip #20 (I2C SDA) and to 4.7k resistor, other end of resistor to +5V (pull up).
MCP23017 #15,#16,#17 to GND – to select address 0x20 (32)
MCP23017 #9 to +5V
MCP23017 #18 to chipkit RST (RESET) - the chipkip reset line is +3.3v
MCP23017 #1-#8 to JUMPERS, other side of JUMPER connects to GND (Internal pull-up resistor used).
MCP23017 #21-#28 to 1k resistors, then to LED, then to GND.

With the MCP23017 RESET line hooked up to the chipkit when the chipkit is reset the LEDs turn OFF immediately if they were ON.
If you don't use the RST line then connect MCP23017 #18 to +5V
*/

Adafruit_MCP23017 mcp;
  
void setup() {
  Serial.begin(115200);  
  mcp.begin(0); // this is actually means MCP23017 base address 0x20 + 0 = I2C address 0x20.

  for (int pin = 0; pin < 8; pin++) {
    mcp.pinMode(pin, OUTPUT);
  }

  for (int pin = 8; pin < 16; pin++) {
    mcp.pinMode(pin, INPUT);
    mcp.pullUp(pin, HIGH);
  }

  pinMode(13, OUTPUT);
}



void loop() {
  digitalWrite(13, HIGH);
  for (int pin = 0; pin < 8; pin++) {
    mcp.digitalWrite(pin, HIGH);
  }
  delay(50);
  digitalWrite(13, LOW);
  for (int pin = 0; pin < 8; pin++) {
    mcp.digitalWrite(pin, LOW);
  }  
  delay(50);
  
  unsigned long before = micros();
  unsigned short int inputs = 0;
  for (int pin = 8; pin < 16; pin++) {
    inputs |= mcp.digitalRead(pin) << (pin - 8);
  }
  unsigned long after = micros();  
  Serial.print("inputs: ");
  Serial.println(inputs, BIN);
  Serial.print("Time to read inputs (micros): ");
  Serial.println(after - before, DEC);
}
