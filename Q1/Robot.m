function [ xt, v_xt, yt, v_yt ] = Robot( xt_1, v_xt_1, yt_1, v_yt_1, I_x, I_y)

K = 2.4;
Mr = 5;
dt = 1/100;

control_x = I_x * K;
control_y = I_y * K;

if control_x > 20
    control_x = 20;
end

if control_x < -20;
    control_x = -20;
end

if control_y > 20
    control_y = 20;
end

if control_y < -20;
    control_y = -20;
end



xt = xt_1 + v_xt_1 + normrnd(0, 0.000002);
yt = yt_1 + v_yt_1 + normrnd(0, 0.000002);

v_xt = v_xt_1 + (dt * control_x / Mr) + (dt * 0.2 * control_y / Mr) + normrnd(0, 0.000004);
v_yt = v_yt_1 + (dt * control_y / Mr) + (dt * 0.2 * control_x / Mr) + normrnd(0, 0.000004);

end

