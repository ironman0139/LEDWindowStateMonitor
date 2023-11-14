#include <Adafruit_NeoPixel.h>

#define PIN            6  // Hier den Pin für die NeoPixel angeben
#define NUMPIXELS      7 // Anzahl der NeoPixel LEDs
#define WAIT_TIME      100 // Wartezeit zwischen den Änderungen der Lichter in Millisekunden

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  pixels.begin(); // Initialisierung der NeoPixel
}

void loop() {
  policeLights(5); // Funktion für Polizeilichtsequenz aufrufen
}

// Funktion für die Polizeilichtsequenz
void policeLights(int iterations) {
  for (int i = 0; i < iterations; i++) {
    for (int j = 0; j < 3; j++) {
      setAllPixelsColor(pixels.Color(0, 0, 0)); // Alle LEDs ausschalten
      
      if (j == 0) {
        setAllPixelsColor(pixels.Color(0, 0, 127)); // Alle LEDs auf Blau setzen
      } else if (j == 1) {
        setAllPixelsColor(pixels.Color(255, 255, 255)); // Alle LEDs auf Weiß setzen
      } else {
        setAllPixelsColor(pixels.Color(127, 0, 0)); // Alle LEDs auf Rot setzen
      }
      
      pixels.show();
      delay(WAIT_TIME);
    }
  }
}

// Funktion, um alle LEDs auf eine bestimmte Farbe zu setzen
void setAllPixelsColor(uint32_t color) {
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels.setPixelColor(i, color);
  }
}
