%File for testing and creating plots, tables and other miscellaneous tasks

V = linspace(160,0,100)';
H = linspace(200,1500,100)';
[~,A,~,~] = atmosisa(H);

%constants
data.massB = 4.2525;
data.Inertia = diag([0.035, 4.6, 4.6]);
data.Length = 1.842;
data.RailAngle = 90.0;
data.referenceArea = 81.7*10^-4;
data.controlSurfaceArea = 34.5*10^-4;
data.nomAB_DC = 1.17;
data.airBrakePosition = 1.54;
data.maxABLength = 0.021;
data.ABonDC = 0.79;
data.ABoffDC = 0.35;
data.normalDC = 13.6;
data.dampDC = 4.88;
data.stability = 0.408;
data.CoM = [0, 0, 1.05/2]; %needs to be measured for a rocket
data.wind = [0,0,2];

% Dimensions of nose, body and fins (m)
data.LEN_NOSECONE = 150*10^-3;
data.ROOTCHORD_FIN = 85*10^-3;
data.TIPCHORD_FIN = 50*10^-3;
data.AVERAGECHORD_FIN = (85*10^-3 + 50*10^-3)/2;
data.THICKNESS_FIN = 0.238*10^-3;
data.HEIGHT_FIN = 53*10^-3;
data.MIDCHORD_FIN = 53*10^-3;
data.SWEEPANGLE_FIN = 24*pi/180;
data.SWEEPLENGTH_FIN = 23.3*10^-3;
data.AREA_FIN = (85*10^-3 + 50*10^-3)/2 * 53*10^-3* 4;
data.DIAMETER_BODY = 60*10^-3;
data.LEN_ROCKET = 1140*10^-3;
data.KINEMATIC_VISC = 1.495*10^-5;
data.AREA_FRONTBODY = pi*(60*10^-3)^2/4;
data.maxABLength = 0.021; % == x, assumption for boundary layer
data.CD_0 = 1.17;
data.referenceArea = 81.7*10^-4;
data.controlSurfaceArea = 34.5*10^-4;

%wind = [0,0,0]; %constant for now
data.ref_roll = [0,0,1]; %roll axis
% CD = zeros(101,101);
% CD_b = zeros(101,101);
% CD(1,2:end) = V;
% CD(2:end,1) = A';
% CD_b(1,2:end) = V;
% CD_b(2:end,1) = A';
% for i = 2:101
%     for j = 2 : 101
%     [cd,cd_b] = dragCoeffCalculator(V(i-1),A(j-1),data);
%     CD(j,i) = cd;
%     CD_b(j,i) = cd_b;
%     end
% end
%%
V = linspace(160,0.1,100)';
H = linspace(200,1500,100)';
[~,A,~,~] = atmosisa(H);
cd_table = load("CD.mat");
cdb_table = load("CD_B.mat");
[CD, CD_B] = cd_lookup(V,A,cd_table,cdb_table);
% CD_total = CD + u.*(data.controlSurfaceArea./data.referenceArea).*CD_B;
[CD_t, CD_Bt] = dragCoeffCalculator(V,A,data);
plot(CD)
hold on 
plot(CD_t)
hold off

figure(2)
plot(CD - CD_t)

%%

V_t = linspace(200,0.1,100);
H_t = linspace(200, 1500, 100);
[~,A_t,~,~] = atmosisa(H_t);

tic 
[CD, CD_B] = cd_lookup(V_t,A_t,cd_table,cdb_table);
toc
tic
[CD_t, CD_Bt] = dragCoeffCalculator(V_t,A_t,data);
toc