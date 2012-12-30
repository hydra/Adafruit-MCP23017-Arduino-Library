#include <Wire.h>
#include "Adafruit_MCP23017.h"

/*
MCP23017 #12 to chipKip #21 (I2C SCL) and to 4.7k resistor, other end of resistor to +5V (pull up).
MCP23017 #13 to chipKip #20 (I2C SDA) and to 4.7k resistor, other end of resistor to +5V (pull up).
MCP23017 #15,#16,#17 to GND – to select address 0x20 (32)
MCP23017 #9 to +5V
MCP23017 #18 to chipkit RST (RESET) - the chipkip reset line is +3.3v

MCP23017 #1 to JUMPERS, other side of JUMPER connects to GND (Internal pull-up resistor used) - Read pin
MCP23017 #28 to 1k resistor, then to LED, then to GND - Write pin

With the MCP23017 RESET line hooked up to the chipkit when the chipkit is reset the LEDs turn OFF immediately if they were ON.
If you don't use the RST line then connect MCP23017 #18 to +5V

Results for a ChipKIT MAX32:

Reads achieved: 2347
Time taken (micros): 1000135
Average time per read (micros): 426.133
Final read value was: 0
Writes achieved: 1370
Time taken (micros): 1000003
Average time per write (micros): 729.929
Writes achieved: 1372
Time taken (micros): 1000972
Average time per write (micros): 729.571

*/

enum FlashMode {
  NO_FLASH = 0,
  FLASHING
};

int writePin = 7;
int readPin = 8;

Adafruit_MCP23017 mcp;
  
void setup() {
  Serial.begin(115200);  
  mcp.begin(0); // this is actually means MCP23017 base address 0x20 + 0 = I2C address 0x20.

  mcp.pinMode(writePin, OUTPUT);

  mcp.pinMode(readPin, INPUT);
  mcp.pullUp(readPin, HIGH);

  performanceTest();
}

void testSinglePinWritePerformance(int flashMode) {
  unsigned long now;
  unsigned long start = micros();
  int count = 0;
  
  do {
    mcp.digitalWrite(writePin, HIGH);
    count++;
    if (flashMode == FLASHING) {
      mcp.digitalWrite(writePin, LOW);
      count++;
    }
    now = micros();
  } while (now - start < 1000 * 1000);
  
  Serial.print("Writes achieved: ");
  Serial.println(count, DEC);
  Serial.print("Time taken (micros): ");
  Serial.println(now - start, DEC);
  float averageTime = (now - start) / (float)count;
  Serial.print("Average time per write (micros): ");
  Serial.println(averageTime, 3);
  
}

void testSinglePinReadPerformance(void) {
  unsigned long now;
  unsigned long start = micros();
  int count = 0;

  unsigned short int value = 0;
  
  do {
    value = mcp.digitalRead(readPin);
    count++;
    now = micros();
  } while (now - start < 1000 * 1000);
  
  Serial.print("Reads achieved: ");
  Serial.println(count, DEC);
  Serial.print("Time taken (micros): ");
  Serial.println(now - start, DEC);
  float averageTime = (now - start) / (float)count;
  Serial.print("Average time per read (micros): ");
  Serial.println(averageTime, 3);
  Serial.print("Final read value was: ");
  Serial.println(value, DEC);
}  

void performanceTest(void) {
  
  testSinglePinReadPerformance();
  testSinglePinWritePerformance(NO_FLASH);
  testSinglePinWritePerformance(FLASHING);
}

void loop() {
}

