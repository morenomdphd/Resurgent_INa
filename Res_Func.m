%Initial Tau and Resurgent Peak and Tau function.
function RES = Res_Func(Inputs)

V0 = -90; 
Vmax =-5; 
Vstep = -5; 
V = (Vmax:Vstep:-80);
Drug = 0.0;
E_rev = 71.5;


% Set up vectors
INa_res_peak=zeros(1,length(V));
t_res_Peak=zeros(1,length(V));

Tau = zeros(1,length(V));
Tau_Res = zeros(1,length(V));

INa_250 = zeros(1,length(V));

% Calculate SS at V0
SS = findss(Q_Matrix(V0,Inputs, Drug));

% Calculate INa at V0
O = SS(4);
INa_SS = 10*O*(V0- E_rev);



Q=@Q_Matrix;                   
Q0 = Q(0, Inputs, Drug);
     
    % Find peak I_Na at 0mV 
     [t,fval]=fminbnd(@(x) expmax(x,Q0,SS,0),0,5);
     INa_0=fval;
     tPeak_0=t;
     
    % Calculate Tau to 33%    
     opts=optimset('TolX',1e-3);
     [t1]=fminbnd(@(x) exptau(x,Q0,SS,fval,0),t,20,opts);
     Tau = t1 - t; 
     
    % Step to 0mV for 5ms
     Y0 = expm(Q0 * 5.0)*SS;


for j = 1:length(V)
    V_test = V(j);
    Q=@Q_Matrix;                   
    Qtest = Q(V_test, Inputs, Drug);
    
    % Step back down after 5ms to V_test for 110ms
    Ytest = expm(Qtest * 100.0)*Y0; % originally 110, 250
    
    % Calculate resurgent peak
     [t2,fval]=fminbnd(@(x) expmax(x,Qtest,Y0,V_test),0,20);
     INa_res_peak(j)=fval;
     t_res_Peak(j)=t2;
    
    % Calculate resurgent Tau
     opts=optimset('TolX',1e-3);
     [t3]=fminbnd(@(x) exptau(x,Qtest,Y0,fval,V_test),t2,70,opts); %Changed from 50
     Tau_Res(j) = t3 - t2;
    
    % Calculate Ina at 250ms, and compare to peakINa
        E_rev = 71.5;
        O = Ytest(4);
        INa_250(j) = 10*O*(V_test- E_rev);
  


        
end %End of For J 1:length(V)

RES(:,1) = V;
RES(:,2) = tPeak_0;
RES(:,3) = INa_0;
RES(:,4) = t_res_Peak;
RES(:,5) = INa_res_peak;
RES(:,6) = (INa_res_peak / INa_0)*100;
RES(:,7) = Tau;
RES(:,8) = Tau_Res;
RES(:,9) = (INa_250/INa_0)*100;
RES(:,10) = INa_250;
RES(:,11) = (INa_SS/INa_0)*100;

end %End of function TAU


%TEST FUNCTIONS
function INa=expmax(t,Q,y0,V)
A=expm(Q*t)*y0;
E_rev = 71.5;
O = A(4);
INa = 10*O*(V- E_rev);
end


function Tau=exptau(t,Q,y0,fval,V)
A=expm(Q*t)*y0;
E_rev = 71.5;
O = A(4);
INa = 10*O*(V- E_rev);
Tau=abs(INa - 0.37*fval);
end


