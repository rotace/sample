function spygray(A)
A=A';
[mx,my]=size(A);

for i=1:mx
    for j=1:my
	A=abs(A);
    end
end

pcolor([A,zeros(mx,1);
	zeros(1,my+1)]);
colorbar;
axis square;

end
