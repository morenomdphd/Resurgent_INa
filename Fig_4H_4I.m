%% FIGURE 4H, 4I

% Plotting state dependencies for different voltage protocols

% Use same code to plot Figure 9, however, switch Inputs_Final to Inputs_Final_KO (found in the Main_File.m).

% Use same code to plot Supplementary Figure 1. Need to change line 13.

Inputs = Inputs_Final;

V0 = -90; 
Vmax = 0;
Vtest =-45; % Original is -45; FOR SUPPLEMNTART FIGURE 1, CHANGE to 0
Mex = 0.0;
GNa = 10;
E_rev = 71.5;

J = 5; 

t = (0:0.01:135);

%Calculate SS at -120mV
SS = findss(Q_Matrix(V0,Inputs, Mex));

Q=@Q_Matrix;
Q0 = Q(V0, Inputs, Mex);
QMax = Q(Vmax, Inputs, Mex);
Qtest = Q(Vtest, Inputs, Mex);
    
NASIM = zeros (length(t), 10);

for (i = 1:length(t) )
    % Holding Potential for 10ms
    if(t(i) < 10)
    V = V0;
    Ytest = SS;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    
    %Step to VMax (~0mV, 20mV) for 5ms
    elseif (t(i) >=10 && t(i) <(10 + J))             
    tt = t(i) - 10.0;
    V = Vmax;
    Ytest = expm(QMax * tt ) * SS;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest15 = Ytest;
    
    %Step back down to Vtest for 100ms.
    elseif (t(i)>=(10+J) && t(i) <115)                   
    tt = t(i) - (10+J);                                     
    V = Vtest;
    Ytest = expm(Qtest * tt ) * Ytest15;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest115 = Ytest;
    
    %Step back down to V0 for 35ms.
    elseif (t(i)>=115)
    tt = t(i) - 115;
    V = V0;
    Ytest = expm(Q0 * tt ) * Ytest115;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    
    end
    
    NASIM(i,1) = t(i);
    NASIM(i,2) = V;
    NASIM(i,3) = INa;
    NASIM(i,4) = Ytest(1) + Ytest(2) + Ytest(3); %C3, C2, C1
    NASIM(i,5) = Ytest(4); %O
    NASIM(i,6) = Ytest(5); %IS1
    NASIM(i,7) = Ytest(6) + Ytest(7); %IC3, IC2
    NASIM(i,8) = Ytest(8); %IF1
    NASIM(i,9) = Ytest(9); %IF2
   
end


NASIM = NASIM;


LW = 5; %Linewidth
FS = 20; %Font Size
MS = 20; %Marker Size

xmin = 0;
xmax = 135;

figure(1);
subplot(3,1,2, 'YTick', [-160 - 120 -80 -40 0 40],'XTick',[0 25 50 75 100],'LineWidth',LW, 'FontSize', FS);
hold on;
xlim([xmin xmax]);
title ('Voltage Protocol');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
plot(NASIM(:,1), NASIM(:,2), '-k', 'Linewidth', LW);
hold off;

subplot(3,1,1, 'YTick', [-100 -50 0],'XTick',[0 25 50 75 100],'LineWidth',LW, 'FontSize', FS);
hold on;
xlim([xmin xmax]);
ylim([-100 0]);
title ('Na Current');
xlabel('Time (ms)');
ylabel('Current (pA/pF)');
plot(NASIM(:,1), NASIM(:,3), '-k', 'Linewidth', LW);
hold off;

subplot(3,1,3, 'YTick', [0 0.25 0.5 0.75 1],'LineWidth',LW, 'FontSize', FS);
hold on;
xlim([xmin xmax]);
title ('States');
xlabel('Time (ms)');
ylabel('State occupancy');
plot(NASIM(:,1), NASIM(:,4), '-k', 'Linewidth', LW, 'DisplayName', 'Closed');
plot(NASIM(:,1), NASIM(:,5), '-b', 'Linewidth', LW, 'DisplayName', 'Open');
plot(NASIM(:,1), NASIM(:,7), '-g', 'Linewidth', LW, 'DisplayName', 'IC');
plot(NASIM(:,1), NASIM(:,8), '-m', 'Linewidth', LW, 'DisplayName', 'IF1');
plot(NASIM(:,1), NASIM(:,9), '-c', 'Linewidth', LW, 'DisplayName', 'IF2');
plot(NASIM(:,1), NASIM(:,6), '-r', 'Linewidth', LW, 'DisplayName', 'IS1');
hold off;


