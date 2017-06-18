# RobotResetting
This was a diploma work which consists of 3 parts: 
> - mechanic robot
> - controller board 
> - robot emulator app

The robot has 4 directions/axes to move. Also it has RS-232 based API to be manipulated by controller.
Emulator app - to emulate robot in controller tests. They are connected via RS-232. While controller sends commands the emulator draws all 4 robot projections on a form.

**The main task** is to develop controller (includes program on C/C++) that's able to reset robot's state to zero (some predefined state).

----------

Environment 
-------------------
Delphi 7
AVRStudio 4