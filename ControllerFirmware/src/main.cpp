#include "Arduino.h"

void setup() {
    Serial.begin(9600);
    while (!Serial) {delay(10);}
    Serial.printf("Starting setup\n");
}


void loop() {
    Serial.println("Hello World");
    delay(1000);
}