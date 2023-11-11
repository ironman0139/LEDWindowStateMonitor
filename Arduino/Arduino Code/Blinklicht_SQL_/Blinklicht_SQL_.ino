#include <Adafruit_NeoPixel.h>

#define PIN            6  // Hier den Pin definieren, an dem die Datenleitung der WS2812 angeschlossen ist
#define NUMPIXELS      6  // Anzahl der LEDs in deinem Ring

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int ledPin = 13;

void setup() {
  Serial.begin(9600); // Baudrate anpassen, falls erforderlich
  pinMode(ledPin, OUTPUT);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}

void rundumlichtEffekt(int dauer) {
  // Rundumlicht-Effekt mit zwei gleichzeitig leuchtenden orangefarbenen LEDs
  for (int i = 0; i < NUMPIXELS; i++) {
    int nextIndex = (i + 1) % NUMPIXELS; // Index der nächsten LED im Ring
    strip.setPixelColor(i, strip.Color(255, 69, 0)); // Orange (255, 69, 0) ist die RGB-Farbe für Orange
    strip.setPixelColor(nextIndex, strip.Color(255, 69, 0)); // Orange
    strip.show();
    delay(dauer);
    strip.setPixelColor(i, strip.Color(0, 0, 0)); // Ausschalten
    strip.setPixelColor(nextIndex, strip.Color(0, 0, 0)); // Ausschalten
  }
}

void loop() {
  if (Serial.available() > 0) {
    char command = Serial.read();

    if (command == 'J') { // 'J' für "Ja"
      digitalWrite(ledPin, HIGH);
      Serial.println("LED eingeschaltet");
      rundumlichtEffekt(50);
    } else if (command == 'N') { // 'N' für "Nein"
      digitalWrite(ledPin, LOW);
      Serial.println("LED ausgeschaltet");
    }
  }
}
