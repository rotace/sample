function a_fdp_nonstif
	 
  t = [0 : 0.1 : 20];
  x_0 = [2;0];
  [y, istate, msg] = lsode(@vdp1, x_0, t);

  display(["istate is ",num2str(istate)]);

  plot(t,y(:,1),'-', t,y(:,2),'--')
  xlabel('time t');
  ylabel('solution y');

end

function dydt = vdp1(y,t);
  dydt = [y(2); (1-y(1)^2)*y(2)-y(1)];
end
