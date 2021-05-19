%ACT FUNC 2
% Steady State Activation
function ACT = ACT_Func(Inputs)

E_rev = 71.5; %71.5
V0 = -80; 
Vmax =0; 
Vstep = -5; 
V = (Vmax:Vstep:V0);
Drug = 0.0;


%Calculate SS at -160mV
SS = findss(Q_Matrix(V0,Inputs, Drug));

%Initialize vectors
GNa=zeros(1,length(V));    
ACT = zeros (length(V), 4);
    
 
    for j = 1:length(V)
    V_test = V(j);
    
    Q=@Q_Matrix;                   
    Q = Q(V_test, Inputs, Drug);
    
    % Find max GNa 
    [t,fval]=fminbnd(@(x) expmax(x,Q,SS),0,20);
    GNa(j)=1/fval; %We're minimizing the function; so we're minimizing 1/GNa, thus GNa is 1/fval.
  

 
    ACT(j,1) = V_test;                     
    ACT(j,2) = GNa(j);                       
    ACT(j,3) = GNa(j)/ACT(1,2);
    ACT(j,4) = ACT(j,2).*(V_test - E_rev); %Plotting peak current density: GNa*(V_test - ENa)
    
    end
    
    
    ACT = ACT;


end


%TEST FUNCTIONS
function GNa_inv=expmax(t,Q,y0)
A=expm(Q*t)*y0;
GNa_inv = 1/A(4); %A(4) is the Open state probability
end