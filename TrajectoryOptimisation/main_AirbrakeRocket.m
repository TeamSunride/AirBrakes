% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk
%% Solve the problem
clear all;close all;format compact;
[problem,guess]=Airbrake3;          % Fetch the problem definition
options= problem.settings(100);                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);

%%
xx=linspace(solution.T(1,1),solution.tf,1000);
figure(1)
subplot(1,2,1)
plot(xx,speval(solution,'dU',1,xx),'b-',LineWidth=2 )
hold on
plot([solution.T(1,1); solution.tf],[problem.inputs.url, problem.inputs.url],'r--' )
plot([solution.T(1,1); solution.tf],[problem.inputs.uru, problem.inputs.uru],'r--' )
xlim([0 solution.tf])
ylim([-0.5 0.5])
xlabel('Time [s]', FontSize=12, FontWeight='bold');
ylabel({'Deployment Rate [ per sec ]','(-0.3 \leq du \leq +0.3)'}, FontSize=12, FontWeight='bold');
title("Deployment rate over time")
grid on
hold off
subplot(1,2,2)
plot(solution.T,solution.U, 'r-', LineWidth=2)
xlabel('Time [s]',FontSize=12, FontWeight='bold');
ylabel({'Deployment Level','(0 \leq u \leq 1)'} ,FontSize=12, FontWeight='bold');
title("Deployment level over time (control input)")
grid on
figure(2)
p = plot(solution.T, solution.X(:,3), LineWidth=2);
datatip(p,xx(end),solution.X(end,3))
xlabel('Time [s]',FontSize=12, FontWeight='bold');
ylabel({'Altitude[ m ]', '(Target = 4400m)'}, FontSize=12, FontWeight='bold');
grid on
title("Altitude over time")
