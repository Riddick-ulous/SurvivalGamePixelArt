# Spielsysteme — Konkretisierung v0.1

Die unveränderte v0.2 bleibt das Zielbild. Dieses Dokument konkretisiert den
technischen Zuschnitt und benennt neue Vorschläge; es ersetzt keine offenen
Designentscheidungen durch versteckte Implementierungsannahmen.

## Produktion

Vier Kategorien: Sammlung aus bestehenden Quellen, Herstellung im Batch,
Instandhaltung bestehender Objekte, längerfristige lebende Prozesse.
Ressourcenquellen besitzen Restmenge, Regeneration, Entnahmerechte und Erreichbarkeit.
Sammlung ist kein kostenloser Crafting-Aufruf. Tiere werden vor Zerlegung als
Weltobjekt bilanziert; Schlachtung und Jagd sind später separate Systeme.

Arbeitsdauer, Wärmebedarf, Materialeignung und Fähigkeit entscheiden über Auswahl.
Aktueller Inhaltsbestand verwendet überwiegend konkrete Items; Tags für Holzarten,
Fasereignung, Lebensmittelbelastung und Werkstoffgüte werden vor ihrer jeweiligen
Mechanik eingeführt. Insbesondere ein beliebiger Ast ist noch keine geeignete Rute.

## Farming als eigenständiges System

`FieldState`: Flächenmaske, Nutzungsrecht, Bodenart, Feuchte, Fruchtbarkeit,
Verdichtung, Beikraut, Bearbeitungsstand. `CropCohort`: Kultur-ID, gesäte Menge,
Fläche, Aussaatzeit, Reifestadium, Vitalität, akkumulierte Wasser-/Temperaturbelastung.
Zunächst eine Kohorte je homogener Teilfläche, keine Entität je Halm.

Saat verbrauchen → Keimung → vegetatives Wachstum → Reife → Ernte/Verlust.
Ertrag ist begrenzt durch vorhandene Kohorte und Fläche. Pflege verändert Bedingungen,
erzeugt aber keine garantierte Ernte. Vernachlässigung, Trockenheit und Frost wirken
über Zeit. Erweiterung: Fruchtfolge, Düngung, Bewässerung, Pflanzenkrankheiten,
Saatgutqualität, mehrjährige Kulturen. Zwei erste Datenentwürfe: Weizen und Flachs.
Die eingetragenen Wachstumszeiten sind noch nicht mit Jahreszeiten balanciert.

## Körper und Autonomie

Pro Person Flüssigkeitsbedarf, Energie, Schlafschuld, Erschöpfung, Temperaturbelastung.
Referenzverbrauch und Dringlichkeitsschwellen werden erst im Survival-Szenario
balanciert. Verhalten: Notfall > akute Versorgung > bindende Verpflichtung >
Vorsorge > persönliche Ziele/Freizeit. Hysterese und Mindestfortschritt vermeiden
ständigen Wechsel. Obergrenzen für Vorräte bewahren freie Zeit.

Direktsteuerung und autonome Figuren teilen Regeln. Nur die aktive eigene Figur
erhält direkte Befehle; fremde Personen entscheiden über Bitte, Vertrag oder
legitimierte Weisung. Kenntnis ist individuell; Ressourcen außerhalb bekannten
Gebiets dürfen nicht automatisch als beste Quelle gewählt werden.

## Beobachtbarkeit

Inspektor zeigt Ziel, konkreten Auftrag, Fortschritt, Reservierung und Blockade.
Beispiel: „Wasser abkochen pausiert: Topf belegt bis 14:20“ statt „KI arbeitet nicht“.
Werkstück und gelagerte Waren sind sichtbar; objektive Ereignisse, Kenntnis und
subjektive Erinnerung bleiben verschiedene Datensätze.

## Balancingstatus und Grenzen des Katalogs

Alle Zahlen sind Startvorschläge, keine historischen Herstellungsanleitungen.
Nebenprodukte, Abwasser, Verunreinigungen, Brennstoffwirkungsgrade und Stoffverluste
sind noch vereinfacht. Der Validator beweist weder Massen-/Energieerhaltung noch
Ernährungsversorgung oder historische Korrektheit. Alkohol-, Leder- und Eisenketten
sind besonders als spätere Vertiefung markiert. Feuer benötigt weiterhin Zündung,
Sauerstoff und Brennstoff; der erste Fixture startet ausdrücklich mit einem Feuer.

## Offene Entscheidungen

| Frage | Startvorschlag / Zeitpunkt |
|---|---|
| Echtzeitdauer eines Tages | in T05 mit beobachtbarem Alltag erproben |
| Saison- und Lebensdauer | getrennt balancieren; keine automatische Generationsbeschleunigung |
| Geschosse und Keller | Datenmodell vorbereitet, Umsetzung nach lokalem Prototyp |
| Vollständige Massenbilanz | zunächst Mengenbuchführung; Stoffmodell vor tiefer Verfahrenstechnik |
| Definition von Gerätekapazitäten | in T03, Voraussetzung für Wasser und Kochen |
| Mindest-Hardware / maximale Bevölkerung | erst nach Headless-Messung festlegen |
| Lizenz und Git-Hosting | noch offen |
