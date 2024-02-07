# VHDL-Attribute (2 Punkte)

Mithilfe von Attributen kann in VHDL auf bestimmte Eigenschaften von Signalen zugegriffen werden.
Informieren Sie sich zum Beispiel in [1] oder [5] über Attribute in VHDL und beantworten Sie die folgenden Fragen:

1. Wie greifen Sie auf das Attribut eines Signals zu? Geben Sie die Syntax anhand eines Beispiels an.
2. Nennen Sie drei der im Standard vordefinierten Attribute und erklären Sie kurz, was sie repräsentieren.
3. Über welche Attribute erhält man den Gültigkeitsbereich des Index für Signale des Typs std_logic_vector?
4. Wie kann man in VHDL mithilfe von Attributen eine positive bzw. negative Flanke eines Signals detektieren? Geben Sie die entsprechenden VHDL-Anweisungen an.






1. 
Um auf das Attribut eines Signals in VHDL zuzugreifen, wird die Syntax attribute_name'attribute_designator verwendet. Hier ist ein Beispiel, um auf das Attribut 'event eines Signals zuzugreifen:

signal my_signal : std_logic;
-- Zugriff auf das 'event'-Attribut des Signals
if my_signal'event then
    -- Hier wird Code ausgeführt, wenn das Signal 'my_signal' ein Ereignis hat
end if;

In diesem Beispiel wird die 'event-Eigenschaft des Signals my_signal überprüft, um festzustellen, ob es ein Ereignis für dieses Signal gab.


2. 
'event: Überprüft, ob ein Signal seit der letzten Ausführung des Codes ein Ereignis hatte, also ob sich sein Wert geändert hat.

'active: Ermittelt, ob ein Signal in einem Prozess während des letzten Durchlaufs aktiv war, das heißt, ob es ein Ereignis hatte.

'stable: Prüft, ob ein Signal stabil ist, das bedeutet, ob sein Wert seit der letzten Ausführung des Codes unverändert geblieben ist.


3. 
range


4. 
Um eine positive oder negative Flanke eines Signals in VHDL zu detektieren, werden die vordefinierten Attribute 'event und 'last_value genutzt.

Positive Flanke (steigende Flanke) detektieren:
if rising_edge(my_signal) then
    -- Hier wird Code ausgeführt, wenn eine steigende Flanke detektiert wird
end if;

Gleiches Spiel bei falling_edge(my_signal)

Diese Konstrukte rising_edge und falling_edge sind in VHDL vordefinierte Funktionen, die auf das 'event-Attribut des Signals basieren und die positive bzw. negative Flanke erkennen.
