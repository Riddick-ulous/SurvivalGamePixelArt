# Asset-Generation-Workflow v0.1 – Lebendige Welt

**Stand:** 2026-10-09  
**Status:** Produktionsvorschlag für die Waldcamp-Assetphase; technische Parameter durch reale Assets nachzuweisen.  
**Grundlagen:** [Grafikkonzept v0.3](graphics-concept-v0.3.md), [Waldcamp-Assetliste v0.1](forest-camp-asset-list-v0.1.md), [Spielkonzept](../game-concept-v02.md).  
**Ziel:** Aus einer freigegebenen Gesamtbild-Referenz ein konsistentes, wiederverwendbares Set kleiner Pixelgrafiken erzeugen und zunächst **ohne Spiel-/Simulationslogik** zusammensetzen.

## 1. Verbindliche Abgrenzung

1. **Referenzbild ≠ Spielasset.** Die freigegebene Waldcamp-Konzepttafel und die separate Szene sind Zielbilder für Bildsprache, Atmosphäre, Perspektive, Proportionen und Komposition; die Bildausschnitte sind keine nachgewiesenen 32×32-Tiles.
2. **Neuer visueller Maßstab:** 1 × 1 m Weltfläche entspricht nominal 32 × 32 Pixeln. Dies ersetzt für die Grafikproduktion die in älteren Techniktexten noch genannten 16 px/m, ohne das logische 1-m-Raster zu ändern.
3. **RPG-artige schräge Draufsicht, keine Rauten-Isometrie.** Eine frontal zugewandte Figur ist vollständig von Kopf bis Fuß sichtbar. Boden und Figuren benötigen dieselbe perspektivische Konvention.
4. **Stil:** Natürliches, atmosphärisches Pixel-Art-Terrain mit klaren Silhouetten und ruhigen Bodenflächen; kein weichgezeichnetes Gemälde. Die Simulation muss später ablesbar bleiben.
5. **Erst Assets, dann statische Szene.** Weder Gameplay, AI, Kollisionssystem, Inventar, Simulation noch ein fertiges Godot-Projekt sind in diesem Grafikmeilenstein erforderlich.
6. **Nicht voreilig animieren.** Die Bewegungsfamilien werden als später wiederverwendbare Bausteine geplant; das erste Waldcamp wird mit statischen Figuren beziehungsweise ausgewählten Posen aufgebaut.

## 2. Stilreferenz und Versionierung

Für neue Produktionen gilt eine **einzige führende, versionierte Referenz**: die vom Nutzer freigegebene Waldcamp-Konzepttafel samt separater Waldansicht (Grafikprototyp 02).

**Referenzmigration noch auszuführen:** Die beiden Bilder müssen in einem eigenen Schritt als unveränderte Binärdateien unter `game/assets/style_reference/current/` gespeichert werden; erst anschließend werden frühere Einzelbildstudien als nicht mehr gültige Stilvorlagen aus dem aktuellen Referenzbereich entfernt oder historisch archiviert. Die vorhandenen PNGs von Prototyp 01 sind **nicht** die maßgebliche Designvorgabe. Diese Dokumentation behauptet nicht, dass die Migration bereits erfolgt ist.

Jeder Erzeugungsauftrag nennt die Referenzversion und eine feste Bildauswahl. Nachträgliche Stiländerungen werden als neue Referenzversion dokumentiert, statt frühere Dateien stillschweigend zu überschreiben. Die Konzepttafel gibt die **Optik** vor, nicht automatisch sämtliche gezeigten Inhalte: Boot, aufwendige Stege und dichte Lagereinrichtung sind keine Pflicht für das primitive Waldcamp-MVP.

## 3. Daten- und Ablagestruktur (geplant, noch nicht angelegt)

```text
game/assets/
  style_reference/current/            # abgenommene Masterbilder, unverändert
  style_reference/archive/            # nicht mehr führende Studien
  source/forest_camp_v01/             # originale Generierungen, editierbare Quellen
    terrain/  vegetation/  props/  characters/
  production/forest_camp_v01/         # überprüfte, native Spielpixel
    terrain/  transitions/  decals/
    vegetation/  props/  characters/
  previews/forest_camp_v01/           # Kontaktbögen, Seamtests, Zoomvergleiche
  scenes/forest_camp_v01/             # Dummy-Lageplan, Komposition und Exporte
```

Originalquellen bleiben separat, damit erneute Bearbeitung ohne Qualitätsverlust möglich ist. Nur geprüfte, eindeutig benannte Bilder wandern nach `production/`. Dateien werden als **PNG-Binärdaten** übertragen; keine Umwandlung ihrer Byteinhalte in UTF-8-Texte. Spätere Atlanten sind generierte Derivate und nicht die Masterquellen.

**Dateinamenskonvention:** `<klasse>_<motiv>_<variante>[_<richtung>][_fNN][_zustand].png`, ASCII, Kleinbuchstaben, `snake_case`; z. B. `terrain_grass_01.png`, `tree_oak_large_01_crown.png`, `char_villager_a_01_front_idle_f00.png`. Die stabilen Asset-IDs und geplanten Varianten stehen in der Waldcamp-Assetliste.

## 4. Mindestvertrag eines Einzelassets

Jedes Asset erhält einen Eintrag im späteren Manifest (JSON/CSV/Markdown im ersten Schritt ausreichend):

| Feld | Zweck |
| --- | --- |
| `asset_id` / `category` | eindeutige Identifikation / Terrain, Objekt, Figur, Effekt |
| `style_reference_version` | welche Bildreferenz wurde verwendet? |
| `source_file`, `output_file` | unverändertes Rohbild und geprüfter PNG-Export |
| `pixel_size` | tatsächliche Bildbreite und -höhe in Pixeln |
| `world_footprint_m` | geplante Aufstands-/Belegungsfläche in Weltmetern |
| `anchor_px` | lokaler Bodenanker im Pixelbild; separat von der Bildecke |
| `layer` und `sort_anchor` | Boden, Dekor, Objektbasis, Figur, Vordergrund, Effekt |
| `transparency` | transparentes RGBA oder deckendes Terrain |
| `variant` / `direction` / `state` | Varianten und Zustände |
| `status` | `raw` → `processed` → `qa_passed` → `scene_approved` |
| `notes` | offene Perspektiv-, Farb- oder Maßstabsfragen |

Der Anker einer stehenden Figur liegt unter den Füßen, bei einem Baum am Stammfuß und bei Bodenflächen an einer wohldefinierten Tile-Ecke. Ankerpositionen sind **explizit** gespeichert, nicht aus dem transparenten Bildrand erraten. Grafische Ausdehnung, Kronenbreite und spätere Kollision sind verschiedene Dinge.

## 5. Erzeugungsmethode

### 5.1 Von der Art Direction zu kleinen kontrollierten Einheiten

- Freigegebene Referenzbilder für Perspektive, Palette, Licht und Proportionen zusammenstellen.
- Ein **Kalibrierblatt** entwerfen: 32×32-px-Bodentile für 1×1 m Weltfläche, Erwachsene in 32×32-px-Rahmen, 20×20 sichtbare Kinderfigur als optionale Studie, Lagerfeuer, junges Gehölz, große Eiche.
- Erst einen **Stil-Pilot** mit Gras, Waldboden, Wasser, einem Baum, Feuer und einer Figur herstellen. Nicht das gesamte Set in einem einzigen Bild generieren.
- Nach Freigabe Produktionsgruppen in kleinen, eindeutig prüfbaren Chargen erstellen.

**Generative Modelle liefern Rohentwürfe.** Exakte Kachelbarkeit, wirkliche Transparenz, ein einzelnes logisch getrenntes Sprite, konsistente 32-Pixel-Maße oder korrekte Framenummern dürfen nicht ungeprüft als erfüllt gelten. Wenn eine KI-Ausgabe nicht mit wenigen kontrollierten Bearbeitungsschritten auf die Zielpixel überführbar ist, neu zeichnen oder gezielt pixelgenau editieren; nicht durch willkürliches Herunterskalieren „reparieren“.

### 5.2 Einheitlicher Prompt-/Briefing-Vertrag

Jeder Einzelauftrag enthält:

```text
ASSET-ID / KATEGORIE / MOTIV
REFERENZ: Waldcamp-Prototyp 02, freigegebener Stil
PERSPEKTIVE: quadratisches Grundraster, schräge RPG-Draufsicht
WELTMASS: 32 Pixel je 1 m Terrain; definierter Objekt-Footprint
BILD: konkrete native Pixelabmessungen, RGBA oder deckend
ANKER: exakt angegebener Bodenanker; transparente Reserve falls nötig
FORM/FARBEN: natürliche gedämpfte Pixel-Art, klare Cluster, lesbare Silhouette
LICHT: konsistente globale Richtung; kein eingebrannter starker Szene-Lichtkegel
VARIANTEN/ZUSTAND: explizite Anzahl und Unterschiede
NEGATIV: kein Gemälde, keine Unschärfe, keine Pseudo-Pixel, keine Perspektivmischung
ABNAHME: Tile-/Alpha-/Seam-/Proportion-/Szenentest gemäß Kategorie
```

Bei Terrain fordert das Briefing ausdrücklich nahtlose Kanten, Wiederholungsvarianten und eine definierte Nachbarschaftslogik. Bei Figuren fordert es vollständige Kopf-bis-Fuß-Silhouetten, konsistente Bodenanker und richtungsübergreifend gleiche Kleidung/Proportionen.

### 5.3 Terrain als **echte Tiles**

1. Deckende Basistiles `32×32` px (Gras, Laub, Erde, Wasser) pixelgenau zeichnen.
2. Kontrolliert mehrere Varianten pro Grundmaterial erzeugen; Häufigkeitsgewichte festlegen, damit keine regelmäßigen Muster entstehen.
3. Wasser/Land-Übergänge als zusammenhängende Familie mit konsistentem Kanten-/Eckensystem entwickeln; die genaue 16-Masken-/Autotile-Logik wird in der Assetliste erläutert.
4. Details wie Laub, kleine Büsche oder Grasbüschel als transparente Decals **separat** auflegen.
5. Eine 8×8-Wiederholungsmatrix, eine zufällige 16×16-Matrix und beliebige Mischungen gegen Nachbarkanten prüfen; kein sichtbarer Schnitt, keine auffällige Texturperiodik.

Pixelkanten sind farblich/strukturell aufeinander abzustimmen; ein Bild, das isoliert schön wirkt, aber im Raster harte Nähte erzeugt, besteht die Abnahme nicht.

### 5.4 Figuren

- Startziel: zwei deutlich unterscheidbare Erwachsene, jeweils ein neutraler Pose-Entwurf in **front/back/left/right**; Figur komplett innerhalb eines konsistenten Bezugsrahmens sichtbar.
- Richtungsvarianten aus einem einheitlichen Turnaround ableiten, nicht unabhängig neu interpretieren lassen.
- Nominales Ausgangsfenster `32×32 px`, Erwachsene mit ungefähr 26–32 px Körperbreite und 28–32 px Höhe als **Prüfhypothese**, nicht als unveränderbares Anatomiegesetz.
- Kleine Kinder als gesonderte optionale `20×20`-Pixel-Silhouettenprüfung im gleichen Bezugsrahmen.
- Einheitliche Fußanker und Y-Sortierung prüfen; genügend Luft für separate Werkzeuge/Hüte/Trageobjekte.
- Spätere Bewegung mit universellen Familien `idle`, `walk`, `reach_use`, `strike`, `bend_gather`, `carry`, `sit_rest`, `sleep`. Für eine vollständige Animation erst nach Basis-Sprite-Freigabe feste Frameanzahl, fps, Handanker und Ausrüstungslayer definieren. Keine Pflicht zu allen Animationen für das statische MVP.

### 5.5 Vegetation und Lagerobjekte

- Vegetation als transparentes RGBA, mit Stamm/Fußpunkt und ggf. getrenntem Kronen-Vordergrund für spätere Überdeckung.
- Kronen sollen proportional zu Personen und Weltmetern sein; große Eichen dürfen über viele Tiles reichen. Der Welt-Footprint bezieht sich auf den Stamm-/Wurzelbereich, **nicht** den Kronendurchmesser.
- Props verwenden eindeutige Objektanker, natürliche Materialien, plausible Größe; Lagerfeuer-Grundobjekt und Flammen-/Glut-Layer getrennt.
- Keine fest eingemalten fremden Hintergründe, weichen Freistellhalos oder bildfüllenden Dropshadows. Bodenkontaktschatten wenn nötig als eigener kontrollierter Layer.
- Varianten variieren Form und Mikrodetails, **nicht** unkontrolliert Perspektive oder globalen Lichtwinkel.

## 6. QA-Gates – jede Gruppe muss bestehen

| Gate | Test / Ausgabedatei | Bestehen, wenn … |
| --- | --- | --- |
| Q0 Brief | Manifest-ID + Zielmaße + Footprint | Typ, Abmessung, Anker, Referenz eindeutig |
| Q1 Bildintegrität | PNG-Metadaten, Pixelmaße, Alpha | PNG lesbar, RGBA/Deckkraft korrekt, kein leerer Randfehler |
| Q2 Pixelraster | 1×- und 4×-Nearest-Neighbor-Vorschau | keine weichgezeichneten Kanten oder künstliche Zwischenpixel |
| Q3 Tiles | 8×8-Mosaik, 16×16-Mischtile, Uferecken | keine sichtbaren Wiederholungsnähte oder falschen Kanten |
| Q4 Geometrie | Testfigur neben Feuer, Schlafplatz, Baum, Teich | gleiche Kamerakonvention, plausible Größe, konsistenter Bodenanker |
| Q5 Funktionale Lesbarkeit | Testszene in 12×12-m- und 24×24-m-Ausschnitt | Figuren, Pfad, Wasser und zentrale Props unterscheidbar |
| Q6 Stil | Referenzbild und Szene nebeneinander | Palette, Kontrast und Formen wirken wie eine zusammenhängende Welt |
| Q7 Wiederverwendung | mindestens zwei unterschiedliche Platzierungen pro Objektklasse | keine offensichtlich kopierten Großformen, wo Variationen notwendig sind |
| Q8 Herkunft | Manifest, Rohbild, Export und QA-Vorschau | Ergebnis reproduzierbar zuordenbar, Abnahme dokumentiert |

QA ist **nicht** „in ImageGen erfolgreich entstanden“. Bild- und Alpha-Tests sind anhand tatsächlich exportierter PNGs zu belegen. Ein fehlgeschlagener Gate führt zu `rework`, nicht direkt zur nächsten Produktionsgruppe.

## 7. Erste Produktionsabfolge

1. **Referenzmigration** abschließen, alte Einzelbildstudien aus der aktiven Stilreferenz entfernen.
2. **Kalibrierblatt** mit Figur, Eiche, Lagerfeuer und 32×32-Tile; Perspektive/Proportionen freigeben.
3. **Terrain-Pilot:** Gras, Waldboden, Erde, Wasser, Ufer; nahtlose Mosaike überprüfen.
4. **Vegetations-Pilot:** drei Baumgrößen, Büsche und Felsen mit Ankern.
5. **Camp-Props:** Feuer, Schlafplätze, Holz und einfacher Wetterschutz.
6. **Zwei Figuren:** Turnarounds und mindestens eine statische Arbeits-/Tragepose für die Szene.
7. **Gesamter Asset-Batch** nach [Assetliste](forest-camp-asset-list-v0.1.md) ergänzen, Manifest/QA schließen.
8. **Dumme Waldcamp-Komposition** aus geprüften Einzeldateien erstellen, provisorisch mit einem reproduzierbaren 64×64-Zellen-Lageplan und definierter Layerreihenfolge (statisches Skript, Bildeditor oder andere einfache Komposition; noch keine Spielengine nötig).
9. Exporte: komplette 64×64-m-Ansicht, natives 12×12-m-Crop, 24×24-m-Ausschnitt und konsistentes Zoomvergleichsblatt; 120×120 m erst mit ergänztem Umgebungsbereich.
10. Szene visuell freigeben. **Erst danach** Atlanten/Animationen und eine mögliche Godot-Darstellung erarbeiten.

## 8. Definition of Done / Nichtziele

**Fertig** ist dieser Produktionsschritt, wenn (a) ein vollständiges, versioniertes und geprüftes Asset-Set vorhanden ist, (b) ein dokumentierter, wiederholbarer statischer Lageplan alle Dateien zusammenführt und (c) die Waldcamp-Szene in den festgelegten Ansichten visuell abgenommen ist.

**Nicht Bestandteil:** Spielregeln, Navigation, Kollision, KI, Inventar, Simulation, Physik, Persistenz, interaktive Kamerasteuerung oder tausende fertige Animationen. Eine vorgerenderte hübsche Szene ohne wiederverwendbare Einzelassets **erfüllt den Auftrag nicht**.

**Offene technische Entscheidungen:** Projektion und Körperhöhe der Figur bei 32 px/m; exakt erforderliche Wasser-/Ufermasken; spätere Zoom-/LOD-Grenzen; Animationsframerate und Anzahl Richtungsvarianten jenseits der vier Startansichten; Format eines eventuellen enginegebundenen Szenenlayers.
