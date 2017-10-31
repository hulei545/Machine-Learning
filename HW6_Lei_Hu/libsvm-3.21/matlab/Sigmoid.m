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

%%% Sigmoid function 
%cross validation 
stepSize = 1;
log2c_list = 6:stepSize:8;
log2g_list = (-15):stepSize:(-14);
log2r_list = (-10):stepSize:(-9);
numLog2c = length(log2c_list);
numLog2g = length(log2g_list);
numLog2r = length(log2r_list);
Sig_bestcv = 0;
Sig_bestLog2c = 0;
Sig_bestLog2g = 0;
Sig_bestLog2r = 0;

for i = 1:numLog2c
    log2c = log2c_list(i);
    for j = 1:numLog2g
        log2g = log2g_list(j);
        for k = 1:numLog2r
            log2r = log2r_list(k);
        %-v 5 --> 5-fold cross validation
        param = ['-q -v 5 -s 0 -t 3 -b 1 -c ',num2str(2^log2c),' -g ',num2str(2^log2g),' -r ',num2str(2^log2r)];
        cv = svmtrain(trainLabel, trainData, param);
        
        if (cv >= Sig_bestcv),
            Sig_bestcv = cv; Sig_bestLog2c = log2c; Sig_bestLog2g = log2g;
            Sig_bestLog2r = log2r;
        end
        %fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
        end
    end
end

Sig_bestc = 2^Sig_bestLog2c;
Sig_bestg = 2^Sig_bestLog2g;
Sig_bestr = 2^Sig_bestLog2r;
Sig_param = ['-s 0 -t 3 -b 1 -c ',num2str(Sig_bestc), ' -g ',num2str(Sig_bestg),' -r ',num2str(Sig_bestr)];
%Train the SVM
Sig_model = svmtrain(trainLabel, trainData,Sig_param);
% Use the SVM model to classify the data
[Sig_predict_label, Sig_accuracy, Sig_prob_values] = svmpredict(testLabel, testData, Sig_model, '-b 1'); % run the SVM model on the test data

% confusion matrix for validation data
sig_conf_matrix = zeros(10,10);
for k = 0:9
    sig_scan = Sig_predict_label(find(testLabel==k));
    num_sig_scan = length(sig_scan);
 for i = 1:num_sig_scan
    switch  sig_scan(i)
    case 0    
       sig_conf_matrix(k+1,1) = sig_conf_matrix(k+1,1) + 1;
    case 1
       sig_conf_matrix(k+1,2) = sig_conf_matrix(k+1,2) + 1;
    case 2
       sig_conf_matrix(k+1,3) = sig_conf_matrix(k+1,3) + 1;
    case 3
       sig_conf_matrix(k+1,4) = sig_conf_matrix(k+1,4) + 1;
    case 4
       sig_conf_matrix(k+1,5) = sig_conf_matrix(k+1,5) + 1;
    case 5
       sig_conf_matrix(k+1,6) = sig_conf_matrix(k+1,6) + 1;
    case 6
       sig_conf_matrix(k+1,7) = sig_conf_matrix(k+1,7) + 1;
    case 7
       sig_conf_matrix(k+1,8) = sig_conf_matrix(k+1,8) + 1;
    case 8
       sig_conf_matrix(k+1,9) = sig_conf_matrix(k+1,9) + 1;
    case 9
       sig_conf_matrix(k+1,10) = sig_conf_matrix(k+1,10) + 1;
     end;
 end

end

% plot out accuracy and number of SVs
c_testsize = 100;
g_testsize = 0.00002;
r_testsize = 0.001;
sig_c_list = (Sig_bestc - c_testsize): c_testsize/2: (Sig_bestc + c_testsize);
sig_g_list = (Sig_bestg - g_testsize): g_testsize/2: (Sig_bestg + g_testsize);
sig_r_list = (Sig_bestr - r_testsize): r_testsize/2: (Sig_bestr + r_testsize);

numsig_c = length(sig_c_list);
numsig_g = length(sig_g_list);
numsig_r = length(sig_r_list);
sig_acc = zeros(numsig_c,numsig_g,numsig_r);
sig_SV = zeros(numsig_c,numsig_g,numsig_r); 

for i = 1:numsig_c
    sig_t_c = sig_c_list(i);
    for j = 1:numsig_g
        sig_t_g = sig_g_list(j);
         for k = 1:numsig_r
            sig_t_r = sig_r_list(k);
    % scan around the best parameters    
            sig_t_param = ['-s 0 -t 3 -b 1 -c ',num2str(sig_t_c),' -g ',num2str(sig_t_g),' -r ',num2str(sig_t_r)];
            sig_t_model = svmtrain(trainLabel, trainData,sig_t_param);
            sig_SV(i,j,k)  = sig_t_model.totalSV;
            [sig_t_predict_label, sig_t_accuracy, sig_t_prob_values] = svmpredict(testLabel, testData, sig_t_model, '-b 1'); % run the SVM model on the test data
            sig_acc(i,j,k) = sig_t_accuracy(1);
         end
    end
end

figure;
title(['Accuracy for Sigmoid function when r = ',num2str(sig_r_list(1))]);
hold on;
plot(sig_c_list,sig_acc(:,1,1),'bo-');
plot(sig_c_list,sig_acc(:,2,1),'ro-');
plot(sig_c_list,sig_acc(:,3,1),'co-');
plot(sig_c_list,sig_acc(:,4,1),'yo-');
plot(sig_c_list,sig_acc(:,5,1),'ko-');
xlabel('c');
ylabel('Accuracy (%)');
legend(['\gamma = ' num2str(sig_g_list(1))],['\gamma = ' num2str(sig_g_list(2))],['\gamma = ' num2str(sig_g_list(3))],['\gamma = ' num2str(sig_g_list(4))],['\gamma = ' num2str(sig_g_list(5))]);
hold off ;

figure;
title(['Accuracy for Sigmoid function when r = ',num2str(sig_r_list(3))]);
hold on;
plot(sig_c_list,sig_acc(:,1,1),'bo-');
plot(sig_c_list,sig_acc(:,2,1),'ro-');
plot(sig_c_list,sig_acc(:,3,1),'co-');
plot(sig_c_list,sig_acc(:,4,1),'yo-');
plot(sig_c_list,sig_acc(:,5,1),'ko-');
xlabel('c');
ylabel('Accuracy (%)');
legend(['\gamma = ' num2str(sig_g_list(1))],['\gamma = ' num2str(sig_g_list(2))],['\gamma = ' num2str(sig_g_list(3))],['\gamma = ' num2str(sig_g_list(4))],['\gamma = ' num2str(sig_g_list(5))]);
hold off ;

figure;
title(['Number of SVs for Sigmoid function when r= ',num2str(sig_r_list(1))]);
hold on;
xlabel('c');
ylabel('SV');
plot(sig_c_list,sig_SV(:,1,3),'bo-');
plot(sig_c_list,sig_SV(:,2,3),'ro-');
plot(sig_c_list,sig_SV(:,3,3),'co-');
plot(sig_c_list,sig_SV(:,4,3),'yo-');
plot(sig_c_list,sig_SV(:,5,3),'ko-');
legend(['\gamma = ' num2str(sig_g_list(1))],['\gamma = ' num2str(sig_g_list(2))],['\gamma = ' num2str(sig_g_list(3))],['\gamma = ' num2str(sig_g_list(4))],['\gamma = ' num2str(sig_g_list(5))]);
hold off ;

figure;
title(['Number of SVs for Sigmoid function when r= ',num2str(sig_r_list(3))]);
hold on;
xlabel('c');
ylabel('SV');
plot(sig_c_list,sig_SV(:,1,3),'bo-');
plot(sig_c_list,sig_SV(:,2,3),'ro-');
plot(sig_c_list,sig_SV(:,3,3),'co-');
plot(sig_c_list,sig_SV(:,4,3),'yo-');
plot(sig_c_list,sig_SV(:,5,3),'ko-');
legend(['\gamma = ' num2str(sig_g_list(1))],['\gamma = ' num2str(sig_g_list(2))],['\gamma = ' num2str(sig_g_list(3))],['\gamma = ' num2str(sig_g_list(4))],['\gamma = ' num2str(sig_g_list(5))]);
hold off ;


%%%%% Dimensionality Reduction 
% 32D using PCA 
% PCA
[mapped_PCA_32D, mapping_PCA_32D] = compute_mapping(data, 'PCA',32);
trainData_32D = mapped_PCA_32D(trainIndex==1,:);
testData_32D = mapped_PCA_32D(testIndex==1,:);
% % Train the SVM
sig_32D_model = svmtrain(trainLabel, trainData_32D,Sig_param);
% % % Use the SVM model to classify the data
[sig_32D_predict_label, sig_32D_accuracy, sig_32D_prob_values] = svmpredict(testLabel, testData_32D, sig_32D_model, '-b 1'); % run the SVM model on the test data
% 16D using PCA 
% PCA
[mapped_PCA_16D, mapping_PCA_16D] = compute_mapping(data, 'PCA',16);
trainData_16D = mapped_PCA_16D(trainIndex==1,:);
testData_16D = mapped_PCA_16D(testIndex==1,:);
% % Train the SVM
sig_16D_model = svmtrain(trainLabel, trainData_16D,Sig_param);
% % % Use the SVM model to classify the data
[sig_16D_predict_label, sig_16D_accuracy, sig_16D_prob_values] = svmpredict(testLabel, testData_16D, sig_16D_model, '-b 1'); % run the SVM model on the test data
% 8D using PCA 
% PCA
[mapped_PCA_8D, mapping_PCA_8D] = compute_mapping(data, 'PCA',8);
trainData_8D = mapped_PCA_8D(trainIndex==1,:);
testData_8D = mapped_PCA_8D(testIndex==1,:);
% % Train the SVM
sig_8D_model = svmtrain(trainLabel, trainData_8D,Sig_param);
% % % Use the SVM model to classify the data
[sig_8D_predict_label, sig_8D_accuracy, sig_8D_prob_values] = svmpredict(testLabel, testData_8D, sig_8D_model, '-b 1'); % run the SVM model on the test data
% 4D using PCA 
% PCA
[mapped_PCA_4D, mapping_PCA_4D] = compute_mapping(data, 'PCA',4);
trainData_4D = mapped_PCA_4D(trainIndex==1,:);
testData_4D = mapped_PCA_4D(testIndex==1,:);
% % Train the SVM
sig_4D_model = svmtrain(trainLabel, trainData_4D,Sig_param);
% % % Use the SVM model to classify the data
[sig_4D_predict_label, sig_4D_accuracy, sig_4D_prob_values] = svmpredict(testLabel, testData_4D, sig_4D_model, '-b 1'); % run the SVM model on the test data
sig_DR_acc = zeros(5,1);
sig_DR_SV = zeros(5,1);
sig_DR_acc(5) = Sig_accuracy(1); 
sig_DR_acc(4) = sig_32D_accuracy(1);
sig_DR_acc(3) = sig_16D_accuracy(1);
sig_DR_acc(2) = sig_8D_accuracy(1);
sig_DR_acc(1) = sig_4D_accuracy(1);
sig_DR_SV(5) = Sig_model.totalSV;
sig_DR_SV(4) = sig_32D_model.totalSV;
sig_DR_SV(3) = sig_16D_model.totalSV;
sig_DR_SV(2) = sig_8D_model.totalSV;
sig_DR_SV(1) = sig_4D_model.totalSV;
figure;
title('Accuracy for Sigmoid function in different dimensions');
Dim = [4 8 16 32 64];
hold on;
plot(Dim,sig_DR_acc,'bo-');
xlabel('Dimension');
ylabel('Accuracy (%)');
hold off ;
figure;
title('SV for Sigmoid function in different dimensions');
Dim = [4 8 16 32 64];
hold on;
plot(Dim,sig_DR_SV,'ro-');
xlabel('Dimensionality');
ylabel('SV');
hold off ;



















