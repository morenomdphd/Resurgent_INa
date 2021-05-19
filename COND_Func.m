% Normalized Conductances

function COND = COND_Func(Inputs)

V0 = -90; 
Vmax =0; 
Vstep = -5; 
V = (Vmax:Vstep:-35);
V_45 = -45;
Drug = 0.0;
E_rev = 71.5;


% Set up vectors
INa_peak=zeros(1,length(V));
t_peak=zeros(1,length(V));
INa_res=zeros(1,length(V));
t_res=zeros(1,length(V));

% Calculate SS at V0
SS = findss(Q_Matrix(V0,Inputs, Drug));


for j = 1:length(V)
    V_test = V(j);
    Q=@Q_Matrix;                   
    Qtest = Q(V_test, Inputs, Drug);
    Q45 = Q(V_45, Inputs, Drug);
     
    % Find peak I_Na at V_test 
     [t,fval]=fminbnd(@(x) expmax(x,Qtest,SS,V_test),0,5);
     INa_peak(j)=fval;
     t_peak(j)=t;
     
    % Step to Vtest 5ms
     Y0 = expm(Qtest * 5.0)*SS;
    
    % Step back down after 5ms to -45mV
     Ytest = expm(Q45 * 100.0)*Y0;
    
    % Calculate resurgent peak
     [t2,fval]=fminbnd(@(x) expmax(x,Q45,Y0,V_45),0,20);
     INa_res(j)=fval;
     t_res(j)=t2;
    
end %End of For J 1:length(V)

COND(:,1) = V;
COND(:,2) = t_peak;
COND(:,3) = INa_peak;
COND(:,4) = t_res;
COND(:,5) = INa_res;
COND(:,6) = INa_peak ./ (V - E_rev); %G_Na_peak
COND(:,7) = INa_res ./ (V - E_rev); %G_Na_res// SHOULD BE -45 - E_rev
COND(:,8) = COND(:,7) ./ COND(:,6); %G_Na_res / G_Na_peak
COND(:,9) = INa_res ./ INa_peak;

end %End of function COND


%TEST FUNCTIONS
function INa=expmax(t,Q,y0,V)
A=expm(Q*t)*y0;
E_rev = 71.5;
O = A(4);%
INa = 10*O*(V- E_rev);
end



