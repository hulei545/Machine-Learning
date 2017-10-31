clc;clear all ; close all;
load('264_optdigits.mat');

% PCA
[mapped_PCA, mapping_PCA] = compute_mapping(data, 'PCA');
figure; 
title('Result of PCA');
xlabel('First Eigenvector');
ylabel('Second Eigenvector');
hold on ;

for i=1:N
x = mapped_PCA(i,1);
y = mapped_PCA(i,2);
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
hold off
% scatter(mapped_PCA(:,1), mapped_PCA(:,2), 5,labeledData(:,1)); 


% LDA
[mapped_LDA, mapping_LDA] = compute_mapping(labeledData, 'LDA');
figure;
% scatter(mapped_LDA(:,1), mapped_LDA(:,2), 5,labeledData(:,1)); 
title('Result of LDA');
xlabel('First Eigenvector');
ylabel('Second Eigenvector');
hold on ;

for i=1:N
x = mapped_LDA(i,1);
y = mapped_LDA(i,2);
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
hold off

%MDS
[mapped_MDS, mapping_MDS] = compute_mapping(data, 'MDS');
figure;
% scatter(mapped_MDS(:,1), mapped_MDS(:,2), 5,labeledData(:,1)); 
title('Result of MDS');
xlabel('First Eigenvector');
ylabel('Second Eigenvector');
hold on ;

for i=1:N
x = mapped_MDS(i,1);
y = mapped_MDS(i,2);
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
hold off

% Laplacian
for k = [12 120 1200 12000 ]
[mapped_Laplacian, mapping_Laplacian] = compute_mapping(data, 'Laplacian',2,k,1);
figure;
% scatter(mapped_Laplacian(:,1), mapped_Laplacian(:,2), 5,labeledData(:,1)); 
title(['Result of Laplacian when k = ',num2str(k)]);
xlabel('First Eigenvector');
ylabel('Second Eigenvector');
hold on ;

for i=1:N
x = mapped_Laplacian(i,1);
y = mapped_Laplacian(i,2);
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
hold off

end