% RFI function
function RFI = RFI_Func(Inputs)

E_rev = 71.5; %71.5; 38
V0 = -90; %???-80
Vtest =0;
Mex = 0;

%Calculate SS at -100mV
SS = findss(Q_Matrix(V0,Inputs, Mex));

%Step to Vtest for 5ms
Qtest = Q_Matrix(Vtest, Inputs, Mex);
Ytest = expm(Qtest * 5)*SS;

%Calculate peak
[t,fval]=fminbnd(@(x) expmax(x,Qtest,SS,Vtest),0,20);
INa_Peak_0=fval;
tPeak=t;

%Step back to V0
Q0 = Q_Matrix(V0, Inputs, Mex);

%Calculate Y0 at defined recovery times
Rec_time = [0.01; 0.1; 0.3; 0.5; 1; 2; 3; 4; 5; 7; 10; 12; 15; 20; 25];

Y0 = zeros(length(Rec_time), length(Q0));
RFI = zeros(length(Rec_time),3);

for i=1:length(Rec_time)
    
    %Calculates the states at a variable recovery time
    Y0(i,:) = expm(Q0 * Rec_time(i))*Ytest;
    
    %Calculate peak after step up.
    [t,fval]=fminbnd(@(x) expmax(x,Qtest,Y0(i,:)', Vtest),0,20);
    INa_peak_test = fval;
    
    RFI(i,1) = Rec_time(i);
    RFI(i,2) = INa_peak_test;
    RFI(i,3) = (INa_peak_test / INa_Peak_0);
    
end



end


%TEST FUNCTIONS
function INa=expmax(t,Q,y0,V)
E_rev = 71.5; %71.5; 38
A=expm(Q*t)*y0;
O = A(4);
INa = 10*O*(V- E_rev);
end