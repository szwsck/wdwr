set TYPY_GEN;
set GODZINY = integer [0,24);

param zapotrzebowanie{GODZINY};
param liczba_gen{TYPY_GEN};
param min_obciazenie{TYPY_GEN};
param max_obciazenie{TYPY_GEN};
param koszt_pracy_przy_min{TYPY_GEN};
param koszt_pracy_powyzej_min{TYPY_GEN};
param koszt_uruchomienia{TYPY_GEN};
param koszt_pracy_w_przeciazeniu;
param prog_przeciazenia;
param max_wzrost_zapotrzebowania;

var liczba_pracujacych_gen{GODZINY, TYPY_GEN} >= 0;
var liczba_przeciazonych_gen{GODZINY, TYPY_GEN} >= 0;
var moc{GODZINY, TYPY_GEN} >= 0;

minimize Koszt: sum {godz in GODZINY, gen in TYPY_GEN} 1;

subject to dostepnosc_gen{godz in GODZINY, gen in TYPY_GEN}:
    liczba_pracujacych_gen[godz, gen] <= liczba_gen[gen];