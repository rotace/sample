%���U�t�[���G�ϊ�
%�o�͕ϐ� X=���U�t�[���G�ϊ�
%���͕ϐ� x=�M��
function [X] = dft(x) 
N = length(x);            %�M���̒���
n = 0:N-1; k = 0:N-1;     %�����Ǝ��g���̃C���f�b�N�X
kn = k.'*n;               %�����Ǝ��g���̃C���f�b�N�X�̐�
WN = exp(-j*2*pi/N).^kn;  %��]���q�̍s��
X = x*WN.';               %���U�t�[���G�ϊ��̌v�Z