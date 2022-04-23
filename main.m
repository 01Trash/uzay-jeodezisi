clc, clear

""" YUMA Yörünge Formatı """
# Uydu numarası
ID = 1
# 0: Çalışıyor
Healt = 0
# Eccentricity | e []
Eccentricity = 0.2850055695E-002
# Time of Applicability (s) | t0 [s] (Yörünge ve saat referans anı)
Time_of_Applicability = 233472.0000
# Orbital Inclination (rad) | i0 [rad]
Orbital_Inclination = 0.9608256444
# Rate of Right Ascen (r/s) | Δl [rad/s]
Rate_of_Right_Ascen = -0.8034620388E-008
# SQRT (A) (m 1/2) | a^0.5 [m^0.5]
SQRT = 5153.623047
# Right Ascen at Week (rad) | l0 [rad]
Right_Ascen_at_Week = -0.6929155253E+000
# Argument of Perigee (rad) | w0 [rad]
Argument_of_Perigee = 0.326578368
# Mean Anom (rad) | M0 [rad]
Mean_Anom = 0.1616346493E+001
# Af0 (s) | a0 [s]
Af0 = 0.6675720215E-005
# Af1 (s/s) | a1 []
Af1 = 0.0000000000E+000
# week | Değiştirilmiş GPS Haftası
week = 762

# Yerçekimi sabiti m^3/s^2
GM = 3.986005E+14
# Yerin açısal dönme hızı rad/s
We = 7292115.1467E-11
# t [s]
t = 208800.0

tk = t - Time_of_Applicability
#print(tk)

# M' = n = (GM/a^3)^1/2
SQRT_2 = SQRT ** 2
#print(SQRT_2)
n = (GM / SQRT_2 ** 3) ** 0.5
#print(n)

# Mk = M0 + n * tk
Mk = Mean_Anom + n * tk
#print(Mk)
Mk_grad = Mk * 200 / math.pi
#print(Mk_grad)
#Mk = Mk + 2*math.pi
#print(Mk)

""" İterasyon """
# Ek = Mk + log(e) * sin(Ek)
e = math.exp(1)
#print(e)
Ek = Mk
Ek_i = 2
Ek_s = 1
i = 0
while (Ek_i - Ek_s >= 0.000000001):
    %print(i, ": ", Ek_i - Ek_s)
    Ek_i = Ek
    Ek_s = Mk + e * math.sin(Ek)
    Ek = Ek_s
    i = i + 1
end;

print("Fark", Ek_i - Ek_s)
print("Döngü çıkış: ", Ek)
Ek_grad = Ek * 200 / math.pi
print(Ek_grad)







