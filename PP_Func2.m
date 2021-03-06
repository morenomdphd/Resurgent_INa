% Prepulse duration, with PP2 = +20mV (PP2 = +20mV).

function PREPULSE2 = PP_Func2(Inputs)

V0 = -90; 
Vtest =20;
Vrest = -45; %-45
Drug = 0;


PP_time = [2;4;6;8;10;12;14;16;18;20;22;24;26;28;30;32;34;36];

% Set up vectors
PREPULSE2 = zeros(length(PP_time),7);
t_res_Peak = zeros(length(PP_time),1);
INa_res_peak = zeros(length(PP_time),1);

% Calculate SS at V0
SS = findss(Q_Matrix(V0,Inputs, Drug));

% Q Matricies
Qtest = Q_Matrix(Vtest, Inputs, Drug);
Qrest = Q_Matrix(Vrest, Inputs, Drug);


% Grab Peak INa
[t,fval]=fminbnd(@(x) expmax(x,Qtest,SS,Vtest), 0, 5);
t_peak = t;
INa_peak = fval;


for i=1:length(PP_time)
    
    % Step to Vmax for Prepulse time
    Ytest = expm(Qtest * PP_time(i) ) * SS;
    
    % Step back to rest and calculate peak resurgent current
    Yrest = expm(Qrest * 125.0) * Ytest;

    % Calculate resurgent peak
    [t,fval]=fminbnd(@(x) expmax(x,Qrest,Ytest,Vrest), 0, 25);
    INa_res_peak(i)=fval;
    t_res_Peak(i)=t;




end

PREPULSE2(:,1) = PP_time;
PREPULSE2(:,2) = t_res_Peak; % Note, this t, starts right after step down. A t= 0, we step down.
PREPULSE2(:,3) = INa_res_peak;
PREPULSE2(:,4) = (INa_res_peak / PREPULSE2(1,3) ); %Normalized of t = 2ms
PREPULSE2(:,5) = Vtest;
PREPULSE2(1,6) = t_peak;
PREPULSE2(1,7) = INa_peak;

end

%TEST FUNCTIONS
function INa=expmax(t,Q,y0,V)
A=expm(Q*t)*y0;
E_rev = 71.5;
O = A(4);
INa = 10*O*(V- E_rev);
end

