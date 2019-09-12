#include <Wire.h>

//Zählt die Klopfzeichen
int counter = 0;

// Ausgangspin für die LED
int ledPin = 13;
 
// erster Analog-Pin für die Piezo-Sensoren
int piezoPin= 0;   

//Anzahl der abgefragten Eingänge
const int piezoPinNum=4; 

//Zykluszeit der Eingangsabfrage
int delayTime=10;

// Wartezeit, bis nach einem Ereignis der Eingang wieder abgefragt wird, damit ein Klopfzeichen nicht mehrfach gewertet wird
int waitCycles=20; 

//Array zum Spechern der Wartezeiten
int cycles[piezoPinNum];        
 
// Aktuell gemessener Wert
int wert = 0;
 
// Aktuelle Status der LED (wechselt bei Piezo-Klopfzeichen)
int ledStatus = LOW;
 
// WICHTIG: Diesen Wert zwischen 0 und 1023 anpassen, wenn Klopfzeichen nicht (oder zu oft) erkannt werden
int schwelle=5;

// Bei einer Anfrage vom Raspberry über I2C den Counter-Wert zurückliefern
void requestEvent(){
  Wire.write(counter);
}
 
// setup() wird einmalig beim Programmstart ausgeführt
void setup() {

  //I2C-Initialisierung
  Wire.begin(42);
  Wire.onRequest(requestEvent);
 
  // Pin 13 für die LED als Ausgangspin setzen
  pinMode(ledPin, OUTPUT); 
 
  // Serielle Übertragung zum PC starten
  Serial.begin(115200);
}
 
// loop() wird nach setup() ununterbrochen ausgeführt
void loop() {
  
  // Die Eingänge nacheinander abfragen
  for(int num=0;num<piezoPinNum;num++) {
    
    //In der Wartezeit den jeweiligen Eingang ignorieren
    if (cycles[num]>0) {
      cycles[num]--;
    } else {
      
      // Eingangswerte lesen
      wert = analogRead(piezoPin+num);
      
       // Liegt der Wert über dem oben definierten Schwellenwert? Dann Ereignis auslösen  
      if (wert >= schwelle) {
        // Wartezeit für den jeweiligen Eingang setzen
        cycles[num]=waitCycles; 
        
        // Pin 13 auf den Status setzen
        digitalWrite(ledPin, HIGH);
        
        // Wert zu Testzwecken an den PC schicken
        Serial.println(num);
        Serial.println(wert);
        counter++;
        if (counter > 255)
          counter =0;
      }
    }
  }
  delay(delayTime);
  digitalWrite(ledPin, LOW);
}
