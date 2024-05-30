
# --- parametry ---
param liczba_scenariuszy;

set TYPY;
set GODZINY = 0..23, circular;
set SCENARIUSZE = 1..liczba_scenariuszy;

param zapotrzebowanie{GODZINY};
param liczba_gen{TYPY}, integer;
param min_obciazenie{TYPY};
param max_obciazenie{TYPY};
param prog_przeciazenia;
param koszt_min_obc{TYPY};
param koszt_dodatkowego_mw{SCENARIUSZE, TYPY};
param koszt_uruchomienia{TYPY};
param koszt_pracy_w_przeciazeniu;
param max_wzrost_zapotrzebowania;
param lambda;

# --- zmienne ---
var pracujace{GODZINY, TYPY} >= 0, integer; # ile generatorow danego typu jest wlaczonych o danej godzinie
var przeciazone{GODZINY, TYPY} >= 0, integer; # ...i ile z nich dziala w zakresie 90-100% obciazenia
var obciazenie{GODZINY, TYPY} >= 0; # laczne obciazenie generatorow danego typu o danej godzinie (rozklad obciazenia miedzy nimi nieistotny)
var uruchomienia{GODZINY, TYPY} >= 0, integer; # ile generatorow danego typu zostalo uruchomionych o danej godzinie
var wylaczenia{GODZINY, TYPY} >= 0, integer;   # ile generatorow danego typu zostalo wylaczonych o danej godzinie

# --- ograniczenia ---

# obciazenie danego generatora nie moze byc mniejsze niz minimalne
subject to min_moc{godz in GODZINY, typ in TYPY}:
    obciazenie[godz, typ] >= pracujace[godz, typ] * min_obciazenie[typ];

# obciazenie danego generatora nie moze byc wieksze niz:
# - 90% maks. obc., jeśli generator nie jest przeciążony
# - maks. obc., jeśli generator jest przeciążony

subject to max_moc{godz in GODZINY, typ in TYPY}:
    obciazenie[godz, typ] <=
        (pracujace[godz, typ] - przeciazone[godz, typ]) * (prog_przeciazenia * max_obciazenie[typ]) # maksymalna moc z generatorów pracujacych w normalnym zakresie
        + przeciazone[godz, typ] * max_obciazenie[typ]  # maksymalna moc z generatorów pracujacych w przeciążeniu
        ;

# w sumie generatory produkują tyle, ile wynosi zapotrzebowanie
subject to zaspokojenie_bazowego_zapotrzebowania{godz in GODZINY}:
    (sum {typ in TYPY} obciazenie[godz, typ]) = zapotrzebowanie[godz];

# aktualnie pracujace generatory powinny byc w stanie pokryc 110% zapotrzebowania
subject to zaspokojenie_wzrostu_zapotrzebowania{godz in GODZINY}:
    (sum {typ in TYPY} pracujace[godz, typ] * max_obciazenie[typ]) >= (1 + max_wzrost_zapotrzebowania) * zapotrzebowanie[godz];

# liczba generatorow kazdego typu jest ograniczona
subject to dostepnosc_gen{godz in GODZINY, typ in TYPY}:
    pracujace[godz, typ] <= liczba_gen[typ];
subject to dostepnosc_przeciazonych_gen{godz in GODZINY, typ in TYPY}:
    przeciazone[godz, typ] <= pracujace[godz, typ];

# liczbe uruchomien wyznaczamy jako dodatnia czesc roznicy w liczbie pracujacych generatorow wzgledem poprzedniej godziny (mod 24)
subject to zmiana_liczby_pracujacych_gen{godz in GODZINY, typ in TYPY}:
    pracujace[godz, typ] = pracujace[prev(godz),typ] + uruchomienia[godz, typ] - wylaczenia[godz, typ];

var koszt{s in SCENARIUSZE} = 
    sum{godz in GODZINY, typ in TYPY} (
        + uruchomienia[godz, typ] * koszt_uruchomienia[typ] # jednorazowe koszty uruchomienia
        + pracujace[godz, typ] * koszt_min_obc[typ] # koszty pracy przy min. obc.
        + (obciazenie[godz, typ] - pracujace[godz, typ] * min_obciazenie[typ]) * koszt_dodatkowego_mw[s, typ] # koszty dodatkowego obc. powyżej min.
        + przeciazone[godz,typ] * koszt_pracy_w_przeciazeniu # dodatkowy koszt pracy ponad 90% obc.
);

var sredni_koszt = sum {s in SCENARIUSZE} koszt[s] / liczba_scenariuszy;

var odchylenie{s in SCENARIUSZE} = sredni_koszt - koszt[s];
var odchylenie_dodatnie{SCENARIUSZE} >= 0;
var odchylenie_ujemne{SCENARIUSZE} >= 0;
s.t. suma_odchylen{s in SCENARIUSZE}: odchylenie_dodatnie[s] - odchylenie_ujemne[s] = odchylenie[s];
var odchylenie_abs{s in SCENARIUSZE} = odchylenie_dodatnie[s] + odchylenie_ujemne[s];

var ryzyko = sum {s in SCENARIUSZE} odchylenie_abs[s] / liczba_scenariuszy;  

var S;
s.t. s1: S >= lambda * ryzyko;
s.t. s2: S >= sredni_koszt;
minimize goal: S + 0.000001 * (ryzyko + sredni_koszt);