close all;
%clear all;
%clc;

%Importing data from the different measurements -  2021/07/07

%### No Waves

%Reference + freq_range
data_dir = fullfile('20210707', 'No_waves', 'Ref');
[~,s11_ref,freq_range] = DefineSparameterMatrix(data_dir, 1,1);
reference_meas = mean(s11_ref);

%0bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '0bottles');
[~,s11_0b,~] = DefineSparameterMatrix(data_dir, 1,1);
% reference_meas = s11_0b(40,:);%mean(s11_0b);
s11_0b = SubtractRef(s11_0b, reference_meas);

%1bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '1bottle');
[~,s11_1b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_1b = SubtractRef(s11_1b, reference_meas);
% reference_meas = mean(s11_1b);

%2bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '2bottles');
[~,s11_2b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_2b = SubtractRef(s11_2b, reference_meas);

%3bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '3bottles');
[~,s11_3b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_3b = SubtractRef(s11_3b, reference_meas);

%4bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '4bottles');
[~,s11_4b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_4b_random = SubtractRef(s11_4b,reference_meas);%mean(SubtractRef(s11_4b, reference_meas));

%5bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '5bottles');
[~,s11_5b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_5b = SubtractRef(s11_5b, reference_meas);

%9bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '9bottles');
[~,s11_9b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_9b = SubtractRef(s11_9b, reference_meas);

%20bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '20bottles');
[~,s11_20b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_20b = SubtractRef(s11_20b, reference_meas);

%27bottles calibrated
data_dir = fullfile('20210707', 'No_waves', '27bottles');
[~,s11_27b,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_27b = SubtractRef(s11_27b, reference_meas);

%Data matrix
freq_range = freq_range(1:651);
X_20210707_no_waves = [s11_0b(:,1:651); s11_1b(:,1:651); s11_2b(:,1:651); s11_3b(:,1:651); s11_4b(:,1:651); s11_5b(:,1:651)];% s11_9b(:,1:651); s11_20b(:,1:651); s11_27b(:,1:651)];
Y_20210707_no_waves = [(ones(100,1)*0); (ones(100,1)*1); (ones(100,1)*2); (ones(99,1)*3); (ones(100,1)*4); (ones(100,1)*5)];% (ones(100,1)*9); (ones(100,1)*20); (ones(100,1)*27)];
% 
% Regress_learner = [abs(X_20210707_no_waves) Y_20210707_no_waves];
% 
% X_20210707_no_waves_0_27 = abs([s11_0b(:,1:651); s11_27b(:,1:651)]);
% aux = [(ones(100,1)*0); (ones(100,1)*271)];
% Regress_learner_0_27 = [X_20210707_no_waves_0_27 aux];

%### Waves

%Reference
data_dir = fullfile('20210707', 'waves');
[~,ref_meas,~] = DefineSparameterMatrix(data_dir, 1,1);
ref_meas = mean(ref_meas);

%0bottles calibrated
data_dir = fullfile('20210707', 'waves', '0bottles');
[~,s11_0b_w,~] = DefineSparameterMatrix(data_dir, 1,1);
% ref_meas = mean(s11_0b_w);
s11_0b_w = SubtractRef(s11_0b_w, ref_meas);

%1bottles calibrated
data_dir = fullfile('20210707', 'waves', '1bottle');
[~,s11_1b_w,~] = DefineSparameterMatrix(data_dir, 1,1);
% ref_meas = mean(s11_1b_w);
s11_1b_w = SubtractRef(s11_1b_w, ref_meas);

%7bottles calibrated
data_dir = fullfile('20210707', 'waves', '7bottles');
[~,s11_7b_w,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_7b_w = SubtractRef(s11_7b_w, ref_meas);

%8bottles calibrated
data_dir = fullfile('20210707', 'waves', '8bottles');
[~,s11_8b_w,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_8b_w = SubtractRef(s11_8b_w, ref_meas);

%9bottles calibrated
data_dir = fullfile('20210707', 'waves', '9bottles');
[~,s11_9b_w,~] = DefineSparameterMatrix(data_dir, 1,1);
s11_9b_w = SubtractRef(s11_9b_w, ref_meas);

X_20210707_waves = [s11_0b_w(:,1:651); s11_1b_w(:,1:651); s11_7b_w(:,1:651); s11_8b_w(:,1:651); s11_9b_w(:,1:651)];
Y_20210707_waves = [(ones(100,1)*0); (ones(59,1)*1); (ones(100,1)*7); (ones(100,1)*8); (ones(100,1)*9)];
% 
% Regress_learner_waves = [abs(X_20210707_waves) Y_20210707_waves];
