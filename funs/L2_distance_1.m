% compute squared Euclidean distance   计算每个样本到其他样本之间的距离，只不过用矩阵的形式来处理了而已
% ||A-B||^2 = ||A||^2 + ||B||^2 - 2*A'*B
function d = L2_distance_1(a,b)
% a,b: two matrices. each column is a data
% d:   distance matrix of a and b



if (size(a,1) == 1)
  a = [a; zeros(1,size(a,2))]; 
  b = [b; zeros(1,size(b,2))]; 
end

%.*矩阵对应元素相乘  *矩阵相乘
aa=sum(a.*a); bb=sum(b.*b); ab=a'*b; 
d = repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab;

d = real(d);  %复数转化为实数
d = max(d,0); %(d,k)d中的元素大于等于k那么该元素保留，否则，赋值为k，如果只有max(d)那么默认返每一列中的最大值
%max(d,[],1)返回每一列中的最大值 max(d,[],2)返回每一行中的最大值

% % force 0 on the diagonal? 
% if (df==1)
%   d = d.*(1-eye(size(d)));
% end
