%�ċA�I�ɒ�`����鍂���t�[���G�ϊ�
%�o�͕ϐ� X=���U�t�[���G�ϊ�
%���͕ϐ� x=�M��
function [X] = recfft(x)
N = length(x);                      %�M���̒���
if 2^fix(log2(N)) ~= N              %N��2�ׂ̂���łȂ����
   error('N is not a power of 2');  %�G���[��\�����āC��~
end;   
if N == 1                           %N=1�Ȃ��
     X = x;                         %X��x����
   else                             %N=1�łȂ��Ȃ��
     m = 0:N/2-1;                   %�����̃C���f�b�N�X
     x0 = x(2*m +1);                %�����C���f�b�N�X�̐M�� x0
     x1 = x(2*m+1 +1);              %��C���f�b�N�X�̐M�� x1
     X0 = recfft(x0);               %x0��FFT���ċA�I�Ɍv�Z
     X1 = recfft(x1);               %x1��FFT���ċA�I�Ɍv�Z
     k = 0:N/2-1;                   %���g���̃C���f�b�N�X
     WNk = exp(-j*2*pi*k/N);        %��]���q
     WNkX1 = WNk.*X1;               %��]���q��X1�̐�
     X = [X0+WNkX1, X0-WNkX1];      %X0��X1�̓���
end