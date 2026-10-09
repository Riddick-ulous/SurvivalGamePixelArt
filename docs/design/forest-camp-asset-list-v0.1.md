# Forest-Camp-Asset-List v0.1 – Lebendige Welt

**Stand:** 2026-10-09  
**Status:** Produktionsplanung, noch keine generierten oder geprüften Assets.  
**Verbindliche Grundlagen:** [Grafikkonzept v0.3](graphics-concept-v0.3.md), [Asset-Generation-Workflow v0.1](asset-generation-workflow-v0.1.md).  
**Ziel:** Ein **wiederverwendbares**, in sich stimmiges Pixel-Art-Assetset für eine statisch zusammengesetzte Waldcamp-Szene. Kein Gameplay, keine Engine und keine Simulationsfunktionen.

## 1. Szenenbrief und Maßstab

- **Weltfläche:** 64 × 64 m = 4.096 logische 1×1-m-Felder.
- **Zielmaßstab:** 32 px/m; nominale Szene 2.048 × 2.048 Weltpixel (nicht notwendigerweise ein einziges Bild).
- **Kamera:** schräge 2,5D-RPG-Draufsicht mit quadratischem Bodenraster, keine rautenförmige Isometrie.
- **Setting:** gemäßigter naturnaher Wald, Lichtung, Wasserstelle, primitiver Lagerplatz, zwei Erwachsene.
- **Bildsprache:** freigegebene Waldcamp-Konzepttafel als Stilziel, organische Vegetation, klare und gut lesbare Pixelcluster und Charaktere.
- **Perspektivziel:** Figuren frontal vollständig von Kopf bis Fuß erkennbar, konsistente Fußanker und Objektproportionen.
- **Abgrenzung:** Die Konzepttafel zeigt auch Boot/Stege/weitere Ausstattung; diese sind **nicht** automatisch Teil des frühen Waldcamp-Sets. Für den Start gelten einfache, plausible Überlebensgegenstände.

**Abhängigkeitsregel:** Vor dem eigentlichen Produktionslauf müssen die zwei freigegebenen Waldcamp-Referenzbilder als Binärdateien in `game/assets/style_reference/current/` versioniert und die alten Einzelbildstudien aus dem aktiven Referenzsatz entfernt sein. Bis dahin sind die Referenzen im Gespräch bestätigt, aber im Repository noch nicht als neuer Master abgelegt.

## 2. Lieferstruktur und Status

Verwende `game/assets/source/forest_camp_v01/` für unveränderte Ausgangsgrafiken, `game/assets/production/forest_camp_v01/` für geprüfte Einzelbilder, `game/assets/previews/forest_camp_v01/` für QA und `game/assets/scenes/forest_camp_v01/` für Lageplan und Renderexporte.

**Priorität:**
- **P0 (Waldcamp-MVP):** zwingend für das erste vollständige statische Waldcamp.
- **P1 (Visuelle Qualität):** kontrollierte Form-/Texturvarianten für glaubwürdigere, weniger repetitive Szene.
- **P2 (Später):** Animationen, LOD, alternative Jahreszeiten, größere Strukturen, Boote, Brücken und technische Godot-Einbindung.

**Lieferdefinition:** Ein „Asset“ in den folgenden Tabellen bezeichnet eine eigenständige Bildvariante, Frame- oder Zustandsdatei. Ein Objekt kann mehrfach in der Szene platziert werden, ohne neue Bilddateien zu benötigen. Die genannte Dateianzahl ist eine Produktionsplanung, **keine** bereits erfüllte Menge.

## 3. Terrain – native 32×32-Pixel-Tiles

| ID-Präfix / Assetfamilie | P0 | P1 zusätzlich | Bild | Bemerkung |
| --- | ---: | ---: | --- | --- |
| `terrain_grass_` | 2 | 2 | 32×32 px | neutrales Wiesen-Grün, geringe Kontraste |
| `terrain_forest_floor_` | 2 | 1 | 32×32 px | Moos/Laub/Erde ohne auffällige Muster |
| `terrain_dirt_path_` | 1 | 2 | 32×32 px | einfacher getretener Boden, keine Pflasterstraße |
| `terrain_bare_earth_` | 1 | 1 | 32×32 px | freigelegter trockener Untergrund am Lager |
| `terrain_water_deep_` | 1 | 1 | 32×32 px | ruhiges blaugrünes Wasser, keine feste Lichtspiegelung |
| `terrain_water_shallow_` | 1 | 0 | 32×32 px | Ufer-Nahbereich, dezente Transparenz oder Deckfarbe |
| `transition_shore_m00…m15` | 16 | 0 | 32×32 px | 16 Kombinationen der Land/Wasser-Ecken |
| `transition_shore_m05_alt, m10_alt` | 2 | 0 | 32×32 px | Mehrdeutigkeiten bei diagonal gegenüberliegenden Ecken |
| **Summe** | **26** | **7** | | **33 Dateien** |

### Terrain-Übergangsvertrag

Die Land-/Wasserfamilie verwendet ein dokumentiertes **4-Ecken-Maskensystem (Bitwerte 1,2,4,8 im Uhrzeigersinn ab oben links)**. `m00` bis `m15` sind die 16 Maskenkombinationen (binäre Land- bzw. Wasserecken), die beiden diagonalen Zweifelsfälle erhalten je eine zusätzliche Variante. Die endgültige Auswahlregel für Sattelfälle muss vor der Verwendung im Lageplan explizit festgelegt werden.

**Wichtig:** Eine 18er-Maskenfamilie ist ein **Startansatz**, keine Garantie, dass alle optisch notwendigen Küsten-, Misch- oder Pfadvarianten bereits abgedeckt sind. Übergänge werden im Nachbarschaftstest ergänzt, falls Lücken oder Nähte auftreten. Nicht jeden Übergang als isolierte vollfarbige Kachel generieren; Basiswasser und Land-Überlagerung können aus getrennten Ebenen bestehen.

Gras, Laub, Erde und Wasser müssen in 8×8- und 16×16-Tests ohne auffällige Nähte/Periodik wirken. Der Lagerpfad darf zunächst durch Erdflächen und verteilte Rand-Decals natürlich verlaufen; ein vollautomatisches Wege-Autotile-System ist erst P2.

## 4. Bodendetails – separate transparente Decals

| ID-Präfix | P0 | P1 zusätzlich | Bild-/Fußabdruckvorschlag | Ziel |
| --- | ---: | ---: | --- | --- |
| `decal_leaf_` | 1 | 2 | 16–32 px | lockeres Laub, kein starres Muster |
| `decal_grass_clump_` | 1 | 2 | 12–32 px | einzelne Grashalme |
| `decal_wildflowers_` | 1 | 2 | 16–32 px | dezente helle Blüten |
| `decal_moss_` | 1 | 1 | 16–32 px | natürliches Moospolster |
| `decal_pebbles_` | 1 | 2 | 12–32 px | Steinsplitter und Kies |
| `decal_fern_` | 1 | 1 | 20–48 px | Farn/Bodendecker |
| `decal_twigs_` | 1 | 1 | 16–40 px | kleine Zweige am Boden |
| **Summe** | **7** | **11** | | **18 Dateien** |

Decals dürfen mehrere Weltfelder visuell berühren, besitzen jedoch keine eigene Raster-Kollisionslogik. Wichtig sind **Alpha**, geringer Kontrast und kein immer identisches Wiederholungsmuster. Die natürliche Variation soll vor allem aus Kombination und Verteilung dieser kleinen Elemente entstehen.

## 5. Vegetation und Naturkörper

Alle Objekte werden als transparentes PNG mit **Bodenanker** geführt. Angegebene Größen sind Vorschläge zur späteren Perspektivprüfung, keine unverrückbaren Abnahmegrenzen. `Footprint` meint den Stamm-/Bodenkontakt, nicht die Bild- oder Kronenfläche.

| ID-Präfix | P0 | P1 zusätzlich | Footprint (Planwert) | Bild-/Kronenbreite (Anhalt) |
| --- | ---: | ---: | --- | --- |
| `tree_sapling_deciduous_` | 1 | 1 | 1×1 m | 48–96 px |
| `tree_deciduous_medium_` | 1 | 1 | 1–2×1–2 m | 112–192 px |
| `tree_oak_large_` | 1 | 0 | 2×2 m | 192–320 px |
| `tree_conifer_medium_` | 1 | 1 | 1–2×1–2 m | 96–160 px |
| `bush_low_` | 1 | 2 | 1×1 m | 24–56 px |
| `bush_high_` | 1 | 1 | 1×1 m | 40–80 px |
| `tree_stump_` | 1 | 1 | 1×1 m | 32–64 px |
| `wood_fallen_log_` | 1 | 1 | 1–3×1 m | 48–112 px |
| `rock_small_` | 1 | 2 | ≤1×1 m | 16–40 px |
| `rock_boulder_` | 1 | 1 | 1–2×1–2 m | 48–112 px |
| `mushroom_cluster_` | 1 | 1 | ≤1×1 m | 12–32 px |
| **Summe** | **11** | **12** | | **23 Dateien** |

**Anker- und Überdeckungsregeln:** Stammbasis beziehungsweise Felskontakt bilden den Y-Sortieranker. Große Baumkronen benötigen langfristig getrennte Rück-/Vordergrundteile für Figurenüberdeckung; im ersten statischen Zusammensetzen genügt ein sauber dokumentierter Layerplan. Für P1 ist eine kontrollierte Kronenteilung vorzubereiten, ohne jede Baumvariante vollständig neu zeichnen zu müssen.

## 6. Waldcamp-Objekte und Ausrüstung

| ID-Präfix / Variante | P0 | P1 zusätzlich | Plan-Footprint | Hinweis |
| --- | ---: | ---: | --- | --- |
| `campfire_base_off, campfire_flame_on, campfire_embers` | 3 | 0 | 1×1 m | Feuergrundkörper und Zustands-/Effektlayer getrennt |
| `bedroll_` | 2 | 0 | ca. 1×2 m | zwei einfache Schlafplätze |
| `shelter_lean_to_` | 1 | 0 | ca. 2×3 m | primitiver, offener Wetterschutz |
| `firewood_stack_` | 1 | 1 | 1–2×1 m | einfacher Brennholzstapel |
| `work_surface_rough_` | 1 | 0 | 1×1 m | niedrige improvisierte Arbeitsfläche |
| `drying_frame_simple_` | 1 | 0 | 1–2×1 m | schlichtes Gestell, optional spärlich bestückt |
| `basket_woven_` | 1 | 0 | ≤1×1 m | Sammelkorb |
| `sack_cloth_` | 1 | 0 | ≤1×1 m | einfacher Vorratssack |
| `crate_small_` | 0 | 1 | 1×1 m | nicht zwingend im primitiven Lager |
| `tool_axe_stone_` | 1 | 0 | ≤1×1 m | rudimentäre Axt (erkennbar als Werkzeug) |
| `tool_knife_stone_` | 1 | 0 | ≤1×1 m | kleines Werkzeug, Nahansicht |
| `wood_log_loose_` | 1 | 1 | 1–2×1 m | einzelner Stamm/kurzes Rundholz |
| `kindling_bundle_` | 1 | 0 | ≤1×1 m | Zunder-/Anzündholz |
| **Summe** | **15** | **3** | | **18 Dateien/Zustandsebenen** |

Die Spalte `P0` gibt den Ausgangszustand der Szene an. Objekte wie der Feuer-Effekt brauchen zwar klar definierte Zustände, müssen für das erste statische Bild **noch nicht animiert** sein. Die spätere Animation soll aus denselben Grafikebenen abgeleitet werden.

**Nicht P0:** Boot, aufwendiger Holzsteg, große Werkstatt, geräumiges Haus, Lagerkisten-Reihen, Möbel, dekorative Marktstände. Die freigegebene Konzeptstudie legt hierfür den Stil nahe, aber nicht den frühen technologischen Fortschritt.

## 7. Charaktere und Posen

| ID / Variante | P0 | P1 | Spritefenster | Zweck |
| --- | ---: | ---: | --- | --- |
| `char_villager_a_front/back/left/right_idle_f00` | 4 | 0 | 32×32 px | Erwachsener A mit vollständiger Silhouette |
| `char_villager_b_front/back/left/right_idle_f00` | 4 | 0 | 32×32 px | Erwachsene B, visuell unterscheidbar |
| `char_villager_a_front_gather_f00` | 1 | 0 | mind. 32×32 px | Arbeits-Haltung / Sammeln |
| `char_villager_b_side_carry_f00` | 1 | 0 | mind. 32×32 px | Tragehaltung, Gegenstand ggf. eigener Layer |
| `char_child_front_idle_f00` | 0 | 1 | 32×32, Körper ca. 20×20 px | **nur** Maßstabsstudie, nicht Szene-Pflicht |
| **Summe** | **10** | **1 optional** | | **10 Pflicht-Frames** |

Zuerst eine einzige Figur als **kalibrierten Stilmaster** erstellen, dann die zweite ableiten. Vier Richtungen müssen dieselbe Figur zeigen und dieselben Bodenanker verwenden. Einzelne Posen sind noch **keine** vollständigen Animationsstreifen. Spätere Animationsfamilien `walk`, `reach_use`, `strike`, `bend_gather`, `carry`, `sit_rest`, `sleep` sind P2; 2–4 Frames pro Familienbewegung bleiben Testannahmen.

## 8. Menge und Produktionspriorität

| Gruppe | P0 Pflicht | P1 zusätzlich |
| --- | ---: | ---: |
| Terrain inkl. Uferfamilie | 26 | 7 |
| Transparente Bodendetails | 7 | 11 |
| Vegetation und Naturkörper | 11 | 12 |
| Camp-Objekte / Zustandslayer | 15 | 3 |
| Charaktere und statische Posen | 10 | 1 optional |
| **Gesamt** | **69** | **34 (davon 1 optional)** |

Somit umfasst die voll ausgebaute Planung **103 Einzelbilddateien/Layer**, davon 69 für P0 und 33 weitere reguläre P1-Dateien plus eine optionale Kinderskizze. Diese Summe beschreibt einen kleinen **Baukasten** für beliebig viele Platzierungen innerhalb der Szene, nicht 103 manuell gezeichnete vollständig einzigartige große Motive. Die tatsächliche Produktionsmenge darf anhand der ersten Mosaik-/Szenentests begründet angepasst werden.

**P0 heißt nicht: alles in einem großen Batch erstellen.** Gruppen werden nach dem [Workflow](asset-generation-workflow-v0.1.md) einzeln geprüft, insbesondere die 18 Ufermasken und Charakter-Perspektiven.

## 9. Lageplan und Dummy-Komposition

Für die Waldcamp-Szene wird ein **statischer, deterministisch wiederholbarer Lageplan** erstellt, z. B. `forest_camp_layout_v01.json`:

- Weltgröße, Asset-Version, Seed für dekorative Verteilungen;
- je Objekt `asset_id`, `world_x_m`, `world_y_m`, `layer`, `anchor`, ggf. `variant`, `rotation` (nur wenn Pixel-Art-tauglich);
- Terrainraster und Übergangsmasken;
- später nach Bedarf getrennte Vordergrund-/Kronenlayer;
- keine physikalischen, spieltechnischen oder wirtschaftlichen Zustände.

Ein einfacher Bildeditor oder Raster-Kompositor darf daraus Ansichten bauen. **Keine** Pflicht, hierfür bereits eine Godot-Spielszene zu implementieren.

### Geplante Bildkomposition

- Natürliche Lichtung, ungefähr 18–24 m Durchmesser; Lager etwas vom Gewässer abgesetzt.
- Teich oder langsam fließender Bach an einer Seite der Szene; organische Küstenlinie mit kleinen Einbuchtungen.
- Wechsel von dichtem Mischwald zu lichten Stellen, vorwiegend heimische Laub-/Nadelbäume.
- Dezent geschwungener Trampelpfad zur Wasserstelle, nicht gerade Rasterstraße.
- Lagerfeuer, zwei Schlafplätze, Wetterschutz, wenige Vorräte/Werkzeuge.
- Zwei Erwachsene auf unterschiedlichen Positionen, mindestens eine als arbeitend lesbare Pose.
- Ruhige, warme Tagesbeleuchtung; die gesamte Lichtung darf **nicht** mit gleich viel Detailkontrast gefüllt sein.

Die 64×64-m-Gesamtfläche ist ein Produktions- und Maßstabsziel; Assetpositionen und Baumdichte sind aus Bildkomposition und Proportionen zu bestimmen, nicht aus einer starren Pflanzen-pro-m²-Vorgabe.

## 10. Konkrete Lieferdateien und Abnahmebilder

Neben den geprüften Einzel-PNGs:

| Artefakt | Soll |
| --- | --- |
| `asset_manifest.json` oder `.csv` | ID, Datei, Maße, Anker, Footprint, Status, Quelle |
| `qa/terrain_repeat_8x8.png` | wiederholte Tiles ohne Naht |
| `qa/terrain_mix_16x16.png` | mehrere Varianten in gemischtem Raster |
| `qa/shore_mask_matrix.png` | alle Land/Wasser-Masken kontrolliert |
| `qa/style_scale_sheet.png` | Figur, Baum, Feuer, Schlafplatz, m-Raster nebeneinander |
| `qa/characters_4dir.png` | beide Figuren in vier Richtungen |
| `qa/asset_contact_sheet.png` | sämtliche Assets mit ID und transparenzgeeignetem Hintergrund |
| `scenes/forest_camp_layout_v01.json` | deterministischer Lageplan |
| `scenes/forest_camp_full_64x64.png` | Szene ohne UI bei nominal 2048×2048 Pixeln |
| `scenes/forest_camp_detail_12x12.png` | 384×384 Weltpixel um Lager / Figur |
| `scenes/forest_camp_mid_24x24.png` | 768×768 Weltpixel |
| `scenes/forest_camp_zoom_comparison.png` | vergleichbare Bildausschnitte, mit Maßstabslegende |

Das spätere 120×120-m-Zoomziel kann nur getestet werden, wenn der darzustellende Bereich entsprechend über die 64×64-m-Kernszene hinaus ergänzt wird. Ein mechanisches Hochskalieren des Waldcamp-Crops wäre kein valider LOD-/Zoomtest.

## 11. Reihenfolge der Abnahmen und Stop-Kriterien

**Gate A – Stil-/Größentest:** Ein Erwachsener neben 32×32-Terrain, Lagerfeuer und großer Eiche. Perspektive, erwachsene Bildhöhe und klare Silhouetten müssen glaubwürdig sein. Bei Fehlschlag **nicht** den restlichen Satz generieren.

**Gate B – Terrain:** Basis-Gras/Waldboden/Wasser, Ufermasken und Waldpfad bestehen Kachel-, Kanten- und Mischtests. Harte Wiederholungsnähte führen zu Überarbeitung.

**Gate C – Assetfamilien:** Natur-, Camp- und Charakterelemente wirken in einem gemeinsamen Kontaktbogen wie aus derselben Spielwelt; richtige Alphas, Anker und Footprints.

**Gate D – Statische Waldcamp-Szene:** Ein und dasselbe freigegebene Set erzeugt die Gesamtansicht und Nahausschnitte. Keine grotesken Größenbrüche oder widersprüchliche Perspektiven.

**Gate E – Produktionsfreigabe:** Manifest, Rohdateien, produktive PNGs, QA-Bilder, Szenen-Lageplan und Exporte sind versioniert und wiederholbar zuordenbar.

**Nicht beweisbar allein durch die Dummy-Szene:** Laufzeit-FPS, Godot-Import, echte Animation, kollisionsfähiges Terrain, Spielzustände, stufenloser Zoom oder City-LOD. Diese technischen Themen folgen **später und getrennt**.

## 12. Noch offen / Entscheidungen am ersten Pilot

1. Stimmen Erwachsene mit maximal 32 px sichtbarer Höhe perspektivisch, oder benötigen sie mehr Pixelhöhe bei gleichem 32-px-Bodenmaß?
2. Ist die vorläufige Ufermaskenfamilie für organische Gewässerkanten ausreichend?
3. Welche Baumkronen-Schatten-/Vordergrundtrennung ist für lesbare Figuren sinnvoll?
4. Wie viele Terrain- und Vegetationsvarianten werden nach Sichtung des ersten 64×64-m-Bildes wirklich benötigt?
5. Soll die spätere Dummy-Komposition als reiner reproduzierbarer Rasterexport bleiben oder zusätzlich in einen **rein visuellen, nicht-spielmechanischen** Editor übernommen werden?

Diese Punkte sind bewusst als **Prototypentscheidungen** ausgewiesen und dürfen nicht allein aus dem schönen Referenzbild als technisch gelöst gelten.
