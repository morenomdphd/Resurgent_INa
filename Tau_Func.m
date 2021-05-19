%Tau and FLU Tau function
function TAU = Tau_Func(Inputs)

E_rev = 71.5; %71.5;
V0 = -90; 
Vmax =0; 
Vstep = -5; 
V = (Vmax:Vstep:-50);
Drug = 0;

%Calculate SS at V0
SS = findss(Q_Matrix(V0,Inputs, Drug));
Q = Q_Matrix(V0, Inputs, Drug);

%Open state vector
OSvector = [0, 0, 0, 1, 0, 0, 0, 0];


INa=zeros(1,length(V));
tPeak=zeros(1,length(V));
Tau = zeros(1,length(V));


for j = 1:length(V)
    V_test = V(j);
    
    Q=@Q_Matrix;                   
    Q = Q(V_test, Inputs, Drug);
   
    % Find peak I_Na 
     [t,fval]=fminbnd(@(x) expmax(x,Q,SS,V_test),0,20);
     INa(j)=fval;
     tPeak(j)=t;
    
    % Calculate Tau to 37%    
     opts=optimset('TolX',1e-3);
     [t1]=fminbnd(@(x) exptau(x,Q,SS,fval,V_test),t,20,opts);
     Tau(j) = t1 - t;
         
    
end %End of For J 1:length(V)

TAU(:,1) = V;
TAU(:,2) = Tau;
TAU(:,3) = INa;
TAU(:,4) = tPeak;


end %End of function TAU



%TEST FUNCTIONS
function INa=expmax(t,Q,y0,V)
E_rev = 71.5; %71.5;
A=expm(Q*t)*y0;
O = A(4);
INa = 10*O*(V- E_rev);
end


function Tau=exptau(t,Q,y0,fval,V)
E_rev = 71.5; %71.5;
A=expm(Q*t)*y0;
O = A(4);
INa = 10*O*(V- E_rev);
Tau=abs(INa - 0.37*fval);
end















