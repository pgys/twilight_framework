import processing.serial.*;
import themidibus.*;

int lf = 10;    // Linefeed in ASCII

Serial myPort;  // The serial port
MidiBus myBus; // The MidiBus

void setup() {
  size(400, 400);
  background(0);
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  // you have to run the code once, then check the console which devices are available,
  // then replace the name below
  myPort = new Serial(this, "COM5", 115200);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  // Either you can
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  // or you can ...
  //                   Parent         In                   Out
  //                     |            |                     |
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.

  // or for testing you could ...
  //                 Parent  In        Out
  //                   |     |          |
  myBus = new MidiBus(this, -1, "LoopBe Internal MIDI"); // Create a new MidiBus with no input device and an existing midi device as output (see console for available devices once code was run).
}

void draw() {
  while (myPort.available() > 0) {
    //String inBuffer = myPort.readString();
    String inBuffer = myPort.readStringUntil(lf);
    if (inBuffer != null) {
      println("----");
      println(inBuffer);
      String[] numbersAsString = inBuffer.split(",");
      int[] numbers = new int[numbersAsString.length];
      for (int i=0; i<numbersAsString.length; i++) {
        // convert string to int and make sure to trim remaining whitespace characters
        numbers[i] = int(numbersAsString[i].trim());
      }
      // a "correct" message should look like this: "1,123", and therefore contain two numbers
      if (numbers.length >= 2) {
        print("Piezo Number: "); print(numbers[0]); print(", value: "); print(numbers[1]);
        println(""); // end the line
        // here you would do something else with numbers[0] and numbers[1] (e.g. use them in The MidiBus library)
        //int channel = 0;
        int channel = numbers[0]; // use first incoming number as channel
        int pitch = 64;
        //int velocity = 127;
        int velocity = numbers[1];  // use first incoming number as velocity
        myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
        //delay(200);
        // TODO: send note off? how long must the delay be between noteon and noteoff?
        // We cannot use delay() here, because we would miss out on incoming serial messages
        // But maybe we don't need to send a noteoff after all
        //myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
      
        //int number = 0;
        //int value = 90;
        //myBus.sendControllerChange(channel, number, value); // Send a controllerChange
      }
    }
  }
  //delay(2000);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
