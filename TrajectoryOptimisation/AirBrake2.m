function [problem,guess] = AirBrake2
%myProblem - Template file for optimal control problem definition
%
%Syntax:  [problem,guess] = myProblem
%
% Outputs:
%    problem - Structure with information on the optimal control problem
%    guess   - Guess for state, control and multipliers.
%
% Other m-files required: none
% MAT-files required: none
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk

%------------- BEGIN CODE --------------
% Plant model name, provide in the format of function handle
InternalDynamics=@AirbrakesRocket_Dynamics_Internal; 
SimDynamics=@AirbrakesRocket_Dynamics_Sim;

% Analytic derivative files (optional), provide in the format of function handle
% problem.analyticDeriv.gradCost=@gradCost_myProblem;
% problem.analyticDeriv.hessianLagrangian=@hessianLagrangian_myProblem;
% problem.analyticDeriv.jacConst=@jacConst_myProblem;

% (optional) customized call back function
%problem.callback=@callback_myProblem;

x0 = [0,0,200,1,0,0,0,0,0,166,0,0,0];
x_min = [0,0,200,0,0,0,0,-500,-500,-500,-100,-100,-100];
x_max = [inf, inf, inf, 1,1,1,1, 500,500,500, 100,100,100];
x_tol = [1 ,1, 1, 1e-2 ,1e-2 ,1e-2, 1e-2 ,1, 1,1,1, 1, 1];

goal = 1550;
[CN,CoP] = CoeffCalculator();
% Settings file
problem.settings=@settings_AirbrakesRocket;

%Initial Time. t0<tf
t0 = 0;
problem.time.t0_min=t0;
problem.time.t0_max=t0;
guess.t0=0;

% Final time. Let tf_min=tf_max if tf is fixed.
problem.time.tf_min=-inf;     
problem.time.tf_max=inf; 
guess.tf=20;

% Parameters bounds. pl=< p <=pu
problem.parameters.pl=[];
problem.parameters.pu=[];
guess.parameters=[];

% Initial conditions for system.
problem.states.x0=x0;

% Initial conditions for system. Bounds if x0 is free s.t. x0l=< x0 <=x0u
problem.states.x0l=x0; 
problem.states.x0u=x0; 

% State bounds. xl=< x <=xu
problem.states.xl=x_min;
problem.states.xu=x_max;

% State rate bounds. xrl=< x_dot <=xru
problem.states.xrl=[-inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf]; 
problem.states.xru=[inf inf inf inf inf inf inf inf inf inf inf inf inf ]; 

% State error bounds
problem.states.xErrorTol_local=x_tol; 
problem.states.xErrorTol_integral=x_tol; 

% State constraint error bounds
problem.states.xConstraintTol=x_tol;
problem.states.xrConstraintTol=x_tol;

% Terminal state bounds. xfl=< xf <=xfu
problem.states.xfl=[-inf,-inf,-inf,-1,-1,-1,-1,-inf,-inf,0.1, -inf, -inf, -inf];
problem.states.xfu=[inf,inf,inf,1,1,1,1,inf,inf,0.2, inf, inf, inf];

% Guess the state trajectories with [x0 ... xf]
guess.time=[t0 20];
guess.states(:,1)=[0 1800];
guess.states(:,2)=[0 1800];
guess.states(:,3)=[0 goal];
guess.states(:,4)=[1 1];
guess.states(:,5)=[0 0];
guess.states(:,6)=[0 0];
guess.states(:,7)=[0 0];
guess.states(:,8)=[0 0];
guess.states(:,9)=[0 0];
guess.states(:,10)=[166 0];
guess.states(:,11)=[0 0];
guess.states(:,12)=[0 0];
guess.states(:,13)=[0 0];


% Number of control actions N 
% Set problem.inputs.N=0 if N is equal to the number of integration steps.  
% Note that the number of integration steps defined in settings.m has to be divisible 
% by the  number of control actions N whenever it is not zero.
problem.inputs.N=0;       
      
% Input bounds
problem.inputs.ul=[0];
problem.inputs.uu=[1];

% Bounds on the first control action
problem.inputs.u0l=[0];
problem.inputs.u0u=[0];

% Input rate bounds
problem.inputs.url=[-0.3]; 
problem.inputs.uru=[0.3]; 

% Input constraint error bounds
problem.inputs.uConstraintTol=[0.01];
problem.inputs.urConstraintTol=[0.01];

% Guess the input sequences with [u0 ... uf]
guess.inputs(:,1)=[0 0.8];


% Path constraint function 
problem.constraints.ng_eq=0; % number of quality constraints in format of g(x,u,p,t) == 0
problem.constraints.gTol_eq=[]; % equality cosntraint error bounds

problem.constraints.gl=[]; % Lower ounds for inequality constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.gu=[]; % Upper ounds for inequality constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.gTol_neq=[]; % inequality constraint error bounds

% OPTIONAL: define the time duration each constraint will be active, for
% example (for ECH enabled in setings)
% problem.constraints.gActiveTime{1}=[guess.tf/2 guess.tf];
% problem.constraints.gActiveTime{2}=[];
% ...
% problem.constraints.gActiveTime{5}=[];

% Bounds for boundary constraints bl =< b(x0,xf,u0,uf,p,t0,tf) =< bu
problem.constraints.bl=[];
problem.constraints.bu=[];
problem.constraints.bTol=[]; 

% store the necessary problem parameters used in the functions
%constants
problem.data.massB = 4.2525;
problem.data.Inertia = diag([0.035, 4.6, 4.6]);
problem.data.Length = 1.842;
problem.data.RailAngle = 90.0;
problem.data.referenceArea = 81.7*10^-4;
problem.data.controlSurfaceArea = 34.5*10^-4;
problem.data.nomAB_DC = 1.17;
problem.data.airBrakePosition = 1.54;
problem.data.maxABLength = 0.021;
problem.data.ABonDC = 0.79;
problem.data.ABoffDC = 0.35;
problem.data.normalDC = 13.6;
problem.data.dampDC = 4.88;
problem.data.stability = 0.408;
problem.data.CoM = [0, 0, 1.05/2]; %needs to be measured for a rocket
problem.data.wind = [0,0,2];

% Dimensions of nose, body and fins (m)
problem.data.LEN_NOSECONE = 150*10^-3;
problem.data.ROOTCHORD_FIN = 85*10^-3;
problem.data.TIPCHORD_FIN = 50*10^-3;
problem.data.AVERAGECHORD_FIN = (85*10^-3 + 50*10^-3)/2;
problem.data.THICKNESS_FIN = 0.238*10^-3;
problem.data.HEIGHT_FIN = 53*10^-3;
problem.data.MIDCHORD_FIN = 53*10^-3;
problem.data.SWEEPANGLE_FIN = 24*pi/180;
problem.data.SWEEPLENGTH_FIN = 23.3*10^-3;
problem.data.AREA_FIN = (85*10^-3 + 50*10^-3)/2 * 53*10^-3* 4;
problem.data.DIAMETER_BODY = 60*10^-3;
problem.data.LEN_ROCKET = 1140*10^-3;
problem.data.KINEMATIC_VISC = 1.495*10^-5;
problem.data.AREA_FRONTBODY = pi*(60*10^-3)^2/4;
problem.data.maxABLength = 0.021; % == x, assumption for boundary layer
problem.data.CD_0 = 1.17;
problem.data.referenceArea = 81.7*10^-4;
problem.data.controlSurfaceArea = 34.5*10^-4;

%wind = [0,0,0]; %constant for now
problem.data.ref_roll = [0,0,1]; %roll axis
problem.data.CN = CN;
problem.data.CoP = CoP;

problem.data.cd_table = load("CD.mat");
problem.data.cdb_table = load("CD_B.mat");

problem.data.g = [0,0,-9.81]; %gravity
problem.data.goal = goal;

% Get function handles and return to Main.m
problem.data.InternalDynamics=InternalDynamics;
problem.data.functionfg=@fg;
problem.data.plantmodel = func2str(InternalDynamics);
problem.functions={@L,@E,@f,@g,@avrc,@b};
problem.sim.functions=SimDynamics;
problem.sim.inputX=[];
problem.sim.inputU=1:length(problem.inputs.ul);
problem.functions_unscaled={@L_unscaled,@E_unscaled,@f_unscaled,@g_unscaled,@avrc,@b_unscaled};
problem.data.functions_unscaled=problem.functions_unscaled;
problem.data.ng_eq=problem.constraints.ng_eq;
problem.constraintErrorTol=[problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.states.xConstraintTol,problem.states.xConstraintTol,problem.inputs.uConstraintTol,problem.inputs.uConstraintTol];

%------------- END OF CODE --------------

function stageCost=L_unscaled(x,xr,u,ur,p,t,data)

% L_unscaled - Returns the stage cost.
% The function must be vectorized and
% xi, ui are column vectors taken as x(:,i) and u(:,i) (i denotes the i-th
% variable)
% 
% Syntax:  stageCost = L(x,xr,u,ur,p,t,data)
%
% Inputs:
%    x  - state vector
%    xr - state reference
%    u  - input
%    ur - input reference
%    p  - parameter
%    t  - time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    stageCost - Scalar or vectorized stage cost
%
%  Remark: If the stagecost does not depend on variables it is necessary to multiply
%          the assigned value by t in order to have right vector dimesion when called for the optimization. 
%          Example: stageCost = 0*t;

%------------- BEGIN CODE --------------

%Define states and setpoints


stageCost = 0.*t;

%------------- END OF CODE --------------


function boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 

% E_unscaled - Returns the boundary value cost
%
% Syntax:  boundaryCost=E(x0,xf,u0,uf,p,tf,data)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    boundaryCost - Scalar boundary cost
%
%------------- BEGIN CODE --------------

boundaryCost= (1/data.goal^2).*(data.goal - xf(3)).^2;

%------------- END OF CODE --------------

function bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,data,varargin)

% b_unscaled - Returns a column vector containing the evaluation of the boundary constraints: bl =< bf(x0,xf,u0,uf,p,t0,tf) =< bu
%
% Syntax:  bc=b(x0,xf,u0,uf,p,tf,data)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
%          
% Output:
%    bc - column vector containing the evaluation of the boundary function 
%
% Leave it here
varargin=varargin{1};
%------------- BEGIN CODE --------------
bc = [];
%------------- END OF CODE --------------
% When adpative time interval add constraint on time
if length(varargin)==2
    options=varargin{1};
    t_segment=varargin{2};
    if strcmp(options.transcription,'hpLGR') && options.adaptseg==1 
        if size(t_segment,1)>size(t_segment,2)
            bc=[bc;diff(t_segment)];
        else
            bc=[bc,diff(t_segment)];
        end
    end
end

%------------- END OF CODE --------------

