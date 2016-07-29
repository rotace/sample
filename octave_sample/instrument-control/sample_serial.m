home = "/home/yasunori"

## LOAD instrument-control package
loadpkg
disp("load instrument-control package")

# Opens serial port ttyUSB1 with baudrate of 38400 (config defaults to 8-N-1)
s1 = serial([home,"/dev/ttyS0"], 38400)


## ex) send message
disp("send message into ttyS1. please check.")
# Flush input and output buffers
srl_flush(s1); 
# Blocking write call, currently only accepts strings
srl_write(s1, "Hello world!")

disp("(press any key to go next)")
pause

## ex) receive message
disp("waiting to receive message from ttyS0. please write on ttyS0.")
# Blocking read call, returns uint8 array of exactly 12 bytes read
data = srl_read(s1, 12)  
# Convert uint8 array to string, 
char(data)

disp("(press any key to finish)")
pause

fclose(s1) # Closes and releases serial interface object
