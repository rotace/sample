pkg load arduino

a = arduino();
pin = "d12"
c=0; % counter
s=0; % state

unwind_protect
  while (true)
    din = readDigitalPin(a, pin);
    if(din == 0 && s == 0)
      c = c+1;
      disp(["c=",num2str(c)])
      s = 1;
    end
    if(din == 1 && s == 1)
      s = 0;
    end
  end
unwind_protect_cleanup
  clear a
end_unwind_protect
