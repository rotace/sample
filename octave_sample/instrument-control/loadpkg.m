pkg load instrument-control

if (exist("serial") == 3)
  disp("Serial: Supported")
else
  disp("Serial: Unsupported")
endif

