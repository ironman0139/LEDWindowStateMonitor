int ledPin = 13;

void setup() {
  Serial.begin(9600); // Baudrate anpassen, falls erforderlich
  pinMode(ledPin, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    char command = Serial.read();

    if (command == 'J') { // 'J' für "Ja"
      digitalWrite(ledPin, HIGH);
      Serial.println("LED eingeschaltet");
    } else if (command == 'N') { // 'N' für "Nein"
      digitalWrite(ledPin, LOW);
      Serial.println("LED ausgeschaltet");
    }
  }
}
