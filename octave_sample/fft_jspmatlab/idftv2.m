%���U�t�[���G�ϊ��𗘗p�����t�ϊ�
%�o�� x=�M��
%���� X=���U�t�[���G�ϊ�
function [x] = idftv2(X) 
N = length(X);              %�M���̒���
x =  conj(dft(conj(X)))/N;  %���U�t�[���G�t�ϊ��̌v�Z