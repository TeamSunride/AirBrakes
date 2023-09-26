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
[problem,guess]=AirbrakesRocket;          % Fetch the problem definition
options= problem.settings(100);                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);