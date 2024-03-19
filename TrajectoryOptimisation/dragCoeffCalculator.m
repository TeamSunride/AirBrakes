function [CD, CD_B] = dragCoeffCalculator(V,A,data)
[Nrows,~] = size(V);
% drag force coeff for body, fins, nosecone 
% FROM MANDEL'S TOPICS IN ADVANCED ROCKETRY (PG 447)
Re_B = V .* data.LEN_ROCKET./data.KINEMATIC_VISC;
%B = 5*10^5*(0.73/Re_B^(1/5) - 1.328/sqrt(Re_B));
% if Re_B > 5*10^5
%     SKINFRICTION_BODY = 0.073/Re_B^(1/5) - B/Re_B;
% else
    SKINFRICTION_BODY = 0.073./Re_B.^(1/5);
% end 
AREA_RATIO = 4*(data.LEN_ROCKET-data.LEN_NOSECONE)/data.DIAMETER_BODY + 2.7*data.LEN_NOSECONE/data.DIAMETER_BODY;
F = 1 + 60/(data.LEN_ROCKET/data.DIAMETER_BODY)^3 + 0.0025*data.LEN_ROCKET/data.DIAMETER_BODY;
CD_FB = SKINFRICTION_BODY.*F.*AREA_RATIO; %forbody body drag
CD_DB = 0.029*(1/1)^3./sqrt(CD_FB); %forbody base drag
Re_F = V .* data.AVERAGECHORD_FIN ./ data.KINEMATIC_VISC;
SKINFRICTION_FIN = 1.328./sqrt(Re_F);
TC_RATIO = data.THICKNESS_FIN / data.AVERAGECHORD_FIN;
CD_F = 2.*SKINFRICTION_FIN.*(1+2*TC_RATIO).*data.AREA_FIN./data.AREA_FRONTBODY;
Ma = V./A;
CD_TOTAL = zeros(Nrows,1);
for i = 1:Nrows
    if(Ma(i)<1)
        CD_TOTAL(i,1) = (CD_F(i,1) + CD_DB(i,1) + CD_FB(i,1)).*(1./sqrt(1 - Ma(i,1).^2));
    else
        CD_TOTAL(i,:) = (CD_F(i,1) + CD_DB(i,1) + CD_FB(i,1)).*(1./sqrt(Ma(i,1).^2 - 1));
    end
end
%AIRBRAKE 
DELTA = 0.37.*data.maxABLength.*(V.*data.maxABLength./data.KINEMATIC_VISC).^(-1/5);
CD_B = data.CD_0 .* (1 - 0.25.* DELTA./data.maxABLength);

CD = CD_TOTAL;
end