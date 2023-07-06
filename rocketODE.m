function dxdt = rocketODE(t, x)
    position = [x(1), x(2), x(3)];
    quaternion = [x(4), x(5), x(6), x(7)];
    quaternion = quaternion ./ norm(quaternion); %normalize
    Lvelocity = [x(8), x(9), x(10)];
    Avelocity = [x(11), x(12), x(13)];

    dxdt = zeros(13,1); %allocate memory

    %constants
    massB = 4.2525;
    Inertia = diag([0.035, 4.6, 4.6]);
    %Length = 1.842;
    %RailAngle = 90.0;
    referenceArea = 81.7*10^-4;
    controlSurfaceArea = 34.5*10^-4;
    %nomAB_DC = 1.17;
    %airBrakePosition = 1.54;
    %maxABLength = 0.021;
    %ABonDC = 0.79;
    %ABoffDC = 0.35;
    normalDC = 13.6;
    dampDC = 4.88;
    %stability = 0.408;

    wind = [0,0,0]; %constant for now
    ref_roll = [0,0,1]; %roll axis
    CoP = [0,0,-0.3]; %dist from CoM, arbritrary for now -- soruce for discrepancies
    g = [0,0,-9.81]; %gravity

    %postion dot
    dxdt(1) = x(8);   % pos dot is equal to velocity
    dxdt(2) = x(9);
    dxdt(3) = x(10);


    %quaternion dot
    q_w = quaternion(1);
    q_v = quaternion(2:end);
    q_dot = [0.5.*dot(Avelocity, q_v), 0.5.*(q_w.*Avelocity + cross(Avelocity, q_v))];
    dxdt(4) = q_dot(1);
    dxdt(5) = q_dot(2);
    dxdt(6) = q_dot(3);
    dxdt(7) = q_dot(4);

    %v dot
    Fg = massB.*g;

    R = quat2rotm(real(quaternion)); % Rotation matrix
    e_roll = (R*ref_roll')'; % compute the roll axis in current orientation

    var_w = 1.8*2^2*(position(3)/500)^(2/3) * (1 - 0.8 * position(3)/500)^2; %variance of wind
    std_w = sqrt(var_w);    %standard deviation
    %wind = [0, 0, normrnd(0,std_w)]; % zero mean normal distribution of wind

    V_cop = Lvelocity + cross(Avelocity, (CoP - position));
    V_app = V_cop + wind;
    n_Vapp = V_app ./ norm(V_app);
    [~, a, ~, rho] = atmoscoesa(position(3));
    
    u = 1;
    CD_b = 1.036; %found from rearranging the formula with initial values provided
    CD_r = 0.2502* 1/sqrt(1 - (norm(V_app)/a)^2); % got the 0.2502 by rearraging using the inital values given (also chceck if V_app should be used)
    CD_a = CD_r + u*(controlSurfaceArea/referenceArea)*CD_b; %no control input for now

    Fa = ((-rho/2)*CD_a*referenceArea* norm(V_app)^2).*e_roll;
    AoA = acos(dot(n_Vapp, e_roll)); %angle of attack, radians for now
    CD_n = normalDC * AoA; %asuming normalDC is constant for now, it may not be

    Fn = ((rho/2)*CD_n*referenceArea* norm(V_app)^2).*(cross(e_roll, cross(e_roll, n_Vapp)));
    vdot = (1/massB).*(Fn + Fa + Fg);

    dxdt(8) = vdot(1);
    dxdt(9) = vdot(2);
    dxdt(10) = vdot(3);
    %disp(Lvelocity(3));
    %w dot
    
    stability = norm(CoP - position);
    torque_n = (stability * norm(Fn)) .* cross(e_roll, V_app);
    torque_damp = (-1*dampDC).*(R*diag([1 1 0])/R)*Avelocity';
    wdot = Inertia\(torque_damp+torque_n); 

    dxdt(11) = wdot(1);
    dxdt(12) = wdot(2);
    dxdt(13) = wdot(3);
end