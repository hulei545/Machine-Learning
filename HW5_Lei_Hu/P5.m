clc;clear all;close all;
xa=2; xb=4; ya=1; yb=3;
rand('state',99);
ct = 1;
% initialization of genralization error 
err_rate = ones(4,5);

for N = [50 100 200 500]
    
%%%%%%%% training data
ds=zeros(N,2); ls=zeros(N,1);       % labels
figure;
title(['Traing Data : N = ',num2str(N)]);
hold on;
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it

for i=1:N
x=rand(1,1)*5; y=rand(1,1)*5;
ds(i,1)=x; ds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) ls(i)=1;
else ls(i)=0; end;
if (ls (i)==1) plot(x,y,'+'); else plot(x,y,'go'); end;
end;
hold off ;
%%%%%%%%%

% parameters in training set 
positives=ds(find(ls==1),:);
negatives=ds(find(ls==0),:);
global pc1;
global pc2;
pc1 = size(positives ,1)/N;
pc2 = size(negatives,1)/N;


%%%%%%% training in EM algorithm 
cl_cnt = 1 ;
for C = [ 1 2 4 8 16 ]

try 
EM1 = [];
EM2 = [];
 
EM1 = gtrain(C,positives);
EM2 = gtrain(C,negatives);

%%%%%%%  

%%%%%% Validation Part 
Val_N = N;
Val_ds=zeros(Val_N,2); Val_ls=zeros(Val_N,1);       % labels
figure;
title(['Validation Data : N = ',num2str(Val_N),' Cluster = ',num2str(C)]);
hold on;
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
% validation data
for i=1:Val_N
x=rand(1,1)*5; y=rand(1,1)*5;
Val_ds(i,1)=x; Val_ds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) Val_ls(i)=1;
else Val_ls(i)=0; end;
if (Val_ls (i)==1) plot(x,y,'+'); else plot(x,y,'go'); end;
end;
%%%%%%%%%

%%%%%%% Classifier by function gclass 
% Class = ones(Val_N,1);
[Class Z] = gclass(Val_ds,EM1,EM2);

% generalization error 
error = 0;
for i = 1:Val_N
    if Val_ls(i) ~= Class(i)
        error = error +1 ;
    end
end
error = error/Val_N;         
err_rate(ct,cl_cnt) = error;   

%%%% graphs for decision boundary 
[X1,X2] = meshgrid(0:0.1:5,0:0.1:5); 
for i = 1:size(X1,2)
   for j = 1:size(X2,1)
        input = [X1(i,j) X2(i,j)];
        [l,Zg(i,j)] = gclass(input,EM1,EM2);   
               
   end
end
[ c1, h1] = contour(X1,X2,Zg,[0 0],'r','LineWidth',2);
hold off;
%%%%%%%%%%%%%
catch
fprintf('error for cluster = %d !!!\n',C);
err_rate(ct,cl_cnt) = NaN;
end
cl_cnt = cl_cnt + 1;
end
% catch 
%    continue;
% end
ct = ct +1;
end;
figure ;
title('Generalization Error');
xlabel('Number of data points');
ylabel('Error Rate');
hold on;
num = [50 100 250 500];
plot(num,err_rate(:,1),'rs-');
plot(num,err_rate(:,2),'bd-');
plot(num,err_rate(:,3),'y*-');
plot(num,err_rate(:,4),'mv-');
plot(num,err_rate(:,5),'cp-');
legend('Cluster = 1','Cluster = 2','Cluster = 4','Cluster = 8','Cluster = 16');
hold off;





