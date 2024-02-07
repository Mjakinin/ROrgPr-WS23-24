## Aufgabe 1: Automaten (5 Punkte)
Informieren Sie sich (z.B. in [1, ab Seite 273]) über endliche Zustandsautomaten.
Erarbeiten Sie insbesondere den Unterschied zwischen Moore- und Mealy-Automaten (z.B. [1, ab Seite 279]).
Beantworten Sie anschließend die folgenden Fragen:

1. (1 Punkt)
Was ist ein endlicher Zustandsautomat?

Ein endlicher Automat stellt ein Verhaltensmodell dar und setzt sich aus Zuständen, Zustandsübergängen und Aktionen zusammen. Die Bezeichnung "endlich" bezieht sich darauf, dass die Anzahl der möglichen Zustände, die der Automat einnehmen kann, begrenzt ist.

2. (2 Punkte)
Wie unterscheiden sich Moore- und Mealy-Automaten voneinander? Nennen Sie für beide Varianten jeweils einen Vorteil!

Moore-Automat: Bei einem Moore-Automaten hängt die Ausgabe ausschließlich vom aktuellen Zustand ab. Jeder Zustand ist mit einer festen Ausgabe verknüpft.
Vorteil: Die Vorteile eines Moore-Automaten liegen in der klaren Trennung von Zustandsinformation und Ausgabe, was zu einer einfacheren Analyse und Implementierung führen kann.

Mealy-Automat: Im Gegensatz dazu hängt die Ausgabe eines Mealy-Automaten sowohl vom aktuellen Zustand als auch von der Eingabe ab. Jeder Übergang ist mit einer Ausgabe assoziiert.
Vorteil: Mealy-Automaten können in bestimmten Fällen effizienter sein, da sie Ausgaben direkt mit den Zustandsübergängen kombinieren und somit weniger Zustände benötigen können.

3. (2 Punkte)
In VHDL lassen sich Automaten über ein bis mehrere Prozesse realisieren.
Wonach wird bei einer Mehrprozessimplementierung die Logik aufgeteilt und was sind die Vorteile davon?
In bis zu wie viele Prozesse ist eine Aufteilung bei einer Mehrprozessimplementierung sinnvoll?

- es kommt auf die genutzte Logik an -> zb synchron oder asynchron
- Prozess Anzahl variiert von Logik zu Logik, man müsste aber mehr als einen verwenden (zB. bei synchronen: 1 Prozess für clk (bsp rising edge) und mind. 1 Prozess für die Mealy/Moore Logik)
Vorteile: parallele Ausführung, Änderung des Zustands (und Eingang bei Mealy) -> Änderung im Ausgang
