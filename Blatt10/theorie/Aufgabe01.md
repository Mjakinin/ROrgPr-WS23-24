# Aufgabe 1: Mehrzyklenprozessoren

Mehrzyklenarchiketuren wurden entwickelt, um die Leistung von Einzyklusarchitekturen
zu verbessern. Informieren Sie sich (z.B. in [1, ab Seite 273]) über
Leistungsbegrenzungen von Singlecycle-Architekturen und der Entwicklung von
Multicycle-Implementierungen.

**WICHTIG:** *Mehrzyklenarchiketuren* sind etwas anderes als *Pipelining*.
In dieser Aufgabe geht es **nicht** um Pipelining.
Beide Ansätze dienen der Verbesserung der Timingperformance, unterscheiden sich jedoch in der Umsetzung, in der konkreten Performanceverbesserung und in ihren Vor- und Nachteilen.


Beantworten Sie die folgenden Fragen:

1. (3 Punkte) Timingperformance ist der wichtigste Grund, warum Einzyklus-Prozessoren heut-
zutage höchst selten zu finden sind. Erklären Sie das hauptsächlichen Leistungsproblem einer
Singlecycleimplementierung. Geben Sie ein numerisches Beispiel an, das erlaubt, dieses Pro-
blem abzuschätzen.

Hauptprobleme sind, dass man bis zum Ende des Zykluses warten muss bis man wieder auf ein Register zugreifen kann. Bsp. r1 +r2 = r3, r3- 3 = r4, r4 * 3 = r5 -->wenn diese Berechnung in einem Einzyklus-Przessor durchgeführt wird, dann wird immer eine feste Zeit für jede Berechnung benötigt, auch wenn diese nicht die volle Zeit benötigt. Annahme: CPU bekommt für jeden Befehl 5 ns, dann -> Einzyklus: 15 ns



2. (1 Punkt) Wie verbessert eine Mehrzyklenimplementierung dieses Problemen?

Mehrzyklus: Kann flexibel Zeit ausnutzen, nutzt also nur die Zeit, die es braucht. Annahme: für berechnung wird 1 ns benötigt, hat aber 5 ns zur verfügung --> dann: Ergebnis ist in 3 ns fertig

3. (1 Punkt) Ist Timingperformance die einzige Verbesserung einer Mehrzyklenimplementierung?
Wie verhält es sich mit den benötigten Hardwareressourcen und der Leistungsaufnahme?

-effizienterer Hardwareressourcen verbrauch, da nur das genutzt wird, was gebraucht wird --> dadurch kann mehr getan werden in der selben Zeit und es führt also zu erhöhter Leistung, da mehr mit den Ressourcen getan werden kann
--> also nicht nur Verbessung der Timingperformance, sondern verbessert auch die Leistung, also reduzierung der Leistungsaufnahme


[1] David A. Patterson and John L. Hennessy. Rechnerorganisation und -entwurf. Spektrum Akademischer Verlag, September 2005.
