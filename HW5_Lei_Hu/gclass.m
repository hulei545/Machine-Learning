function    [label g]= gclass(Val_ds,EM1,EM2) 
global pc1;
global pc2;       
num = size(Val_ds,1);
label = ones(num,1);
g = zeros(num,1);
%likelihood for two classes
lk1 = grec(Val_ds,EM1);
lk2 = grec(Val_ds,EM2);
% Class = gclass(Val_ds, EM1,EM2);
pxc1= lk1*(EM1{1})';
pxc2 = lk2*(EM2{1})';
px = pxc1.*pc1 + pxc2.*pc2;
pc1x = (pxc1.*pc1)./px;
pc2x = (pxc2.*pc2)./px;

for i = 1:num 
   g(i) = pc1x(i) - pc2x(i);
     if pc1x(i) >= pc2x(i) 
         label(i) = 1;
     else 
         label(i) = 0;
     end
end



end