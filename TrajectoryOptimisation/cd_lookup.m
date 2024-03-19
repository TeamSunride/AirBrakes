function [CD, CD_B] = cd_lookup(V,A,cd, cd_b)
a_points = cd.CD(:,2);
v_points = cd.CD(:,1);
actual_cd = cd.CD(:,3:end);
actual_cd_b = cd_b.CD_b(:,3:end);

CD = interp2(v_points,a_points,actual_cd,V,A,"linear",0);
CD_B = interp2(v_points,a_points,actual_cd_b,V,A,"linear", 0);
end