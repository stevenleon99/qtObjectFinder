===========
Directions:
===========

1. Install "Fraps real-time video capturing & benchmarking"[1]. Use default installation paths.

2. Install the "Java SE Development Kit"[2]; any recent version will work. Use default installation paths.

3. Ensure the following environment variables are set in your System PATH: 

   a. "C:\ProgramData\Oracle\Java\javapath;"

   b. "C:\Program Files (x86)\Java\jdk*\bin;" The jdk* folder will change to reflect your Java SE version number.

3. Launch the Fraps application. Press "Hide Overlay" on the FPS tab.

4. Launch the EPIC application, with any included changes or configuration you want to test the FPS of.

5. Open a command prompt, and navigate to "C:\Development\epic-a\rps-client\testcode\test-fps".

6. Enter the command "java testFPS *". The * argument sets the application to run a specific amount of times.

   Example: "java testFPS 100" will log the maximum, minimum, and average FPS for 100 iterations. 

7. View the results of the FPS test in "C:\Fraps\Benchmarks\FRAPSLOG.txt" or "C:\Fraps\FRAPSLOG.txt"

======
Links:
======

[1]: http://www.fraps.com/

[2]: http://www.oracle.com/technetwork/java/javase/downloads/index.html

================
Troubleshooting:
================

1. Error: 'java' is not recognized as an internal or external command, operable program or batch file.
   
   Solution: Java environment variable is not set in the PATH. Make sure the value is set or explicitly declare the path.

2. Error: Could not find or load main class testFPS.java

   Solution: You attempted to run the .java file. Make sure to enter "java testFPS" instead of "java testFPS.java".