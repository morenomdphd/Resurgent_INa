%% FIGURE 3B - 3G: DRUG FREE PLOTS

%LW = 3; %Linewidth
%FS = 20; %Font Size

LW = 5; %Linewidth 10
FS = 20; %Font Size 60
MS = 20; %Marker Size 40

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Steady State Availability
V = (-130:10:-30)';

Vhalf_EXP = -58.5; K_EXP = 6.534; % Joey
Y_SSA = 1./(1+exp((V - Vhalf_EXP)/K_EXP));

subplot (2,4,1, 'Linewidth', LW, 'FontSize', FS, 'YTick', [0 0.25 0.5 0.75 1.0],'XTick',[-120 -80 -40 0]);
hold on;
title ('SSA');
xlabel('Voltage (mV)');
ylabel('Normalized Availability');
xlim([-125 0]); ylim([0 1.05]);
plot (SSA(:,1), SSA(:,3), '-k', 'Linewidth', LW);
plot (V, Y_SSA, 'ok', 'Linewidth', LW, 'MarkerSize', MS, 'MarkerFaceColor', 'k'); 
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Activation 
V = (-60:10:20)';

Vhalf_EXP = -47.6; K_EXP = -4.96; %Joey
Y_ACT = 1./(1 + exp((V - Vhalf_EXP)/K_EXP));

subplot (2,4,2, 'LineWidth',LW, 'FontSize', FS, 'YTick', [0 0.25 0.5 0.75 1.0],'XTick',[-80 -40 0 40]);
hold on;
title('ACT');%xlabel('Voltage (mV)');
ylabel('Normalized Availability');
xlim([-80 40]); ylim([0 1.05]);
plot (ACT(:,1), ACT(:,3), '-k', 'LineWidth',LW);
plot (V, Y_ACT, 'ok', 'MarkerSize', MS, 'MarkerFaceColor', 'k'); % EXP Line of fit of Na
hold off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recovery from Inactivation
t1 = [0.01; 0.1; 0.3; 0.5; 1; 2; 3; 4; 5; 7; 10; 12; 15; 20; 25]; %Joey
A1_EXP = 1.0; T1_EXP = 3.8; C1_EXP = 1.0; %Joey
RFI_EXP = C1_EXP - A1_EXP*exp(-t1/T1_EXP); %Joey

subplot(2,4,3, 'XScale', 'log', 'LineWidth',LW, 'FontSize', FS, 'YTick', [0 0.25 0.5 0.75 1.0],'XTick',[0.1 1 10 100]);
hold on;
title('RFI');
xlabel('Time (ms)');
ylabel('Normalized Recovery');
xlim([0.1 1000]); ylim([0 1.05]);
plot (RFI(:,1), RFI(:,3), '-k', 'LineWidth',LW);
plot (t1, RFI_EXP, 'ok', 'MarkerSize', MS, 'MarkerFaceColor', 'k'); % EXP Line of fit of mutant
xlim([0 1000]);
hold off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tau to Inactivation
Tau_Exp_x = [0; -5; -10; -15; -20; -25; -30; -35; -40; -45; -50];
Tau_Exp_y = [0.21; 0.249; 0.259; 0.309; 0.306; 0.362; 0.381; 0.531; 0.551; 0.585; 0.642]; %Joey from 0: -5: -->-50;

subplot (2,4,4,'LineWidth',LW, 'FontSize', FS, 'YTick', [0 0.5 1 1.5 2],'XTick',[-60 -40 -20 0]);
hold on;
xlim([-50 5]); ylim([0 2.05]);
title('TAU Deactivation');
xlabel('Voltage (mV)');
ylabel('Peak Tau (ms)');
plot (TAU(:,1), TAU(:,2), '-k', 'LineWidth',LW);
plot (Tau_Exp_x, Tau_Exp_y, 'ok', 'MarkerSize', MS, 'MarkerFaceColor', 'k'); %Experimental points of mutant
hold off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resurgent Peak to Transient Peak
V = (-80:5:-5);
Resurgent_Peak = 100*[0.158; 0.178; 0.185; 0.214; 0.24; 0.258; 0.267; 0.266; 0.247; 0.216; 0.183; 0.143; 0.112; 0.091; 0.083; 0.066]; %Normalized to transient at 0mv 

%SCN4B KO
Resurgent_Peak_KO= [8.23; 9.83; 10.01; 11.7; 12.97; 15.03; 15.77; 17.42; 16.59; 14.66; 11.51; 8.20; 5.79; 5.13; 3.87; 3.54]; %Normalized to transient at 0mV

subplot (2,4,5,'LineWidth',LW, 'FontSize', FS, 'YTick', [0 10 20 30 40],'XTick',[-75 -50 -25 0]);
hold on;
xlim([-80 0]); ylim([0 40]);
title('Resurgent Peak to Transient Peak');
xlabel('Voltage (mV)');
ylabel('% of Transient Peak');
plot (V, Resurgent_Peak, 'ok', 'MarkerSize', MS, 'MarkerFaceColor', 'k');
plot (V, Resurgent_Peak_KO, 'or', 'MarkerSize', MS, 'MarkerFaceColor', 'r');
plot (RES(:,1), RES(:,6), '-k', 'LineWidth',LW);
hold off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resurgent Tau 
V = (-5:-5:-80);
Resurgent_Tau = [20.97; 19.74; 20.2; 22.6; 18.1; 17.6; 16.4; 15.1; 13.6; 10.4; 7.8; 5.7; 4.5; 3.6; 3.6; 2.7];

subplot (2,4,7,'LineWidth',LW, 'FontSize', FS, 'YTick', [0 10 20 30 40],'XTick',[-45 -30 -15 0]);
hold on;
xlim([-45 0]); ylim([0 40]);
title('Resurgent Deactivation');
xlabel('Voltage (mV)');
ylabel('Resurgent Tau (ms)');
plot (RES(:,1), RES(:,8), '-k', 'LineWidth',LW);
plot (V, Resurgent_Tau, 'ok', 'MarkerSize', MS, 'MarkerFaceColor', 'k');
hold off; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepulse duration 2
PP_time = [2;6;10;14;18;22;26;30;36];
PP2_exp_pos20 = [0.994;0.861;0.804;0.755;0.698;0.645;0.619;0.591;0.541];


subplot (2,4,6,'LineWidth',LW, 'FontSize', FS, 'YTick', [0 0.25 0.5 0.75 1.0],'XTick',[10 20 30 40]);
hold on;
xlim([0 40]); ylim([0 1.05]);
title('Prepulse duration at +20 (PP2)');
xlabel('Time (ms)');
ylabel('Normalized Resurgent Current');
plot (PREPULSE2(:,1), PREPULSE2(:,4), '-k', 'LineWidth',LW);
plot (PP_time, PP2_exp_pos20, 'ok', 'MarkerSize', MS, 'MarkerFaceColor', 'k');
hold off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalized Resurgent Peak
X = COND(:,1);
Y = COND(:,5);
MaxResurgent = min(Y); % Using min because the values are negative

EXP = [1;1;1;1;1;1;1;1]; % No decrement in current. 
Y2 = Y./MaxResurgent;

subplot(2,4,8, 'YTick', [0 .25 0.5 0.75 1.0],'XTick',[-40 -20 0],'LineWidth',LW, 'FontSize', FS);
hold on;
xlim([-45 0]); ylim([0 1.05]);
title ('Na Current');
xlabel('Voltage (mV)');
ylabel('Normalized Peak %');
plot(X, Y2, '-k', 'Linewidth', LW, 'MarkerSize', MS, 'MarkerFaceColor', 'k');
plot(X, EXP, 'ok', 'Linewidth', LW, 'MarkerSize', MS, 'MarkerFaceColor', 'k');
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




