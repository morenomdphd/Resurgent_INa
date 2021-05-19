%% FIGURE 8B, 8C

% Plots a multipulse protocol and compares to a single pulse protocol to
% show that the decay current is the same

Inputs = Inputs_Final;

V0 = -90;
Vmax_initial = 0;
Vmax = 0; % Should be either 0 or -45. Can change this to -45 to do the "1 puslse to 0 for 5ms, then back to -45 for duration. Then, Vmax and Vtest are the same and you get a holding pulse to -45 for the duration
Vtest =-45;
Mex = 0.0;
GNa = 10;
E_rev = 71.5;

t = (0:0.01:100);

%Calculate SS at -90mV
SS = findss(Q_Matrix(V0,Inputs, Mex));

Q=@Q_Matrix;
Q0 = Q(V0, Inputs, Mex);
QMax_initial = Q(Vmax_initial, Inputs, Mex);
QMax = Q(Vmax, Inputs, Mex);
Qtest = Q(Vtest, Inputs, Mex);
       
NASIM = zeros (length(t), 12);

for (i = 1:length(t) )
    %% FIRST PULSE
    % Holding Potential for 10ms
    if(t(i) < 10)
    V = V0;
    Ytest = SS;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    
    %Step to VMax (0mV) for 5ms
    elseif (t(i) >=10 && t(i) <15)
    tt = t(i) - 10.0;
    V = Vmax_initial;
    Ytest = expm(QMax_initial * tt ) * SS;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest10 = Ytest;
    
    %Step back down to Vtest for 2ms
    elseif (t(i)>=15 && t(i)<17)
    tt = t(i) - 15;
    V = Vtest;
    Ytest = expm(Qtest * tt ) * Ytest10;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest15 = Ytest;
    
    %% SECOND PULSE
    % Step up to 0
    elseif( t(i) >=17 && t(i) < 21)
    tt = t(i) - 17.0;
    V = Vmax;
    Ytest = expm(QMax * tt ) * Ytest15;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest17 = Ytest;
    
    %Step to -45
    elseif (t(i) >=21 && t(i) <23)
    tt = t(i) - 21.0;
    V = Vtest;
    Ytest = expm(Qtest * tt ) * Ytest17;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest21 = Ytest;
    
    %% THIRD PULSE
    % Step up to 0
    elseif( t(i) >=23 && t(i) < 27)
    tt = t(i) - 23.0;
    V = Vmax;
    Ytest = expm(QMax * tt ) * Ytest21;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest23 = Ytest;
    
    %Step to -45
    elseif (t(i) >=27 && t(i) <29)
    tt = t(i) - 27.0;
    V = Vtest;
    Ytest = expm(Qtest * tt ) * Ytest23;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest27 = Ytest;
       
    %% FOURTH PULSE
    % Step up to 0
    elseif( t(i) >=29 && t(i) < 33)
    tt = t(i) - 29.0;
    V = Vmax;
    Ytest = expm(QMax * tt ) * Ytest27;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest29 = Ytest;
    
    %Step to -45
    elseif (t(i) >=33 && t(i) <35)
    tt = t(i) - 33.0;
    V = Vtest;
    Ytest = expm(Qtest * tt ) * Ytest29;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest33 = Ytest;
    
    %% FIFTH PULSE
    % Step up to 0
    elseif( t(i) >=35 && t(i) < 39)
    tt = t(i) - 35.0;
    V = Vmax;
    Ytest = expm(QMax * tt ) * Ytest33;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest35 = Ytest;
    
    %Step to -45
    elseif (t(i) >=39 && t(i) <75)
    tt = t(i) - 39.0;
    V = Vtest;
    Ytest = expm(Qtest * tt ) * Ytest35;
    Open = Ytest(4);
    INa = GNa*Open*(V -E_rev);
    Ytest39 = Ytest;
    
    %Step back to 0
    elseif (t(i) >=75 && t(i) <100)
    tt = t(i) - 75.0;
    V = V0;
    Ytest = expm(Q0 * tt ) * Ytest39;
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
    NASIM(i,11) = sum(Ytest);
    
end


NASIM = NASIM;

LW = 5; %Linewidth
FS = 20; %Font Size
MS = 20; %Marker Size

figure(1);
subplot(3,1,1, 'YTick', [-160 - 120 -80 -40 0 40],'XTick',[0 25 50 75 100 200 300],'LineWidth',LW, 'FontSize', FS);
hold on;
title ('Voltage Protocol');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
plot(NASIM(:,1), NASIM(:,2), '-k', 'Linewidth', LW);
hold off;

subplot(3,1,2, 'YTick', [-500 -250 0],'XTick',[0 25 50 75 100 200 300],'LineWidth',LW, 'FontSize', FS);
hold on;
title ('Na Current');
xlabel('Time (ms)');
ylabel('Current (pA/pF)');
plot(NASIM(:,1), NASIM(:,3), '-k', 'Linewidth', LW);
hold off;

subplot(3,1,3, 'YTick', [0 0.25 0.5 0.75 1],'XTick',[0 25 50 75 100 200 300], 'LineWidth',LW, 'FontSize', FS);
hold on;
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
