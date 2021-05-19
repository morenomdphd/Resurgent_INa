%% MAIN FILE

% Start here to run the optimization code. It is set up to run 500
% iterations and save the last matrix as "Inputs_Final". The two matricies
% below are the final inputs for both WT and KO as published.


Inputs_Final =[
   2.3989e-02;
   9.6108e+02;
   8.5613e+02;
   7.2682e+01;
   1.7233e-01;
   1.9691e+01;
   8.8549e+01;
   1.4841e+02;
   3.6734e-01;
   9.8034e+02;
   5.3241e+01;
   1.4204e+01;
   8.7852e+01;
   9.9972e+02;
   6.0921e+02;
   8.6490e+01;
   1.5645e+02;
   3.0317e+01;
   1.5817e+01;
   9.9982e+02;
   1.0010e-03;
   1.1963e+01;
   4.4773e-03;
   9.9993e+02];

Inputs_Final_KO =[
   2.0761e-02;
   9.7685e+02;
   8.3340e+02;
   6.1087e+01;
   1.6995e-01;
   1.8560e+01;
   9.3042e+01;
   1.7914e+02;
   3.9273e-01;
   9.8807e+02;
   4.7402e+01;
   1.3469e+01;
   8.1085e+01;
   9.9984e+02;
   6.0756e+02;
   7.8591e+01;
   1.6214e+02;
   4.3656e+01;
   2.3130e+01;
   9.9969e+02;
   1.0208e-03;
   1.1383e+01;
   2.8677e-03;
   9.8330e+02];


%% 
load('Inputs_Final.mat');
Inputs = Inputs_Final;

% Define lower (lb), and upper (ub) bounds
LB = 1e-3;
UB = 1e3;

lb = [LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB; LB];
ub = [UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB; UB];

%Nelder Mead:
options = optimset('Display','iter','TolFun',1e-2, 'TolX', 1e-2, 'MaxFunEvals', 500000000, 'MaxIter', 500); 
Inputs_Final = fminsearchbnd(@Na_Matrix_DrugFree, Inputs, lb, ub, options);
save('Inputs_Final.mat', 'Inputs_Final');

[Total_Error, SSA, ACT, TAU, RFI, RES, PREPULSE2, COND] = Na_Matrix_DrugFree(Inputs_Final);

%delete(gcp('nocreate'));

