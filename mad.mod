param liczba_scenariuszy;
set SCENARIUSZE = 1 .. liczba_scenariuszy;
param srednia = 803649.6015;
param lambda = 0.9;
param realizacje{SCENARIUSZE};
var odchylenie_dodatnie{SCENARIUSZE} >= 0;
var odchylenie_ujemne{SCENARIUSZE} >= 0;

maximize mad:
    srednia - lambda * sum{s in SCENARIUSZE} (odchylenie_dodatnie[s] + odchylenie_ujemne[s]) / liczba_scenariuszy;

subject to abs{s in SCENARIUSZE}:
    odchylenie_dodatnie[s] - odchylenie_ujemne[s] = srednia - realizacje[s];