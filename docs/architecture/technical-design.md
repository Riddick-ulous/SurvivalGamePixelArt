# Technischer Entwurf

## Entscheidungen und Umfang

Godot 4 .NET + C#, Desktop Windows/Linux, Einzelspieler. Exakte Engine- und
SDK-Version werden in T01 gemeinsam gewählt und fixiert; dieser Stand behauptet
keine bereits getestete Toolchain. Pixelgrafik mit 2D-Renderer, räumliche Höhe als
Simulationsinformation. Kein C++/Rust-Interop und keine eigene Engine im ersten Stand.

## Geplante Dateistruktur und Zuständigkeit

| Pfad | Geplante Dateien / Aufgaben |
|---|---|
| `game/` | `project.godot`, `Scenes/World.tscn`, `Scenes/PersonInspector.tscn`, `Scripts/SimulationBridge.cs`, `Scripts/WorldPresenter.cs`; Darstellung, Eingabe, Audio |
| `src/Simulation.Core/World/` | `WorldState.cs`, `EntityId.cs`, `WorldCommand.cs`, `WorldEvent.cs`; verbindlicher Zustand |
| `src/Simulation.Core/Time/` | `SimulationClock.cs`, `SimulationScheduler.cs`, `ScheduledEvent.cs`; Spielzeit und Fälligkeiten |
| `src/Simulation.Core/Spatial/` | `GridPosition.cs`, `ChunkState.cs`, `PathRequest.cs`, `GridPathfinder.cs`; Belegung und Wege |
| `src/Simulation.Core/Inventory/` | `ItemBatch.cs`, `InventoryState.cs`, `Reservation.cs`, `TransferService.cs`; Mengen, Eigentum, Transaktionen |
| `src/Simulation.Core/Production/` | `RecipeDefinition.cs`, `CraftJob.cs`, `Workpiece.cs`, `ProcessSystem.cs`; Herstellung |
| `src/Simulation.Core/Agents/` | `NeedsState.cs`, `KnowledgeState.cs`, `GoalSelector.cs`, `TaskPlanner.cs`, `TaskExecutor.cs`; Autonomie |
| `src/Simulation.Core/Environment/` | `WeatherState.cs`, `CellEnvironment.cs`, `FireState.cs`; Umwelt und Wärme |
| `src/Simulation.Core/Social/` | `RelationshipState.cs`, `Agreement.cs`, `MemoryEvent.cs`; Beziehungen und Verpflichtungen |
| `src/Simulation.Core/Farming/` | später `FieldState.cs`, `CropCohort.cs`, `GrowthSystem.cs`; flächenbezogener Anbau |
| `src/Content/` | `ContentLoader.cs`, `ContentRegistry.cs`, `ContentValidator.cs`; Definitionen, IDs, Ladefehler |
| `src/Persistence/` | `SaveEnvelope.cs`, `SaveWriter.cs`, `SaveReader.cs`, `Migrations/`; Save-DTOs und Migration |
| `src/Headless/` | `Program.cs`, `ScenarioRunner.cs`, `MetricsWriter.cs`; Tests ohne Godot |
| `src/Dialogue/` | später `IDialogueProvider.cs`, `ConversationContext.cs`, `ProposalValidator.cs`; optionales LLM |
| `tests/Simulation.Tests/` | spätere C#-Tests, keine Engine erforderlich |
| `tests/content/` | bereits ausführbare Tests des Inhaltsprüfers |
| `content/core/` | versionierte Spieldefinitionen, keine laufenden Spielstände |
| `schemas/` | maschinenlesbare Verträge der bereits vorhandenen JSON-Dateien |
| `tools/` | ausführbarer Inhaltsprüfer, kein Gameplay |

Die hier genannten C#-Dateien sind **geplant und noch nicht angelegt**.

## Abhängigkeitsrichtung

`Godot presentation → Simulation.Core`; `Headless → Simulation.Core`.
`Content → Simulation.Core` zum Aufbau unveränderlicher Definitionen.
`Persistence → Simulation.Core` für explizite Save-DTOs.
Der Kompositionspunkt in Godot/Headless verbindet die Module. Core referenziert
weder Godot noch HTTP, Dateisystem, JSON-Parser oder den LLM-Anbieter.
Content-ID-Auflösung erfolgt vor Start einer Simulation, nicht in jeder Tickschleife.

Ein `WorldCommand` enthält Akteur, Ziel, Parameter und erwartete Zustandsrevision.
Die Simulation validiert Rechte und Zustand beim Anwenden. UI-Aktionen und
KI-Aufträge verwenden dieselben fachlichen Dienste. Ereignisse sind Ergebnisse
erfolgreicher Zustandsänderungen; sie ersetzen keine Transaktionen.

## Datenbesitz und Tickreihenfolge

Zunächst schreibt genau ein Simulationsthread. Reihenfolge je Schritt:
fällige Umweltänderungen → validierte Befehle → Prozessfortschritt und Transfers
→ Bedürfnisse/Entscheidungen → Ereignisse und Lesesnapshot.
Bei gleicher Fälligkeit stabile Priorität plus Sequenznummer verwenden.
Rendering darf Weltzustand nicht verändern. Spätere Worker liefern Ergebnisse mit
Revision zurück; veraltete Weg- oder Planergebnisse werden verworfen.

Keine Update-Methode je Inventargegenstand oder je erinnerter Person nötig.
Rendering erzeugt nur Darstellungsobjekte für relevante sichtbare Entitäten.
Sozialbeziehungen sind dünn besetzte gerichtete Kanten, keine N×N-Matrix.
Erinnerungen haben Retentions- und Verdichtungsregeln; Ereignislogs wachsen nicht
unbegrenzt mit jedem Tick.

## Zeitmodell

Zeitpunkte als 64-Bit-Spielmillisekunden; Inhaltsdauern werden aus Spielminuten
einmalig konvertiert. Spieltag zunächst 1.440 Spielminuten. Verhältnis zur Echtzeit
ist ein Szenarioparameter, kein Bestandteil der Rezepte. Saisonlänge und Alterung
sind offene Balancingentscheidungen.
Tickauflösung ist konfigurierbar; Physik-/Renderdelta steuert keine Produktion.
Bedürfnisse integrieren verstrichene Spielzeit. Entscheiden nur bei Fälligkeit
oder relevanter Änderung. Passive Vorgänge nutzen Scheduler und Umweltprüfungen.
Zeitbeschleunigung verarbeitet alle relevanten Ereignisgrenzen. Ein Schritt
darf weder Frist noch Prozessende oder Schadensschwelle unbemerkt überspringen.

## Raum

`GridPosition(x,y,level)` und optionaler Feinoffset; Bildschirmkoordinaten separat.
Ein logisches Rasterfeld zunächst 1 m × 1 m, Darstellung nominell 16 Pixel.
Chunkkantenlänge als Konfiguration (Startvorschlag 32 Felder). Keine hart
eingebaute maximale Regionengröße. Türen, Rampen und Treppen später explizite
Verbindungen zwischen begehbaren Flächen; Höhe ist nicht nur Sprite-Versatz.
Erster Pathfinder: A* auf Raster, begrenzte Suchbudgets, Wiederverwendung von Wegen,
Invalidierung bei relevanter Belegungsänderung. Globale Wegsuche je Person und Tick
ist ausgeschlossen. Regionale Reiseplanung folgt als eigene Ebene.

## Mengen und Gegenstände

Definition (`item.pot`) versus Instanz/Charge (`EntityId`) strikt unterscheiden.
Ein Itemtyp hat genau eine Mengeneinheit. Laufzeitmengen als skalierte Integer
mit 0,001 Basiseinheiten; `piece` nur ganzzahlig. Kein implizites kg↔l.
Charge: Menge, Eigentümer-ID, Verwahrer/Ort, Qualität, Feuchte, Zustand, Herkunft.
Vermischen nur bei kompatiblen Eigenschaften; Aufteilen erhält Herkunft und Besitz.
Werkzeuge sind einzelne Instanzen. Flüssigkeitsmenge und Gefäß bleiben getrennt;
Gefäßkapazität wird in T03 ergänzt, bevor Wassertransporte als spielbar gelten.

## Entfernte Welt

Zunächst nur lokal. Später unterschiedliche Detailstufen auf demselben
Bestandsmodell: keine zweite Parallelökonomie. Pro Ort `last_simulated_at` und
Fortschrittsgrenze; Detailwechsel stoppt eine Darstellung und übernimmt den
bereits bilanzierten Zustand. Verträge/Reisen bleiben individuelle Schedulerjobs.
Begrenzte Arbeitskapazität, Zugangsrechte und Prozessplätze gelten auch entfernt.

## Persistenz

SaveEnvelope: save_schema_version, content_pack_versions, world_seed,
random_stream_states, clock, entities, reservations, jobs, scheduler, knowledge,
relationships, last_simulated_at. Inhalts-IDs und Instanz-IDs getrennt speichern.
Atomarer Austausch über temporäre Datei, Backup des letzten gültigen Saves.
Fehlende Definitionen oder unbekannte neue Saveversion: verständlich abbrechen.
Pro Version explizite Migrationen. Anfangs komprimiertes JSON für Debugbarkeit;
binäres Format erst bei belegtem Bedarf. Gleiches Build + Seed + Eingaben ist
Reproduktionsziel; bitidentische Plattformdeterministik wird nicht behauptet.

## Performance

Messgrößen: ms je Simulationssystem, Planeraufrufe, Wegsuchen, offene Jobs,
Allokationen, Speicher, erreichte Spielzeit je Echtzeit. Teststufen 2/20/100 aktive
und später 1.000 persistente Personen. Keine Kapazitätszusage vor Messung.
Indizes nach Ort, Itemtyp, Eigentümer und Reservierbarkeit zuerst; danach gezielte
Optimierung. Multithreading wird erst mit klaren Datenbesitzregeln eingeführt.
