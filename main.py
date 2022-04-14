""" Kütüphaneler """
from ftplib import FTP

#########################################################
""" Sunucudan veri çek """
#########################################################
""" Verilerin çekileceği site bağlantısı
=> ftp.glonass-iac.ru """
""" Verilerin olduğu dizin =>
ftp.glonass-iac.ru/MCC/ALMANAC/2022/ """

""" Gidilmesi gereken ftp """
ftp = FTP('ftp.glonass-iac.ru')

""" ftp bağlantısı sağla """
ftp.login()

""" Dizinin içerisinde ne var göster """
#ftp.retrlines('LIST')

""" Girmek istediğin dizinin içerisine gir """
#ftp.cwd('ARCHIV_KOC')
""" Gidilmesi gereken ftp dizini =>
ftp.glonass-iac.ru/MCC/ALMANAC/2022/ """
ftp.cwd('MCC')
ftp.cwd('ALMANAC')
ftp.cwd('2022')

""" Çekilecek veri dosyalarını adlandırma standartları:
MCCJ_220101.agl, MCCJ_220101.agp buna göre bütün dosyaları çek """
""" Dosyanın adını gir """
""" Kayıt edilecek dosyayı dosya adıyla kaydet """
""" Kayıt etmek istediğin dosyayı kaydet """
for filename in ftp.nlst()[:3]:
    print(filename)
    localfile = open(filename, 'wb')
    ftp.retrbinary('RETR ' + filename, localfile.write, 1024)

# Sunucu bağlantısını kes
ftp.quit()

# Dosyayı kapat
localfile.close()
#########################################################
""" Sunucudan veri çekme işlemi tamamlandı """
#########################################################
#########################################################
""" Dosyaların içerisinden kullanılacak verileri çek """
#########################################################






#########################################################
""" Dosyaların içerisinden veri çekme tamamladı """
#########################################################
#########################################################
""" Gereken işlemleri yap """
#########################################################






#########################################################
""" Gereken işlemler tamamlandı """
#########################################################
