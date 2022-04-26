clc, clear
pkg load io

gun = 0;

%%% Yerçekimi sabiti m^3/s^2
GM = 3.986005E+14;
%%% Yerin açısal dönme hızı rad/s
We = 7292115.1467E-11;



%%% Verileri çek
filename = 'broadcast.ods';
data_source = xlsread(filename);

_W_second = 1;
_a0 = 1;
_a1 = 1;
_a2 = 1;
_Crs = 2;
_Delta_n = 2;
_M0 = 2;
_Cuc = 3;
_e = 3;
_Cus = 3;
_sqrt_a = 3;
_t0 = 4;
_Cic = 4;
_l0 = 4;
_Cis = 4;
_i0 = 5;
_Crc = 5;
_W0 = 5;
_Delta_l = 5;
_Delta_i = 6;
_W_GPS = 6;
_tc = 8;



[m,n] = size(data_source);
for i = 1:m;
    k = 1:n;

    % t => W_second_
    W_second(i,1) = gun*86400 + data_source(_W_second, 5)*3600 + data_source(_W_second, 6)*60 + data_source(_W_second, 7);
    W_second_ = W_second(i,1);

    a0(i,1) = data_source(_a0, 2);
    a0_ = a0(i,1);
    a1(i,1) = data_source(_a1,3);
    a1_ = a1(i,1);
    a2(i,1) = data_source(_a2,4);
    a2_ = a2(i,1);

    Crs(i,1) = data_source(_Crs, 2);
    Crs_ = Crs(i,1);
    Delta_n(i,1) = data_source(_Delta_n, 3);
    Delta_n_ = Delta_n(i,1);
    M0(i,1) = data_source(_M0, 4);
    M0_ = M0(i,1);
    Cuc(i,1) = data_source(_Cuc, 1);
    Cuc_ = Cuc(i,1);
    e(i,1) = data_source(_e, 2);
    e_ = e(i,1);
    Cus(i,1) = data_source(_Cus, 3);
    Cus_ = Cus(i,1);
    sqrt_a(i,1) = data_source(_sqrt_a, 4);
    sqrt_a_ = sqrt_a(i,1);
    t0(i,1) = data_source(_t0, 1);
    t0_ = t0(i,1);
    Cic(i,1) = data_source(_Cic, 2);
    Cic_ = Cic(i,1);
    l0(i,1) = data_source(_l0, 3);
    l0_ = l0(i,1);
    Cis(i,1) = data_source(_Cis, 4);
    Cis_ = Cis(i,1);
    i0(i,1) = data_source(_i0, 1);
    i0_ = i0(i,1);
    Crc(i,1) = data_source(_Crc, 2);
    Crc_ = Crc(i,1);
    W0(i,1) = data_source(_W0, 3);
    W0_ = W0(i,1);
    Delta_l(i,1) = data_source(_Delta_l, 4);
    Delta_l_ = Delta_l(i,1);
    Delta_i(i,1) = data_source(_Delta_i, 1);
    Delta_i_ = Delta_i(i,1);
    W_GPS(i,1) = data_source(_W_GPS, 3);
    W_GPS_ = W_GPS(i,1);

    % SORULACAK!!!
    W_sifir = W_GPS_;

    tc(i,1) = data_source(_tc, 1);
    tc_ = tc(i,1);


    tk = (W_GPS_ - W_sifir) * 608400 + W_second_ - t0;

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

    pay = sqrt(1-e_*e_) * sin(Ek);
    payda = cos(Ek) - e_;

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
    %fprintf("fk_grad: %8.17f", fk_grad);

    uk = W0_ + fk + Cuc_ * cos(2*(W0_ + fk)) + Cus_*sin(2*(W0_+fk));
    %uk_ = uk(i,1);

    rk = sqrt_a_*sqrt_a_*(1-e_*cos(Ek)) + Crc_*cos(2*(W0_ + fk)) + Crs_*sin(2*(W0_ + fk));
    %rk_ = rk(i,1);

    ik = i0_ + Delta_i_ * tk + Cic_ * cos(2*(W0_ + fk)) + Cis_*sin(2*(W0_ + fk));
    %ik_ = ik(i,1);

    lk = l0_ + (Delta_l_ - We)*tk - We * t0_;
    %lk_ = lk(i,1);


%rk * (cos(lk)*cos(uk) - sin(lk)*sin(uk)*cos(ik))
    Xk = rk * (cos(lk) * cos(uk) - sin(lk) * sin(uk) * cos(ik));
    %fprintf("Xk: %4.7f km ", Xk);
    Yk = rk * (sin(lk)*cos(uk) + cos(lk)*sin(uk)*cos(ik));
    %fprintf("Yk: %4.7f km ", Yk);
    Zk = rk * sin(uk)* sin(ik);
    %fprintf("Zk: %4.7f km ", Zk);
    rk = rk;
    %fprintf("rk: %4.7f km ", rk);

    %M(i,2) = Xk;
    %M(i,3) = Yk;
    %M(i,4) = Zk;





    _W_second = _W_second + 9;
    _a0 = _a0 + 9;
    _a1 = _a1 + 9;
    _a2= _a2 + 9;
    _Crs = _Crs + 9;
    _Delta_n = _Delta_n + 9;
    _M0 = _M0 + 9;
    _Cuc = _Cuc + 9;
    _e = _e + 9;
    _Cus = _Cus + 9;
    _sqrt_a = _sqrt_a + 9;
    _t0 = _t0 + 9;
    _Cic = _Cic + 9;
    _l0 = _l0 + 9;
    _Cis = _Cis + 9;
    _i0 = _i0 + 9;
    _Crc = _Crc + 9;
    _W0 = _W0 + 9;
    _Delta_l = _Delta_l + 9;
    _Delta_i = _Delta_i + 9;
    _W_GPS = _W_GPS + 9;
    _tc = _tc + 9;

    i = i + 1;
    k = k + 1;
end;

%fprintf("Crs: %8.4f", Crs(i,1));



