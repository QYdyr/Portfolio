function walksbinary_2
%% Problem 2: 
% Use FFT to create features from your examples of Silly Walks, 
% plus examples of normal walking, and classify them using hand-labeled supervised learning

clearvars
%% import accelerometer data
yd_silly = readtable('YD_sillywalk_2021-10-06.csv');  
yd_normal = readtable('YD_normalwalk_2021-10-06.csv');  
uk_silly = readtable('UK_sillywalk_2021-10-06.csv');  
uk_normal = readtable('UK_normalwalk_2021-10-06.csv');  

%% Create training and testing dataset for SVM

% YD silly walk samples (150 data points)
yds = (yd_silly.gFz)';
n_yds = 427*2;
l_yds = length(yds) - n_yds;
yds_samples = [];
for i = 1:150
    % Take random short segments of the original signals (2 sec in length)
    start_yds = randi(l_yds);
    end_yds = start_yds + n_yds;
    seg_yds = yds(:,start_yds:end_yds);
    % FFT of segment
    Y_yds = fft(seg_yds);
    L_yds = length(seg_yds);
    P2_yds = abs(Y_yds/L_yds);
    P1_yds = P2_yds(1:L_yds/2+1);
    P1_yds(2:end-1) = 2*P1_yds(2:end-1);
    f_yds = 427*(0:(L_yds/2))/L_yds;
    % use first 10 components as features
    yds_comp = cat(1,f_yds,P1_yds); % first row frequency, 2nd row amplitude
    [temp_yds, order_yds] = sort(yds_comp(2,:),'descend');
    yds_max = yds_comp(:,order_yds);
    yds_10 = yds_max(:,1:10);
    yds_feature = cat(2,yds_10(1,:),yds_10(2,:)); % 1-10 col freq, 11-20 col amp
    yds_samples = [yds_samples ; yds_feature];
end

% YD normal walk samples
ydn = (yd_normal.gFz)';
n_ydn = 427*2;
l_ydn = length(ydn) - n_ydn;
ydn_samples = [];
for i = 1:150
    % Take random short segments of the original signals (2 sec in length)
    start_ydn = randi(l_ydn);
    end_ydn = start_ydn + n_ydn;
    seg_ydn = ydn(:,start_ydn:end_ydn);
    % FFT of segment
    Y_ydn = fft(seg_ydn);
    L_ydn = length(seg_ydn);
    P2_ydn = abs(Y_ydn/L_ydn);
    P1_ydn = P2_ydn(1:L_ydn/2+1);
    P1_ydn(2:end-1) = 2*P1_ydn(2:end-1);
    f_ydn = 427*(0:(L_ydn/2))/L_ydn;
    % use first 10 components as features
    ydn_comp = cat(1,f_ydn,P1_ydn); % first row frequency, 2nd row amplitude
    [temp_ydn, order_ydn] = sort(ydn_comp(2,:),'descend');
    ydn_max = ydn_comp(:,order_ydn);
    ydn_10 = ydn_max(:,1:10);
    ydn_feature = cat(2,ydn_10(1,:),ydn_10(2,:)); % 1-10 col freq, 11-20 col amp
    ydn_samples = [ydn_samples ; ydn_feature];
end

% UK silly walk samples
uks = (uk_silly.gFz)';
n_uks = 400*2;
l_uks = length(uks) - n_uks;
uks_samples = [];
for i = 1:150
    % Take random short segments of the original signals (2 sec in length)
    start_uks = randi(l_uks);
    end_uks = start_uks + n_uks;
    seg_uks = uks(:,start_uks:end_uks);
    % FFT of segment
    Y_uks = fft(seg_uks);
    L_uks = length(seg_uks);
    P2_uks = abs(Y_uks/L_uks);
    P1_uks = P2_uks(1:L_uks/2+1);
    P1_uks(2:end-1) = 2*P1_uks(2:end-1);
    f_uks = 427*(0:(L_uks/2))/L_uks;
    % use first 10 components as features
    uks_comp = cat(1,f_uks,P1_uks); % first row frequency, 2nd row amplitude
    [temp_uks, order_uks] = sort(uks_comp(2,:),'descend');
    uks_max = uks_comp(:,order_uks);
    uks_10 = uks_max(:,1:10);
    uks_feature = cat(2,uks_10(1,:),uks_10(2,:)); % 1-10 col freq, 11-20 col amp
    uks_samples = [uks_samples ; uks_feature];
end

% UK normal walk samples
ukn = (uk_normal.gFz)';
n_ukn = 400*2;
l_ukn = length(ukn) - n_ukn;
ukn_samples = [];
for i = 1:150
    % Take random short segments of the original signals (2 sec in length)
    start_ukn = randi(l_ukn);
    end_ukn = start_ukn + n_ukn;
    seg_ukn = ukn(:,start_ukn:end_ukn);
    % FFT of segment
    Y_ukn = fft(seg_ukn);
    L_ukn = length(seg_ukn);
    P2_ukn = abs(Y_ukn/L_ukn);
    P1_ukn = P2_ukn(1:L_ukn/2+1);
    P1_ukn(2:end-1) = 2*P1_ukn(2:end-1);
    f_ukn = 427*(0:(L_ukn/2))/L_ukn;
    % use first 10 components as features
    ukn_comp = cat(1,f_ukn,P1_ukn); % first row frequency, 2nd row amplitude
    [temp_ukn, order_ukn] = sort(ukn_comp(2,:),'descend');
    ukn_max = ukn_comp(:,order_ukn);
    ukn_10 = ukn_max(:,1:10);
    ukn_feature = cat(2,ukn_10(1,:),ukn_10(2,:)); % 1-10 col freq, 11-20 col amp
    ukn_samples = [ukn_samples ; ukn_feature];
end


%% training and testing data
yds_samples_p = yds_samples(1:100,:);
yds_samples_f = yds_samples(101:150,:);
ydn_samples_p = ydn_samples(1:100,:);
ydn_samples_f = ydn_samples(101:150,:);
uks_samples_p = uks_samples(1:100,:);
uks_samples_f = uks_samples(101:150,:);
ukn_samples_p = ukn_samples(1:100,:);
ukn_samples_f = ukn_samples(101:150,:);

X = cat(1,uks_samples_p, ukn_samples_p, yds_samples_p, ydn_samples_p, uks_samples_f, ukn_samples_f, yds_samples_f, ydn_samples_f);

% import labels for positive and negative samples
labels = readtable('walk_label.csv');  
Y = labels.label;


%% Train Classification Model
prsntX = X(1:400,:);
prsntY = Y(1:400);
ftrX = X(401:end,:);
ftrY = Y(401:end);

svmMd_walk = fitcsvm(prsntX,prsntY,'Standardize',true);
names = svmMd_walk.ClassNames

%% Create Simulink Model

SimMdlName = 'walkSVM'; 
open_system(SimMdlName)

WalkInput.time = (0:199)';
WalkInput.signals(1).values = ftrX;
WalkInput.signals(1).dimensions = size(ftrX,2);

sim(SimMdlName);

end

