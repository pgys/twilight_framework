# twilight_framework

The code processes impulse values caused by piezo sensors, on which water drops are falling. 

The Arduino code take the values from the piezo impulses and sends them via I2C to the Raspberry its connected with.
Beside this the impulses are converted to the MIDI format and send to the serial port, means USB. 

The python skript fetch_value.py is meant to be run on the Raspberry Pi counts the amount of impulses by time using the pytai library and writes them into a file. plot.py reads out the file and visualizes the values. 

The processing code is meant to be executed on an external computer connected by USB to the Arduino. To run the skript the creation of a virtual MIDI device is needed. When you execute the skript for the first time you will find names of MIDI-in and MIDI-out devices. Exchange them with the corresponding expressions on the skript. Execute the skript. 
Now you should be able to connect your DAW with the virtual MIDI port. 

