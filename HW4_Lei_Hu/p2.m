clc;clear all ; 
load('264_optdigits.mat');
perror = zeros(64,1);
for k = 1:64
    [Z,Xr,Xrm] = pca(data,k);
     perror(k) = Xrm;
end 
T = 1:64;
plot(T,perror,'-.o');
title('Error vs Number of Principal Components' );
xlabel('Number');
ylabel('Error');
[Z2,Xr2,Xrm2] = pca(data,2);
N = size(Z2,1);
figure;
title('Optdigits after PCA');
xlabel('First Eigenvector');
ylabel('Second Eigenvector');
hold on;
for i=1:N
x = Z2(i,1);
y = Z2(i,2);
switch  dig_tra(i,65) 
    case 0    
       g1 = plot(x,y,'+','Color',[0 0 0]);%'b+'
    case 1
       g2 = plot(x,y,'o','Color',[1 0 0]); 
    case 2
       g3 = plot(x,y,'.','Color',[0 1 0]);
    case 3
       g4 = plot(x,y,'d','Color',[0 0 1]);
    case 4
        g5 = plot(x,y,'*','Color',[1 1 0]);
    case 5
         g6 = plot(x,y,'s','Color',[1 0 1]);
    case 6
         g7 = plot(x,y,'x','Color',[0 1 1]);
    case 7
         g8 = plot(x,y,'v','Color',[0.667 0.667	1]);
    case 8
         g9 = plot(x,y,'^','Color',[1	0.5	0]);
    case 9
         g10 = plot(x,y,'p','Color',[0.5	0	 0]);
end;
end;
legend([g1,g2,g3,g4,g5,g6,g7,g8,g9,g10],'0','1','2','3','4','5','6','7','8','9');
hold off;
% mappedA =  compute_mapping(data,'PCA');
% mappedB =  compute_mapping(data,'LDA');


