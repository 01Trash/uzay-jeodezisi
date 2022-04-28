clc, clear
pkg load io

% Pazar günü = 0
gun = 0;

%%% Yerçekimi sabiti m^3/s^2
GM = 3.986005E+14;
%%% Yerin açısal dönme hızı rad/s
We = 7292115.1467E-11;


%%% Verileri çek
filename = 'broadcast.ods';
data_source = xlsread(filename);


[m,n] = size(data_source);
for i = 1:m;
    k = 1:n;

    % t => W_second_
    W_second_ = gun*86400 + data_source(i, 5)*3600 + data_source(i, 6)*60 + data_source(i, 7);
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
    Xk = rk * (cos(lk) * cos(uk) - sin(lk) * sin(uk) * cos(ik));
    %fprintf("Xk: %4.7f km ", Xk);
    Yk = rk * (sin(lk)*cos(uk) + cos(lk)*sin(uk)*cos(ik));
    %fprintf("Yk: %4.7f km ", Yk);
    Zk = rk * sin(uk)*sin(ik);
    %fprintf("Zk: %4.7f km ", Zk);
    %rk = rk;
    %fprintf("rk: %4.7f km ", rk);

    M(i,1) = Xk;
    M(i,2) = Yk;
    M(i,3) = Zk;

    fprintf("%2.d: Xk: %8.7f || Yk: %8.7f || Zk: %8.7f\n", i, M(i,1), M(i,2), M(i,3));

    i = i + 1;
    k = k + 1;

end;

%fprintf("Crs: %8.4f", Crs(i,1));



