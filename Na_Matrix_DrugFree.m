%% Script for optimizing the resugent INa current using Matrix Exponential solver.

function [Total_Error, SSA, ACT, TAU, RFI, RES, PREPULSE2, COND] = Na_Matrix_DrugFree(Inputs)

SSA_F = parfeval(@SSA_Func,1,Inputs);
ACT_F = parfeval(@ACT_Func,1,Inputs);
TAU_F = parfeval(@Tau_Func,1,Inputs);
RFI_F = parfeval(@RFI_Func,1,Inputs);
RES_F = parfeval(@Res_Func,1,Inputs);
PP2_F = parfeval(@PP_Func2,1,Inputs);
COND_F = parfeval(@COND_Func,1,Inputs);

SSA = fetchOutputs(SSA_F);
ACT = fetchOutputs(ACT_F);
TAU = fetchOutputs(TAU_F);
RFI = fetchOutputs(RFI_F);
RES = fetchOutputs(RES_F);
PREPULSE2 = fetchOutputs(PP2_F);
COND = fetchOutputs(COND_F);

%% RFI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = [0.01; 0.1; 0.3; 0.5; 1; 2; 3; 4; 5; 7; 10; 12; 15; 20; 25]; %Joey
%A1_EXP = 0.65; T1_EXP = 2.68; A2_EXP = 0.31; T2_EXP = 12.47; C1_EXP = 0.983; %WT OLD
A1_EXP = 1.0; T1_EXP = 3.8; C1_EXP = 1.0; %Joey

Y_100 = C1_EXP - A1_EXP*exp(-t1/T1_EXP);
Err_RFI = sum((RFI(:,3)*100 - Y_100*100).^2)  / 15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Activation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V = (0:-5:-80)';

Vhalf_EXP = -47.6; K_EXP = -4.96; %Joey

Y_EXP = 1./(1 + exp((V - Vhalf_EXP)/K_EXP));

Err_Act = sum((ACT(:,3)*100 - Y_EXP*100).^2)  / 17;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SSA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V = (-120:3:-10)';
Vhalf_EXP = -58.5; K_EXP = 6.534; % Joey
 
Y_EXP = 1./(1+exp((V - Vhalf_EXP)/K_EXP));
 
Err_SSA = sum((SSA(:,3)*100 - Y_EXP*100).^2) / 37;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PeakTau %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V = (0:-5:-50);
Peak_Tau_Exp_y = [0.21; 0.249; 0.259; 0.309; 0.306; 0.362; 0.381; 0.531; 0.551; 0.585; 0.642]; %Joey from 0: -5: -->-50;

Err_PeakTau = sum((TAU(:,2)*100 - Peak_Tau_Exp_y*100).^2)   /  11;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Resurgent Tau %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Trial of line of best fit from -45 to -5 (so to not overfit)
V = (-5:-5:-45);
ResT_line = 0.18678*V + 22.92;
Err_ResurgentTau = sum((RES(1:9,8)*10 - ResT_line(:)*10).^2)   /  9; %1-9 is -45 and above.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Late Current %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Err_Late = (0.1 - LATE(1,1)).^2; %Trying to get 0.1% Late:Peak Current for normal WT
Err_Late = sum((2.0 - RES(9,9)).^2 )  / 1; %Trying to get 2% late current at end of 250ms, at -45mV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Resurgent Peak %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V = (-80:5:-5);
% Resurgent_Peak = [0.158; 0.178; 0.185; 0.214; 0.24; 0.258; 0.267; 0.266; 0.247; 0.216; 0.183; 0.143; 0.112; 0.091; 0.083; 0.066]; %Normalized to transient at 0mv 

%V = (-5:-5:80)
Resurgent_Peak = 100*[0.066; 0.083; 0.091; 0.112; 0.143; 0.183; 0.216; 0.247; 0.266; 0.267; 0.258; 0.24; 0.214; 0.185; 0.178; 0.158];

% SCN4B_KO
%Resurgent_Peak = [3.54; 3.87; 5.13; 5.79; 8.20; 11.51; 14.66; 16.59; 17.42; 15.77; 15.03; 12.97; 11.70; 10.01; 9.83; 8.23];

Err_ResurgentPeak = sum((RES(:,6) - Resurgent_Peak).^2)   /  16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Prepulse duration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PP2_exp_pos20 = [0.994;0.924;0.861;0.846;0.804;0.768;0.755;0.727;0.698;0.667;0.645;0.617;0.619;0.604;0.591;0.578;0.523;0.541];
Err_PP2_Duration = sum((PREPULSE2(:,4)*100 - PP2_exp_pos20*100).^2)  / 18;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Res:Peak conductance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean currents late: peak
MEAN_COND = 100*mean(COND(:,9));
Err_COND = sum( (100*COND(:,9) - MEAN_COND ).^2   );

%Mean conductances late: peak
MEAN_COND = 100*mean(COND(:,8));
Err_COND = sum( (100*COND(:,8) - MEAN_COND ).^2   );

%Mean resurgent peak
MEAN_COND = mean(COND(:,5));
Err_COND = sum( (COND(:,5) - MEAN_COND ).^2   );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Objective function to be minimized: sum of the above individual protocol errors
Total_Error = Err_SSA+ Err_Act + Err_RFI + Err_PeakTau + Err_PP2_Duration + Err_ResurgentPeak + Err_COND + Err_Late + Err_ResurgentTau;
end
