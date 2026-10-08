# Vertrag für Rezepte, Arbeitsabläufe und laufende Aufträge

## Drei unterschiedliche Ebenen

| Ebene | Datei / Objekt | Beispiel |
|---|---|---|
| Herstellungsverfahren | `content/core/recipes/food/boil_water.json` | 2 l Rohwasser + Brennstoff → 1,8 l aufbereitetes Wasser |
| Zielbezogener Ablauf | `content/core/workflows/safe_water.json` | Bedarf feststellen, Material besorgen, kochen, lagern |
| Konkrete Ausführung | später `CraftJob` im Save | Mara bearbeitet Batch 471 mit Topf 82 an Feuerstelle 9 |

Ein JSON-Rezept ist keine autonome KI und kein laufender Auftrag. Ein Workflow
ist eine geordnete fachliche Vorlage mit typisierten Operationen. Jeder
Operation-ID entspricht später expliziter C#-Code. Beliebiger Code aus Daten wird
nicht ausgeführt. Kontextparameter und Auswahlentscheidungen liefert der Planer.

## Rezeptfelder

`schema_version`, stabile `id`, Anzeigename, Kategorie, Entwicklungsstufe,
`knowledge_id`, `station_id`, `inputs`, Werkzeugfähigkeiten, `outputs`, `phases`.
Alle Mengen gelten **pro Batch**. Einheiten stehen ausschließlich in der Itemdefinition.
Definitionen besitzen `implementation_status: defined`; Laufzeitunterstützung
wird im STATUS und durch Tests dokumentiert, nicht durch Laden der JSON behauptet.

Aktive Phase: angegebene Spielminuten sind Arbeit einer Person bei Referenzfähigkeit.
Passive Phase: Kalenderzeit bei erfüllten Bedingungen. Mehr Personen halbieren
Arbeit nicht automatisch; Kooperationsfähigkeit ist später ausdrücklich zu definieren.
Phasen dürfen `active → passive → active` wechseln. Beispiele wie Malzwenden,
Ofennachlegen und Gerbbadwechsel werden später als zusätzliche betreute Phasen
oder fällige Kontrolljobs ergänzt; aktuelle lange Passivphasen vereinfachen diese.

Werkzeuganforderungen sind Fähigkeiten (`cutting`, `cooking_vessel`) statt fester
Itemnamen. Der Planer wählt eine zugängliche Instanz mit passendem Zustand.
Verschleiß ist pro Batch und linear zum aktiven Fortschritt anzuwenden, nicht pro
Renderframe. Ein Gegenstand mit mehreren Fähigkeiten kann mehrere Anforderungen
decken, sofern die Tätigkeiten nicht gleichzeitig unterschiedliche Instanzen brauchen.

## Zustandsautomat des Laufzeitauftrags

`planned → reserved → running ↔ paused → completed`.
Zusätzlich `blocked` vor Beginn, `failed` nach irreversibler Beschädigung und
`cancelled` auf gültigen Abbruch. Jeder Übergang trägt Grund, Zeitpunkt und Akteur.

1. **Planen:** Wissen, Materialeignung, Eigentum/Nutzungsrecht, Ort und erreichbare
   Kapazität prüfen. Keine Reservierung der gesamten hypothetischen Produktionskette.
2. **Reservieren:** nächster ausführbarer Batch reserviert atomar Material,
   konkrete Werkzeuge, Arbeitsplatz und Ergebnisablage. Konflikt = kein Teilabschluss.
3. **Start:** Eingaben gehen atomar aus frei verfügbarem Bestand in ein persistentes
   Werkstück über. Das ist Verwahrung, noch keine pauschale Vernichtung aller Rohstoffe.
   Material wird beim ersten irreversiblen Arbeitsschritt verarbeitet; Brennstoff
   wird getrennt als Budget geführt und nur beim tatsächlichen Verbrennen verbraucht.
4. **Fortschritt:** aktiver Fortschritt braucht anwesenden arbeitsfähigen Akteur.
   Passive Vorgänge laufen ohne Akteur, halten aber den Prozessplatz und benötigte
   Gefäße belegt. Im ersten Modell bleiben alle angeforderten Werkzeuge über den
   gesamten Batch gebunden; spätere phasenbezogene Freigabe ist Optimierung.
5. **Abschluss:** Ergebnisse genau einmal anlegen, Prozess als abgeschlossen markieren
   und Reservierungen freigeben — eine Transaktion mit idempotenter Job-ID.
6. **Abbruch:** vor irreversibler Verarbeitung Rohstoffe zurückgeben; danach Werkstück
   erhalten oder als verdorben markieren. Keine pauschale Rückerstattung fertiger
   Rohstoffe. Nicht verbranntes Brennstoffbudget bleibt erhalten.

Eigentümer des Werkstücks bleibt der Materialeigentümer. Der einfache erste Batch
verwendet Material genau eines Auftraggebers; gemischtes Eigentum braucht später
einen gesonderten Vertrag. Eine beauftragte Person wird nicht automatisch Eigentümer.

## Bedingungen und Blockaden

Umweltprofile werden am Prozessort gemessen, Temperatur gegebenenfalls im Gefäß
oder Ofen, nicht immer in der Umgebungsluft. Vorhandener Brennstoff allein erfüllt
keine Temperaturbedingung. Eine Feuer-/Ofenmechanik liefert Wärme unter Verbrauch
des reservierten Budgets; keine zweite Abbuchung durch das Rezept.

`block` vor aktiver Arbeit: keine Fortschreibung, Grund anzeigen.
`pause` bei passiver Phase: Fortschritt stoppt; blockierte Gesamtzeit akkumuliert.
Nach `max_blocked_game_minutes` wird das Werkstück verdorben. Diese einfache Regel
ersetzt zunächst produktspezifische Verderbsmodelle, nicht deren langfristiges Ziel.
`env.any` bedeutet keine zusätzliche Umweltbedingung, nicht fehlende Rechteprüfung.

Ressourcenänderung, neuer Weg, neues Recht oder neue Zuordnung lösen Replanung aus.
Zeitablauf allein darf keinen schnellen Endlosversuch auslösen. Reservationen haben
Leases vor Arbeitsbeginn; laufende Werkstücke verlieren ihren Prozessplatz nicht
durch bloßes Timeout. Kritische Gefahr darf aktive Arbeit unterbrechen.

## Geplante Produktionsplanung

Rückwärtssuche von Ziel zu bekannten Rezepten mit begrenzter Tiefe und Kostenbudget.
Besuchte Kombination aus Zielitem und Verfahren tracken. Die Hautkette enthält
bewusst einen Konservierungszyklus; ein Zyklus ist kein unbegrenzter Rohstoffgewinn.
Beschaffung als eigener Auftrag berücksichtigt Rechte und tatsächliche Quellen.
Werkzeug- und Infrastruktur-Bootstrap muss explizit sein: Schmiedewerkzeuge,
Spindel, Mühle und Öfen kommen zunächst aus Szenario/Handel, nicht aus dem Nichts.

## Erweiterungsgrenzen

Rezeptdaten v1 beschreiben diskrete Batches. Kontinuierliche Mühlen, Tiere und
Pflanzen sind zustandsbehaftete Systeme. Ein Ernteauftrag entnimmt tatsächlich
gewachsene Pflanzen und ist kein Rezept `Saat → Getreide` mit festem Zeitbonus.
Reparatur verändert eine vorhandene Werkzeuginstanz; ihr Materialverbrauch und
Zustandsgewinn benötigen einen eigenen Reparaturvertrag. Noch nicht implementiert.
