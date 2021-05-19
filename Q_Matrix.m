% Q Matrix for 8 Upper Drug Free States


function Q = Q_Matrix(V, Inputs, Drug)  

%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 8314.472;	
F = 96485.3415;		
Q10=3;
T = 295;
Tfactor = 1.0/(Q10^( (37.0-(T-273))/10.0)); 

%%%%%%%%%% Drug Free Rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Input_DF = Inputs;

% C1-O-IF --> IM1; C1 -O-IS --> IS2 (double triangle)
% Single conducting state of O
     a11= Tfactor*1/(Input_DF(1)*exp(-V/Input_DF(2)));
	 a12= Input_DF(3)*a11;
	 a13= Input_DF(4)*a11;
     b11= Tfactor*1/(Input_DF(5)*exp(V/Input_DF(6)));
	 b12= Input_DF(7)*b11;
	 b13= Input_DF(8)*b11;
	 a3 = Tfactor*Input_DF(9)*exp(-V/Input_DF(10));
	 b3=  Tfactor*Input_DF(11)*exp((V)/Input_DF(12));	
	 a2=  Tfactor*(Input_DF(13)*exp(V/Input_DF(14)));
	 b2=  ((a13*a2*a3)/(b13*b3));
     
     a6= Tfactor*(Input_DF(15)*exp(V/Input_DF(16)));
     b6= Tfactor*Input_DF(17)*exp(-V/Input_DF(18));
     
    % Resurgent states
     a2s = Tfactor*(Input_DF(19)*exp(V/Input_DF(20)));
     b2s = Tfactor*( Input_DF(21)*exp(-V/Input_DF(22))  );
     
     a3s = Tfactor*Input_DF(23)*exp(-V/Input_DF(24));
     b3s = (a2s*a3s*a13)/(b2s*b13);
       
     %TEST FOR SCN4B KO
     %a6 = a6*1.5;
     %b6 = b6/1.5;
     

% Remove IS2
 Q = [
        %C3                         C2,                             C1,                             O,                          IS1,            IC3,                IC2,                    IF,                   IM1(IF2)      IM2(IS2)                                                                                     
        -(a11+b3),                  b11,                            0,                              0,                          0,              a3,                 0,                      0,                    0;%,                                    
        a11,                        -(b11+a12+b3),                  b12,                            0,                          0,              0,                  a3,                     0,                    0;%,                
        0,                          a12,                            -(b12+a13+b3+b3s),              b13,                        a3s,            0,                  0,                      a3,                   0;%,                                                                                                                    
        0,                          0,                              a13,                            -(b13+a2+a2s),              b2s,            0,                  0,                      b2,                   0;%,                                                                             
        0,                          0,                              b3s,                            a2s,                        -(b2s+a3s),     0,                  0,                      0,                    0;%,                
        b3,                         0,                              0,                              0,                          0,              -(a3+a11),          b11,                    0,                    0;%,                                                                     
        0,                          b3,                             0,                              0,                          0,              a11,                -(a3+b11+a12),          b12,                  0;%,                                                                             
        0,                          0,                              b3,                             a2,                         0,              0,                  a12,                    -(a3+b2+b12+a6),      b6;%,           
        0,                          0,                              0,                              0,                          0,              0,                  0,                      a6,                   -(b6)];%,        
   
end		