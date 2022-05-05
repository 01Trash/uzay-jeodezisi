clc, clear
pkg load io

% Pazar günü = 0
gun = 0;

%%% Yerçekimi sabiti m^3/s^2
GM = 3.986005E+14;
%%% Yerin açısal dönme hızı rad/s
We = 7292115.1467E-11;


%%% Verileri çek
filename = 'broadcast_12.ods';
data_source = xlsread(filename);


[m,n] = size(data_source);
for i = 1:m;
    k = 1:n;


    % t => W_second_
    W_second_ = gun*86400 + data_source(i, 4)*3600 + data_source(i, 5)*60 + data_source(i, 6);
##    W_second_ = W_second(i,1);

    a0_ = data_source(i, 7);
##    a0_ = a0(i,1);

    a1_ = data_source(i,8);
##    a1_ = a1(i,1);

    a2_ = data_source(i,9);
##    a2_ = a2(i,1);

    Crs_ = data_source(i, 11);
##    Crs_ = Crs(i,1);

    Delta_n_ = data_source(i, 12);
##    Delta_n_ = Delta_n(i,1);

    M0_ = data_source(i, 13);
##    M0_ = M0(i,1);

    Cuc_ = data_source(i, 14);
##    Cuc_ = Cuc(i,1);

    e_ = data_source(i, 15);
##    e_ = e(i,1);

    Cus_ = data_source(i, 16);
##    Cus_ = Cus(i,1);

    sqrt_a_ = data_source(i, 17);
##    sqrt_a_ = sqrt_a(i,1);

    t0_ = data_source(i, 18);
##    t0_ = t0(i,1);

    Cic_ = data_source(i, 19);
##    Cic_ = Cic(i,1);

    l0_ = data_source(i, 20);
##    l0_ = l0(i,1);

    Cis_ = data_source(i,21);
##    Cis_ = Cis(i,1);

    i0_ = data_source(i, 22);
##    i0_ = i0(i,1);

    Crc_ = data_source(i, 23);
##    Crc_ = Crc(i,1);

    W0_ = data_source(i, 24);
##    W0_ = W0(i,1);

    Delta_l_ = data_source(i, 25);
##    Delta_l_ = Delta_l(i,1);

    Delta_i_ = data_source(i, 26);
##    Delta_i_ = Delta_i(i,1);

    W_GPS_ = data_source(i, 28);
##    W_GPS_ = W_GPS(i,1);

    tc_ = data_source(i, 34);
##    tc_ = tc(i,1);

    % SORULACAK!!!
    W_sifir = W_GPS_;


    tk = (W_GPS_ - W_sifir) * 608400 + W_second_ - t0_;

    Mk = M0_ + (sqrt(GM/sqrt_a_^6) + Delta_n_)*tk;

     %%% İterasyon
    Ek = Mk;
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);
    Ek = Mk + e_ * sin(Ek);

    pay = sqrt(1-e_*e_) * sin(Ek);
    payda = cos(Ek) - e_;

    %%fk = abs(atan(pay / payda));
    % 1. bölge
    if (pay > 0 && payda > 0)
        fk = atan(pay / payda);
    % 2. bölge
    elseif (pay > 0 && payda < 0)
        fk = atan(pay / payda);
        fk = fk + pi;
    % 3. bölge
    elseif (pay < 0 && payda < 0)
        fk = atan(pay / payda);
        fk = fk + pi;
    % 4. bölge
    elseif (pay < 0 && payda > 0)
        fk = atan(pay / payda);
        fk = fk + 2 * pi;
    endif;

    %fprintf("i: %.d \n", i);

    uk = W0_ + fk + Cuc_ * cos(2*(W0_ + fk)) + Cus_*sin(2*(W0_+fk));

    rk = sqrt_a_ * sqrt_a_ * (1-e_*cos(Ek)) + Crc_*cos(2*(W0_ + fk)) + Crs_*sin(2*(W0_ + fk));
    %fprintf("rk: %.d \n", rk);

    ik = i0_ + Delta_i_ * tk + Cic_ * cos(2*(W0_ + fk)) + Cis_*sin(2*(W0_ + fk));

    lk = l0_ + (Delta_l_ - We)*tk - We * t0_;


    %rk * (cos(lk)*cos(uk) - sin(lk)*sin(uk)*cos(ik))
    Xk = (rk * (cos(lk) * cos(uk) - sin(lk) * sin(uk) * cos(ik)))/1000;
    %fprintf("Xk: %4.7f km ", Xk);
    Yk = (rk * (sin(lk)*cos(uk) + cos(lk)*sin(uk)*cos(ik)))/1000;
    %fprintf("Yk: %4.7f km ", Yk);
    Zk = (rk * sin(uk)*sin(ik))/1000;
    %fprintf("Zk: %4.7f km ", Zk);
    Delta_time = (a0_ + a1_*(W_second_ - tc_) + a2_*(W_second_ - tc_)*(W_second_ - tc_))*1000000;

    M(i,1) = W_second_;
    M(i,2) = Xk;
    M(i,3) = Yk;
    M(i,4) = Zk;
    M(i,5) = Delta_time;


    %fprintf("%2.d: Xk: %8.7f || Yk: %8.7f || Zk: %8.7f\n", i, M(i,1), M(i,2), M(i,3));

    i = i + 1;
    k = k + 1;

end;

%fprintf("Crs: %8.4f", Crs(i,1));


%%% Verileri çek
filename = 'erdem.ods';
data_source = xlsread(filename);

k = 1;
[m,n] = size(data_source);
for k = 1:m;

    rbro(k,1) = M(k,2);
    rbro(k,2) = M(k,3);
    rbro(k,3) = M(k,4);
    rbro(k,4) = M(k,5);

    rpre(k,1) = data_source(k,5);
    rpre(k,2) = data_source(k,6);
    rpre(k,3) = data_source(k,7);
    rpre(k,4) = data_source(k,8);

    k = k + 1;

end;

time = 0;
j = 1;
[m,n] = size(data_source);
for j = 1:m;

    rpre_rbro(j,1) = time;
    rpre_rbro(j,2) = (rpre(j,1) - rbro(j,1))/1000;
    rpre_rbro(j,3) = (rpre(j,2) - rbro(j,2))/1000;
    rpre_rbro(j,4) = (rpre(j,3) - rbro(j,3))/1000;
    rpre_rbro(j,5) = (rpre(j,4) - rbro(j,4));
    rpre_rbro(j,6) = (sqrt(rpre(j,1)*rpre(j,1) + rpre(j,2)*rpre(j,2) + rpre(j,3)*rpre(j,3)) - sqrt(rbro(j,1)*rbro(j,1) + rbro(j,2)*rbro(j,2) + rbro(j,3)*rbro(j,3)));


    j = j + 1;
    time = time + 900;

end;
%csvwrite("veri.xlsx", rpre_ryuma);


[m,n] = size(data_source);
for j = 1:m;

    x(j,1) = (rpre_rbro(j,2));
    y(j,1) = (rpre_rbro(j,3));
    z(j,1) = (rpre_rbro(j,4));
    s(j,1) = (rpre_rbro(j,6));
    t(j,1) = (rpre_rbro(j,5));

    abc(j,1) = rpre_rbro(j,1);

    j = j + 1;

end;


hold on;
plot(abc, x);
hold on;
plot(abc, y);
hold on;
plot(abc, z);
hold on;
plot(abc, s);
hold on;
plot(abc, t);
hold off;
grid on;


set (gca, "xaxislocation", "origin");
set (gca, "yaxislocation", "left");

##legend({'x', 'y', 'z', 't'}, 'Location', 'north');
legend({'x', 'y', 'z', 's', 't'});
title('Precise - Brodcast');

