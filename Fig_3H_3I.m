%% FIGURE 3H, 3I.

% Need to change Vmax variable for figure 3I (line 9)
% Need to change J variable for 3H (line 15)

Inputs = Inputs_Final;

V0 = -90; % Original is -90 
Vmax = 0; % CHANGE THIS VARIABLE 0, -15, -30, -45 for Figure 3I
Vtest =-45; % Original is -45;
Mex = 0.0;
GNa = 10;
E_rev = 71.5;

J = 5; % Input the variable time step of depolarized duration here (5, 25, 50, 75, OR 5, 15, 25, 35) FIGURE 3H

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
    NASIM(i,11) = sum(Ytest);
     
end


NASIM = NASIM;


LW = 5; %Linewidth
FS = 20; %Font Size
MS = 20; %Marker Size

xmin = 0;
xmax = 135;

figure(1);
subplot(2,1,2, 'YTick', [-160 - 120 -80 -40 0 40],'XTick',[0 25 50 75 100],'LineWidth',LW, 'FontSize', FS);
hold on;
xlim([xmin xmax]);
title ('Voltage Protocol');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
plot(NASIM(:,1), NASIM(:,2), '-k', 'Linewidth', LW);
hold off;

subplot(2,1,1, 'YTick', [-500 -250 0],'XTick',[0 25 50 75 100],'LineWidth',LW, 'FontSize', FS);
hold on;
xlim([xmin xmax]);
ylim([-150 0]);
title ('Na Current');
xlabel('Time (ms)');
ylabel('Current (pA/pF)');
plot(NASIM(:,1), NASIM(:,3), '-k', 'Linewidth', LW);
hold off;


