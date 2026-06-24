{ ... }:
{
  xdg.configFile."dolphin-emu/Dolphin.ini".text = ''
    [Core]
    GFXBackend = Vulkan
    [DSP]
    DSPThread = True
    [General]
    ISOPath0 = /home/meihapps/dolphins
    ISOPaths = 1
    [NetPlay]
    TraversalChoice = direct
  '';

  xdg.configFile."dolphin-emu/GFX.ini".text = ''
    [Enhancements]
    PostProcessingShader =
    [Settings]
    InternalResolution = 2
  '';

  xdg.configFile."dolphin-emu/GCPadNew.ini".text = ''
    [GCPad1]
    Device = evdev/0/Microsoft Xbox Series S|X Controller
    Buttons/A = SOUTH
    Buttons/B = EAST
    Buttons/X = NORTH
    Buttons/Y = WEST
    Buttons/Z = TR
    Buttons/Start = START
    Main Stick/Up = `Axis 1-`
    Main Stick/Down = `Axis 1+`
    Main Stick/Left = `Axis 0-`
    Main Stick/Right = `Axis 0+`
    Main Stick/Modifier = THUMBL
    Main Stick/Calibration = 100.00 101.96 105.85 102.80 103.79 108.84 108.24 101.96 100.00 101.96 108.24 120.27 124.79 119.12 108.24 101.96 100.00 101.96 108.24 117.04 118.65 119.18 108.24 101.96 100.00 101.96 108.24 109.41 112.86 112.01 106.26 101.43
    C-Stick/Up = `Axis 4-`
    C-Stick/Down = `Axis 4+`
    C-Stick/Left = `Axis 3-`
    C-Stick/Right = `Axis 3+`
    C-Stick/Modifier = THUMBR
    C-Stick/Calibration = 100.00 101.96 101.24 106.64 113.02 113.80 107.42 101.96 100.00 101.96 108.24 114.48 114.06 116.27 108.24 101.96 100.00 101.96 108.24 120.27 124.79 117.42 108.24 101.96 98.45 98.56 102.61 103.41 101.32 109.16 106.24 101.96
    D-Pad/Up = `Axis 7-`
    D-Pad/Down = `Axis 7+`
    D-Pad/Left = `Axis 6-`
    D-Pad/Right = `Axis 6+`
    Triggers/L-Analog = `Full Axis 2+`
    Triggers/R-Analog = `Full Axis 5+`
    [GCPad2]
    Device = XInput2/0/Virtual core pointer
    [GCPad3]
    Device = XInput2/0/Virtual core pointer
    [GCPad4]
    Device = XInput2/0/Virtual core pointer
  '';

  xdg.configFile."dolphin-emu/WiimoteNew.ini".text = ''
    [Wiimote1]
    Device = XInput2/0/Virtual core pointer
    Buttons/A = `Click 1`
    Buttons/B = `Click 3`
    Buttons/1 = `1`
    Buttons/2 = `2`
    Buttons/- = Q
    Buttons/+ = E
    Buttons/Home = Return
    D-Pad/Up = Up
    D-Pad/Down = Down
    D-Pad/Left = Left
    D-Pad/Right = Right
    IR/Up = `Cursor Y-`
    IR/Down = `Cursor Y+`
    IR/Left = `Cursor X-`
    IR/Right = `Cursor X+`
    Shake/X = `Click 2`
    Shake/Y = `Click 2`
    Shake/Z = `Click 2`
    IRPassthrough/Object 1 X = `IR Object 1 X`
    IRPassthrough/Object 1 Y = `IR Object 1 Y`
    IRPassthrough/Object 1 Size = `IR Object 1 Size`
    IRPassthrough/Object 2 X = `IR Object 2 X`
    IRPassthrough/Object 2 Y = `IR Object 2 Y`
    IRPassthrough/Object 2 Size = `IR Object 2 Size`
    IRPassthrough/Object 3 X = `IR Object 3 X`
    IRPassthrough/Object 3 Y = `IR Object 3 Y`
    IRPassthrough/Object 3 Size = `IR Object 3 Size`
    IRPassthrough/Object 4 X = `IR Object 4 X`
    IRPassthrough/Object 4 Y = `IR Object 4 Y`
    IRPassthrough/Object 4 Size = `IR Object 4 Size`
    IMUAccelerometer/Up = `Accel Up`
    IMUAccelerometer/Down = `Accel Down`
    IMUAccelerometer/Left = `Accel Left`
    IMUAccelerometer/Right = `Accel Right`
    IMUAccelerometer/Forward = `Accel Forward`
    IMUAccelerometer/Backward = `Accel Backward`
    IMUGyroscope/Pitch Up = `Gyro Pitch Up`
    IMUGyroscope/Pitch Down = `Gyro Pitch Down`
    IMUGyroscope/Roll Left = `Gyro Roll Left`
    IMUGyroscope/Roll Right = `Gyro Roll Right`
    IMUGyroscope/Yaw Left = `Gyro Yaw Left`
    IMUGyroscope/Yaw Right = `Gyro Yaw Right`
    Extension = Nunchuk
    Nunchuk/Buttons/C = Control_L
    Nunchuk/Buttons/Z = Shift_L
    Nunchuk/Stick/Up = W
    Nunchuk/Stick/Down = S
    Nunchuk/Stick/Left = A
    Nunchuk/Stick/Right = D
    Nunchuk/Stick/Calibration = 100.00 141.42 100.00 141.42 100.00 141.42 100.00 141.42
    Nunchuk/Shake/X = `Click 2`
    Nunchuk/Shake/Y = `Click 2`
    Nunchuk/Shake/Z = `Click 2`
    [Wiimote2]
    Device = XInput2/0/Virtual core pointer
    [Wiimote3]
    Device = XInput2/0/Virtual core pointer
    [Wiimote4]
    Device = XInput2/0/Virtual core pointer
    [BalanceBoard]
    Device = XInput2/0/Virtual core pointer
  '';
}
