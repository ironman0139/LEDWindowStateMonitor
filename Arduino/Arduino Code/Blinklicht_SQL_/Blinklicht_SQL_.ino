#include <Adafruit_NeoPixel.h>

#define PIN            6  // Hier den Pin definieren, an dem die Datenleitung der WS2812 angeschlossen ist
#define NUMPIXELS      7  // Anzahl der LEDs in deinem Ring
#define PIN            6  // Hier den Pin definieren, an dem die Datenleitung der WS2812 angeschlossen ist
int ledPin = 13;
int ledstat = 0;

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(9600); // Baudrate anpassen, falls erforderlich
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  
}

void rundumlichtEffekt(int dauer) {
  // Rundumlicht-Effekt
  for(int i = 1; i < (NUMPIXELS); i++) {
    strip.setPixelColor(i, strip.Color(255, 69, 0)); // Rot
    strip.setPixelColor(0, strip.Color(0, 0, 0)); // Rot}
    strip.show();
    delay(dauer);
    strip.setPixelColor(i, strip.Color(0, 0, 0)); // Ausschalten
  }
}

void loop() {
  //rundumlichtEffekt(150); // Die Zahl gibt die Verzögerung zwischen den LEDs an (in Millisekunden)

   if (Serial.available() > 0) {
    char command = Serial.read();
    if (command == 'J') { // 'J' für "Ja"
      digitalWrite(ledPin, HIGH);
      Serial.println("LED eingeschaltet");
      ledstat = 1;
      Serial.println(ledstat);
                      
    } else if (command == 'N') { // 'N' für "Nein"
      digitalWrite(ledPin, LOW);
      Serial.println("LED ausgeschaltet");
      ledstat = 0;
      Serial.println(ledstat);
    }
}

if (ledstat == 1)
{
  rundumlichtEffekt(150);
  }
else if (ledstat ==0)
{
  strip.show(); // Initialize all pixels to 'off'
  strip.setPixelColor(0, strip.Color(0, 153, 0)); // Rot}
}
}
