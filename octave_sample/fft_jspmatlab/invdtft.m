%���l�ϕ��ɂ�闣�U���ԃt�[���G�t�ϊ�
%�o�͕ϐ� x=�M��
%���͕ϐ� X=���U���ԃt�[���G�ϊ��̃x�N�g���Cw=���g���i�q�_�̃x�N�g��
%         n=�����̃x�N�g��
function x = invdtft(X,w,n)		
dw = w(2)-w(1);                           %���g���i�q�_�̊Ԋu
x = zeros(1,length(n));                   %�M���̏�����
for p = 1:length(n)
   x(p) = 1/(2*pi)*X*exp(j*w*n(p)).'*dw;  %���l�ϕ��ɂ��t�ϊ��̌v�Z
end