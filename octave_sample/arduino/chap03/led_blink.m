pkg load arduino

a = arduino();
leds = getLEDTerminals(a);
led = getPinsFromTerminals(a, leds{1});

unwind_protect
  disp("starting to blink...\n");
  while (true)
    writeDigitalPin(a, led, 0);
    pause(0.5);
    writeDigitalPin(a, led, 1);
    pause(0.5);
  endwhile
unwind_protect_cleanup
  clear a
end_unwind_protect
