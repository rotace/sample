%���U���ԃt�[���G�t�ϊ�
%�o�͕ϐ� x=�M��
%���͕ϐ� X=���U�t�[���G�ϊ�
function [x] = idft(X) 
N = length(X);                  %�M���̒���
n = 0:N-1; k = 0:N-1;           %�����Ǝ��g���̃C���f�b�N�X
kn = k.'*n;                     %�����Ǝ��g���̃C���f�b�N�X�̐�
WNinv = exp(-j*2*pi/N).^(-kn);  %��]���q�̍s��
x = X*WNinv/N;                  %���U�t�[���G�t�ϊ��̌v�Z