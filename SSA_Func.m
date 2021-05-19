% Steady State availability
function SSA = SSA_Func(Inputs)

V0 = -120; %-90
Vmax =-10;
Vtest = 0; 
Vstep = 3; 
V = (V0:Vstep:Vmax);
Drug = 0;

% Check RCOND
     Q = @Q_Matrix;
     Q=Q(-120, Inputs, Drug); %Arbitrary: set V to -125
     % Set last row of Q matrix to ones so that all eqs. are indep. 
     %Q(size(Q,1),:)=ones(1,size(Q,2));
     %RCND = rcond(Q);
   
% Create an array with each row corresponding to V, and each column is a different state SS = [C O I]
    SS = zeros(length(V), length(Q));
    
    SSA = zeros(length(V),3);
    OPEN_max = zeros(length(V),1);

    for i=1:length(V)
        SS(i,:) = findss(Q_Matrix(V(i),Inputs, Drug));
    
        Q=@Q_Matrix;                   
        Q= Q(Vtest, Inputs, Drug);
    
        % Find max Open Prob 
        [t,fval]=fminbnd(@(x) expmax(x,Q,SS(i,:)'),0,20);
        OPEN_max(i)=1/fval; %We're minimizing the function; so we're minimizing 1/GNa, thus GNa is 1/fval.
  
        SSA(i,1) = V(i);                     %Matrix SSA1, column 1 is test voltage
        SSA(i,2) = OPEN_max(i);              %Matrix SSA1, column 2 is MAX
        SSA(i,3) = SSA(i,2)/SSA(1,2);        %Matrix SSA1, column 3, normalize to first pulse. 
    
    end

end


%TEST FUNCTIONS
function OPEN_max=expmax(t,Q,y0)
A=expm(Q*t)*y0;
OPEN_max = 1/A(4); %A(4) is the Open state probability
end