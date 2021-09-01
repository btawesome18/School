
i = -1
a = [0,i,1;i,6,i;1,i,0];
temp = 0;
for i = -10:(1/30):20
    a = [0,i,1;i,6,i;1,i,0];
    dert = det(a)
   if det(a)==0;
      temp = [temp,i]
   end
   
    
end

function cofactor = matrizCofactores(A)
  [rows, cols] = size(A);
  if rows == cols
    for i = 1 : rows,
      for j = 1 : cols,
        Menor = A;
        Menor(i,:) = [];
        Menor(:,j) = [];
        if mod((i+j),2) == 0
          cofactor(i,j) = det(Menor);
        else
          cofactor(i,j) = -det(Menor);
        end
      end
    end
  end
end

function [det_mat] = detMat(m)
[nr, nc] = size (m);
if (nr == nc) 
  len = length(m);
  det_mat{1} = m;           %% Input matrix in first place
  det_mat{5} = det(m);  %% Determinant in fourth place
  for order = len - 1 : len - 1
     perms = nchoosek(1:len,order);      % Map to skip rows and columns
       for i = 1 : length(perms)
          for j = 1 : length(perms)
              %% The Minors
              det_mat{2}(len+1-i,len+1-j) = det(m(perms(i,1:end),perms(j,1:end)));
              %% The Masked Minors   
              if (mod(abs(i-j),2) == 1)
                det_mat{3}(len+1-i,len+1-j) = -1 * (det_mat{2}(len+1-i,len+1-j));
              else
                det_mat{3}(len+1-i,len+1-j) = det_mat{2}(len+1-i,len+1-j);
              end
              temp_mat(len+1-i,len+1-j) = det_mat{3}(len+1-i,len+1-j);              
          end
       end
  end
  %% Make Adjunct by Transpose off-diagonal elements %% Yes, you can use adjoint(A)
  for j = 1 : length(perms)
    for i = 1 : length(perms)
       det_mat{4}(i,j) = temp_mat(j,i);
    end
  end
  %% The final Inverse Yes,you can use inv(m)
  det_mat{6} = 1/det_mat{5}*det_mat{4};
  det_mat{7} = [' 1)Your matrix ' ' 2)Minors ' ' 3)Masked ' ' 4)Adjunct ' ' 5)Determinant ' ' 6)Inverse'];
  
  end
end
