
n=4000; A=rand(n); B=rand(n);
tic(); C=A*B;
t=toc()
GFLOPS=2*n^3/t*1e-9

[fid,message]=fopen('result.dat','a');
message
fprintf(fid,'%f\t%f\n',t,GFLOPS);
status=fclose(fid);