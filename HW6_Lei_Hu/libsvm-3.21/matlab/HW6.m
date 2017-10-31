clc;clear all;close all;
load('264_optdigits.mat');
features = data;
labels = labeledData(:,1);
[N D] = size(data);
% Determine the train and test index
trainIndex = zeros(N,1);trainIndex(1:1000) = 1;
testIndex = zeros(N,1);testIndex(1001:N) = 1;
trainData = features(trainIndex==1,:);
trainLabel = labels(trainIndex==1,:);
testData = features(testIndex==1,:);
testLabel = labels(testIndex==1,:);

%%%%%%%%%%%%%%% Liner SVM %%%%%%%%%%
% cross validation 
stepSize = 1;
log2c_list = -10:stepSize:0;
numLog2c = length(log2c_list);
bestcv = 0;
for i = 1:numLog2c
    log2c = log2c_list(i);
     % -v 5--> 5-fold cross validation
        param = ['-q -v 5 -s 0 -t 0 -c ', num2str(2^log2c)];
        cv = svmtrain(trainLabel, trainData, param);
        if (cv >= bestcv),
            bestcv = cv; bestLog2c = log2c;
            bestc = 2^bestLog2c;
        end
end
fprintf('(best c=%g, rate=%g)\n', bestc, bestcv);
param = ['-s 0 -t 0 -b 1 -c ', num2str(bestc)];
% % Train the SVM
model = svmtrain(trainLabel, trainData,param);
% % % Use the SVM model to classify the data
[predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model, '-b 1'); % run the SVM model on the test data

% confusion matrix for the validation data
ln_conf_matrix = zeros(10,10);
for k = 0:9
    ln_scan = predict_label(find(testLabel==k));
    num_ln_scan = length(ln_scan);
 for i = 1:num_ln_scan
    switch  ln_scan(i)
    case 0    
       ln_conf_matrix(k+1,1) = ln_conf_matrix(k+1,1) + 1;
    case 1
       ln_conf_matrix(k+1,2) = ln_conf_matrix(k+1,2) + 1;
    case 2
       ln_conf_matrix(k+1,3) = ln_conf_matrix(k+1,3) + 1;
    case 3
       ln_conf_matrix(k+1,4) = ln_conf_matrix(k+1,4) + 1;
    case 4
       ln_conf_matrix(k+1,5) = ln_conf_matrix(k+1,5) + 1;
    case 5
       ln_conf_matrix(k+1,6) = ln_conf_matrix(k+1,6) + 1;
    case 6
       ln_conf_matrix(k+1,7) = ln_conf_matrix(k+1,7) + 1;
    case 7
       ln_conf_matrix(k+1,8) = ln_conf_matrix(k+1,8) + 1;
    case 8
       ln_conf_matrix(k+1,9) = ln_conf_matrix(k+1,9) + 1;
    case 9
       ln_conf_matrix(k+1,10) = ln_conf_matrix(k+1,10) + 1;
     end;
 end

end

% plot out accuracy and number of SVs
c_lnsize = 0.004;
ln_c_list = (bestc - c_lnsize): c_lnsize/2: (bestc + c_lnsize);
numln_c = length(ln_c_list);

ln_acc = zeros(numln_c,1);
ln_SV = zeros(numln_c,1); 

for i = 1:numln_c
    ln_t_c = ln_c_list(i);
    % scan around the best parameters    
    ln_t_param = ['-s 0 -t 0 -b 1 -c ', num2str(ln_t_c)];
    ln_t_model = svmtrain(trainLabel, trainData,ln_t_param);
    ln_SV(i)  = ln_t_model.totalSV;
    [ln_t_predict_label, ln_t_accuracy, ln_t_prob_values] = svmpredict(testLabel, testData, ln_t_model, '-b 1'); % run the SVM model on the test data
    ln_acc(i) = ln_t_accuracy(1);
   
end

% plot out the graphs for linear function 
figure;
title('Accuracy for linear function');
hold on;
plot(ln_c_list,ln_acc,'bo-');
xlabel('c');
ylabel('Accuracy (%)');
hold off ;
figure;
title('Number of SVs for linear function');
hold on;
xlabel('c');
ylabel('SV');
plot(ln_c_list,ln_SV,'ro-');
hold off ;

%%%%% Dimensionality Reduction 
% 32D using PCA 
% PCA
[mapped_PCA_32D, mapping_PCA_32D] = compute_mapping(data, 'PCA',32);
trainData_32D = mapped_PCA_32D(trainIndex==1,:);
testData_32D = mapped_PCA_32D(testIndex==1,:);
% % Train the SVM
ln_32D_model = svmtrain(trainLabel, trainData_32D,param);
% % % Use the SVM model to classify the data
[ln_32D_predict_label, ln_32D_accuracy, ln_32D_prob_values] = svmpredict(testLabel, testData_32D, ln_32D_model, '-b 1'); % run the SVM model on the test data
% 16D using PCA 
% PCA
[mapped_PCA_16D, mapping_PCA_16D] = compute_mapping(data, 'PCA',16);
trainData_16D = mapped_PCA_16D(trainIndex==1,:);
testData_16D = mapped_PCA_16D(testIndex==1,:);
% % Train the SVM
ln_16D_model = svmtrain(trainLabel, trainData_16D,param);
% % % Use the SVM model to classify the data
[ln_16D_predict_label, ln_16D_accuracy, ln_16D_prob_values] = svmpredict(testLabel, testData_16D, ln_16D_model, '-b 1'); % run the SVM model on the test data
% 8D using PCA 
% PCA
[mapped_PCA_8D, mapping_PCA_8D] = compute_mapping(data, 'PCA',8);
trainData_8D = mapped_PCA_8D(trainIndex==1,:);
testData_8D = mapped_PCA_8D(testIndex==1,:);
% % Train the SVM
ln_8D_model = svmtrain(trainLabel, trainData_8D,param);
% % % Use the SVM model to classify the data
[ln_8D_predict_label, ln_8D_accuracy, ln_8D_prob_values] = svmpredict(testLabel, testData_8D, ln_8D_model, '-b 1'); % run the SVM model on the test data
% 4D using PCA 
% PCA
[mapped_PCA_4D, mapping_PCA_4D] = compute_mapping(data, 'PCA',4);
trainData_4D = mapped_PCA_4D(trainIndex==1,:);
testData_4D = mapped_PCA_4D(testIndex==1,:);
% % Train the SVM
ln_4D_model = svmtrain(trainLabel, trainData_4D,param);
% % % Use the SVM model to classify the data
[ln_4D_predict_label, ln_4D_accuracy, ln_4D_prob_values] = svmpredict(testLabel, testData_4D, ln_4D_model, '-b 1'); % run the SVM model on the test data
ln_DR_acc = zeros(5,1);
ln_DR_SV = zeros(5,1);
ln_DR_acc(5) = accuracy(1); 
ln_DR_acc(4) = ln_32D_accuracy(1);
ln_DR_acc(3) = ln_16D_accuracy(1);
ln_DR_acc(2) = ln_8D_accuracy(1);
ln_DR_acc(1) = ln_4D_accuracy(1);
ln_DR_SV(5) = model.totalSV;
ln_DR_SV(4) = ln_32D_model.totalSV;
ln_DR_SV(3) = ln_16D_model.totalSV;
ln_DR_SV(2) = ln_8D_model.totalSV;
ln_DR_SV(1) = ln_4D_model.totalSV;
figure;
title('Accuracy for linear function in different dimensions');
Dim = [4 8 16 32 64];
hold on;
plot(Dim,ln_DR_acc,'bo-');
xlabel('Dimension');
ylabel('Accuracy (%)');
hold off ;
figure;
title('SV for linear function in different dimensions');
Dim = [4 8 16 32 64];
hold on;
plot(Dim,ln_DR_SV,'ro-');
xlabel('Dimensionality');
ylabel('SV');
hold off ;



%%%%%%%%%%%%%%% Kernel SVM %%%%%%%%%%%%

%%%%% RB function 
% grid search procedure for cross validation 
stepSize = 1;
log2c_list =8:stepSize:10;
log2g_list = -11:stepSize:-9;
numLog2c = length(log2c_list);
numLog2g = length(log2g_list);
RB_cvMatrix = zeros(numLog2c,numLog2g);
RB_bestcv = 0;
for i = 1:numLog2c
    log2c = log2c_list(i);
    for j = 1:numLog2g
        log2g = log2g_list(j);
        % -v 5 --> 5-fold cross validation
        param = ['-q -s 0 -t 2 -b 1 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
        cv = svmtrain(trainLabel, trainData, param);
        RB_cvMatrix(i,j) = cv;
        if (cv >= RB_bestcv),
            RB_bestcv = cv; RB_bestLog2c = log2c; RB_bestLog2g = log2g;
        end
        % fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
    end
end
% figure;
% imagesc(RB_cvMatrix); colormap('jet'); colorbar;
% set(gca,'XTick',1:numLog2g)
% set(gca,'XTickLabel',sprintf('%3.1f|',log2g_list))
% xlabel('Log_2\gamma');
% set(gca,'YTick',1:numLog2c)
% set(gca,'YTickLabel',sprintf('%3.1f|',log2c_list))
% ylabel('Log_2c');

RB_bestc = 2^RB_bestLog2c;
RB_bestg = 2^RB_bestLog2g;
RB_param = ['-s 0 -t 2 -b 1 -c ', num2str(2^RB_bestLog2c), ' -g ', num2str(2^RB_bestLog2g)];
% % Train the SVM
RB_model = svmtrain(trainLabel, trainData,RB_param);
% % % Use the SVM model to classify the data
[RB_predict_label, RB_accuracy, RB_prob_values] = svmpredict(testLabel, testData, RB_model, '-b 1'); % run the SVM model on the test data

% confusion matrix for validation data
conf_matrix = zeros(10,10);
for k = 0:9
    RB_scan = RB_predict_label(find(testLabel==k));
    num_RB_scan = length(RB_scan);
 for i = 1:num_RB_scan
    switch  RB_scan(i)
    case 0    
       conf_matrix(k+1,1) = conf_matrix(k+1,1) + 1;
    case 1
       conf_matrix(k+1,2) = conf_matrix(k+1,2) + 1;
    case 2
       conf_matrix(k+1,3) = conf_matrix(k+1,3) + 1;
    case 3
       conf_matrix(k+1,4) = conf_matrix(k+1,4) + 1;
    case 4
       conf_matrix(k+1,5) = conf_matrix(k+1,5) + 1;
    case 5
       conf_matrix(k+1,6) = conf_matrix(k+1,6) + 1;
    case 6
       conf_matrix(k+1,7) = conf_matrix(k+1,7) + 1;
    case 7
       conf_matrix(k+1,8) = conf_matrix(k+1,8) + 1;
    case 8
       conf_matrix(k+1,9) = conf_matrix(k+1,9) + 1;
    case 9
       conf_matrix(k+1,10) = conf_matrix(k+1,10) + 1;
     end;
 end

end

% plot out accuracy and number of SVs
c_testsize = 1000;
g_testsize = 0.0008;
RB_c_list = (RB_bestc - c_testsize): c_testsize/2: (RB_bestc + c_testsize);
RB_g_list = (RB_bestg - g_testsize): g_testsize/2: (RB_bestg + g_testsize);
numRB_c = length(RB_c_list);
numRB_g = length(RB_g_list);
RB_acc = zeros(numRB_c,numRB_g);
RB_SV = zeros(numRB_c,numRB_g); 

for i = 1:numRB_c
    RB_t_c = RB_c_list(i);
    for j = 1:numRB_g
        RB_t_g = RB_g_list(j);
    % scan around the best parameters    
    RB_t_param = ['-s 0 -t 2 -b 1 -c ', num2str(RB_t_c), ' -g ', num2str(RB_t_g)];
    RB_t_model = svmtrain(trainLabel, trainData,RB_t_param);
    RB_SV(i,j)  = RB_t_model.totalSV;
    [RB_t_predict_label, RB_t_accuracy, RB_t_prob_values] = svmpredict(testLabel, testData, RB_t_model, '-b 1'); % run the SVM model on the test data
    RB_acc(i,j) = RB_t_accuracy(1);
    end
end
figure;
imagesc(RB_acc); colormap('jet'); colorbar;
title('Accuracy for RB function');
set(gca,'XTick',1:numRB_g)
set(gca,'XTickLabel',sprintf('%3.4f|',RB_g_list))
xlabel('\gamma');
set(gca,'YTick',1:numRB_c)
set(gca,'YTickLabel',sprintf('%3.1f|',RB_c_list))
ylabel('c');
figure;
title('Accuracy for RB function');
hold on;
plot(RB_c_list,RB_acc(:,1),'bo-');
plot(RB_c_list,RB_acc(:,2),'ro-');
plot(RB_c_list,RB_acc(:,3),'co-');
plot(RB_c_list,RB_acc(:,4),'yo-');
plot(RB_c_list,RB_acc(:,5),'ko-');
xlabel('c');
ylabel('Accuracy (%)');
legend(['\gamma = ' num2str(RB_g_list(1))],['\gamma = ' num2str(RB_g_list(2))],['\gamma = ' num2str(RB_g_list(3))],['\gamma = ' num2str(RB_g_list(4))],['\gamma = ' num2str(RB_g_list(5))]);
hold off ;

figure;
imagesc(RB_SV); colormap('jet'); colorbar;
title('Number of SVs for RB function');
set(gca,'XTick',1:numRB_g)
set(gca,'XTickLabel',sprintf('%3.4f|',RB_g_list))
xlabel('\gamma');
set(gca,'YTick',1:numRB_c)
set(gca,'YTickLabel',sprintf('%3.1f|',RB_c_list))
ylabel('c');
figure;
title('Number of SVs for RB function');
hold on;
xlabel('c');
ylabel('SV');
plot(RB_c_list,RB_SV(:,1),'bo-');
plot(RB_c_list,RB_SV(:,2),'ro-');
plot(RB_c_list,RB_SV(:,3),'co-');
plot(RB_c_list,RB_SV(:,4),'yo-');
plot(RB_c_list,RB_SV(:,5),'ko-');
legend(['\gamma = ' num2str(RB_g_list(1))],['\gamma = ' num2str(RB_g_list(2))],['\gamma = ' num2str(RB_g_list(3))],['\gamma = ' num2str(RB_g_list(4))],['\gamma = ' num2str(RB_g_list(5))]);
hold off ;


%%%%% Dimensionality Reduction 
% 32D using PCA 
% PCA
[mapped_PCA_32D, mapping_PCA_32D] = compute_mapping(data, 'PCA',32);
trainData_32D = mapped_PCA_32D(trainIndex==1,:);
testData_32D = mapped_PCA_32D(testIndex==1,:);
% % Train the SVM
RB_32D_model = svmtrain(trainLabel, trainData_32D,RB_param);
% % % Use the SVM model to classify the data
[RB_32D_predict_label, RB_32D_accuracy, RB_32D_prob_values] = svmpredict(testLabel, testData_32D, RB_32D_model, '-b 1'); % run the SVM model on the test data
% 16D using PCA 
% PCA
[mapped_PCA_16D, mapping_PCA_16D] = compute_mapping(data, 'PCA',16);
trainData_16D = mapped_PCA_16D(trainIndex==1,:);
testData_16D = mapped_PCA_16D(testIndex==1,:);
% % Train the SVM
RB_16D_model = svmtrain(trainLabel, trainData_16D,RB_param);
% % % Use the SVM model to classify the data
[RB_16D_predict_label, RB_16D_accuracy, RB_16D_prob_values] = svmpredict(testLabel, testData_16D, RB_16D_model, '-b 1'); % run the SVM model on the test data
% 8D using PCA 
% PCA
[mapped_PCA_8D, mapping_PCA_8D] = compute_mapping(data, 'PCA',8);
trainData_8D = mapped_PCA_8D(trainIndex==1,:);
testData_8D = mapped_PCA_8D(testIndex==1,:);
% % Train the SVM
RB_8D_model = svmtrain(trainLabel, trainData_8D,RB_param);
% % % Use the SVM model to classify the data
[RB_8D_predict_label, RB_8D_accuracy, RB_8D_prob_values] = svmpredict(testLabel, testData_8D, RB_8D_model, '-b 1'); % run the SVM model on the test data
% 4D using PCA 
% PCA
[mapped_PCA_4D, mapping_PCA_4D] = compute_mapping(data, 'PCA',4);
trainData_4D = mapped_PCA_4D(trainIndex==1,:);
testData_4D = mapped_PCA_4D(testIndex==1,:);
% % Train the SVM
RB_4D_model = svmtrain(trainLabel, trainData_4D,RB_param);
% % % Use the SVM model to classify the data
[RB_4D_predict_label, RB_4D_accuracy, RB_4D_prob_values] = svmpredict(testLabel, testData_4D, RB_4D_model, '-b 1'); % run the SVM model on the test data
DR_acc = zeros(5,1);
DR_SV = zeros(5,1);
DR_acc(5) = RB_accuracy(1); 
DR_acc(4) = RB_32D_accuracy(1);
DR_acc(3) = RB_16D_accuracy(1);
DR_acc(2) = RB_8D_accuracy(1);
DR_acc(1) = RB_4D_accuracy(1);
DR_SV(5) = RB_model.totalSV;
DR_SV(4) = RB_32D_model.totalSV;
DR_SV(3) = RB_16D_model.totalSV;
DR_SV(2) = RB_8D_model.totalSV;
DR_SV(1) = RB_4D_model.totalSV;
figure;
title('Accuracy for RB function in different dimensions');
Dim = [4 8 16 32 64];
hold on;
plot(Dim,DR_acc,'bo-');
xlabel('Dimension');
ylabel('Accuracy (%)');
hold off ;
figure;
title('SV for RB function in different dimensions');
Dim = [4 8 16 32 64];
hold on;
plot(Dim,DR_SV,'ro-');
xlabel('Dimensionality');
ylabel('SV');
hold off ;

%%%%%%%%%% GUI for digits using RB function classifier %%%%%%%%%%%%%%
% 2D using PCA 
% PCA
[mapped_PCA_2D, mapping_PCA_2D] = compute_mapping(data, 'PCA',2);
trainData_2D = mapped_PCA_2D(trainIndex==1,:);
testData_2D = mapped_PCA_2D(testIndex==1,:);
figure;
hold on;
title('Predicted Digits for validation data using the classifier based on RB function')
for i=1:length(testLabel)
x = testData_2D(i,1);
y = testData_2D(i,2);
switch  RB_predict_label(i)
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

figure;
hold on;
title('Real Digits for validation data')
for i=1:length(testLabel)
x = testData_2D(i,1);
y = testData_2D(i,2);
switch  testLabel(i)
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

% %%% Sigmoid function 
% %cross validation 
% stepSize = 1;
% log2c_list = 6:stepSize:8;
% log2g_list = (-15):stepSize:(-14);
% log2r_list = (-10):stepSize:(-9);
% numLog2c = length(log2c_list);
% numLog2g = length(log2g_list);
% numLog2r = length(log2r_list);
% Sig_bestcv = 0;
% Sig_bestLog2c = 0;
% Sig_bestLog2g = 0;
% Sig_bestLog2r = 0;
% 
% for i = 1:numLog2c
%     log2c = log2c_list(i);
%     for j = 1:numLog2g
%         log2g = log2g_list(j);
%         for k = 1:numLog2r
%             log2r = log2r_list(k);
%         %-v 5 --> 5-fold cross validation
%         param = ['-q -v 5 -s 0 -t 3 -b 1 -c ',num2str(2^log2c),' -g ',num2str(2^log2g),' -r ',num2str(2^log2r)];
%         cv = svmtrain(trainLabel, trainData, param);
%         
%         if (cv >= Sig_bestcv),
%             Sig_bestcv = cv; Sig_bestLog2c = log2c; Sig_bestLog2g = log2g;
%             Sig_bestLog2r = log2r;
%         end
%         %fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%         end
%     end
% end
% 
% Sig_bestc = 2^Sig_bestLog2c;
% Sig_bestg = 2^Sig_bestLog2g;
% Sig_bestr = 2^Sig_bestLog2r;
% Sig_param = ['-s 0 -t 3 -b 1 -c ',num2str(Sig_bestc), ' -g ',num2str(Sig_bestg),' -r ',num2str(Sig_bestr)];
% %Train the SVM
% Sig_model = svmtrain(trainLabel, trainData,Sig_param);
% % Use the SVM model to classify the data
% [Sig_predict_label, Sig_accuracy, Sig_prob_values] = svmpredict(testLabel, testData, Sig_model, '-b 1'); % run the SVM model on the test data


