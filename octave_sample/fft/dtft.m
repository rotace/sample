%���U���ԃt�[���G�ϊ�
%�o�͕ϐ�  X=���U���ԃt�[���G�ϊ�
%���͕ϐ�  x=�M���Cn=����, w=���g���̊i�q�_
function X = dtft(x,n,w)
X = zeros(1,length(w));		%X��������
for q = 1:length(w)             
   X(q) = x*exp(-j*w(q)*n).';	%X(q)�����߂�
end
