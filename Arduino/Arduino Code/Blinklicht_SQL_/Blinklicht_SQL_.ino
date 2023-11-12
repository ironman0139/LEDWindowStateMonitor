// Tim Eisenmann LEDWindowStateMonitor v0.06

#include <Adafruit_NeoPixel.h>

#define PIN            6  // Hier den Pin definieren, an dem die Datenleitung der WS2812 angeschlossen ist
#define NUMPIXELS      7  // Anzahl der LEDs in deinem Ring
int ledPin = 13;
int ledstat = 0;
int lastR = 0; // zuletzt empfangener R-Wert
int lastG = 255; // zuletzt empfangener G-Wert
int lastB = 0; // zuletzt empfangener B-Wert

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(9600); // Baudrate anpassen, falls erforderlich
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}

void rundumlichtEffekt(int dauer) {
  // Rundumlicht-Effekt
  for (int i = 1; i < NUMPIXELS; i++) {
    strip.setPixelColor(i, strip.Color(255, 69, 0)); // Rot
    strip.setPixelColor(0, strip.Color(0, 0, 0)); // Rot
    strip.show();
    delay(dauer);
    strip.setPixelColor(i, strip.Color(0, 0, 0)); // Ausschalten
  }
}

void setzeFarbe(int r, int g, int b) {
  strip.setPixelColor(0, strip.Color(r, g, b));
  strip.show();
  // Speichere die zuletzt empfangenen RGB-Werte
  lastR = r;
  lastG = g;
  lastB = b;
}

void loop() {
  // rundumlichtEffekt(150); // Die Zahl gibt die Verzögerung zwischen den LEDs an (in Millisekunden)

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

      // RGB-Werte von der seriellen Schnittstelle lesen
      int r = Serial.parseInt();
      int g = Serial.parseInt();
      int b = Serial.parseInt();

      // Sicherstellen, dass die RGB-Werte im gültigen Bereich liegen (0-255)
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);

      // Setze die Farbe auf Basis der empfangenen RGB-Werte
      setzeFarbe(r, g, b);
    }
  }

  if (ledstat == 1) {
    rundumlichtEffekt(200);
  } else if (ledstat == 0) {
    strip.show(); // Initialize all pixels to 'off'
    // Setze die Farbe auf Basis der zuletzt empfangenen RGB-Werte
    setzeFarbe(lastR, lastG, lastB);
  }
}
