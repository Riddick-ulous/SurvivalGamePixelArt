# Grafikkonzept v0.3 – Lebendige Welt

**Stand:** 2026-10-09  
**Status:** Vom Projektauftraggeber als gestalterische Grundlage freigegeben. Technische Parameter werden im Prototyp überprüft.  
**Quellen:** docs/game-concept-v02.md, docs/architecture/technical-design.md, docs/design/game-systems.md; Grafikprototyp 01.

## 1. Zielbild

Eine glaubwürdige, riesige und eigenständig lebende Welt in schräger 2,5D-Draufsicht: detailreiche, organische Natur und warme Atmosphäre ähnlich der Landschaftswirkung von Stardew Valley, verbunden mit der funktionalen Lesbarkeit einer Simulation wie RimWorld. Die Welt soll ausdrücklich nicht wie ein Gemälde wirken, über das Spielfiguren laufen. Pixelcluster, Silhouetten und Interaktionen bleiben klar.

Setting: gemäßigtes Mitteleuropa bis spätes Mittelalter, alltägliches Survival, Handwerk, Sozialleben und Siedlungsentwicklung. Keine Magie oder Fantasy-Effekte als Grundstil. GBA-inspirierte, aber nicht durch eine Hardwarepalette begrenzte Pixel-Art.

**Prioritäten:** konsistente Perspektive, glaubwürdiger Maßstab, klare Sichtbarkeit von Personen/Tätigkeiten, wiederverwendbare Bausteine, atmosphärischer Gesamteindruck.

## 2. Raster, Pixelmaßstab, Körpergrößen

- **Neuer Grafik-Zielmaßstab:** 32 × 32 logische Bildpixel je 1 × 1 m Weltfeld, statt bislang nominell 16 × 16.
- **Simulationsraster bleibt 1 × 1 m**, optional mit Feinoffsets. Kollisionsfläche, Position, Sprite-Bild und Bodenanker sind getrennte Größen.
- Erwachsene: zunächst 32 × 32 px Sprite-Rahmen; je nach Form etwa 26–32 × 28–32 px sichtbarer Körper.
- Kleines Kind: beispielhaft ca. 20 × 20 sichtbare Pixel **innerhalb desselben 32 × 32-Rahmens**; Jugendliche dazwischen.
- Charaktere werden **vollständig von Kopf bis Fuß** gezeigt; frontal sind Gesicht, Oberkörper, Beine und Füße sichtbar. Rück- und Seitenansichten entsprechend.
- Die Neigung des Bodens und die stilisierte RPG-Figurenprojektion werden aufeinander abgestimmt. Nicht die extrem verkürzte Vogelperspektive.
- 32 px/m ist die nominale horizontale Projektion; es ist **keine** zwingende Aussage, dass 1 m Körperhöhe exakt 32 Bildschirm-Pixel entspricht.
- Sprites mit Werkzeugen, Hüten oder ausladenden Animationen dürfen größere transparente Animationsrahmen beziehungsweise zusätzliche Layer verwenden.
- Bodenanker an den Füßen; Größe und Schatten folgen derselben räumlichen Konvention.
- Gebäude und große Bäume überschreiten mehrere Weltfelder und können aus mehreren Sprites bestehen. Stammkollision ist nicht die Größe der Baumkrone.

**Zu überprüfen:** Ob eine erwachsene Figur mit höchstens 32 px sichtbarer Höhe bei 32 px/m optisch richtig proportioniert ist; die Perspektivstudie darf dafür größere Darstellungshöhen empfehlen.

## 3. Perspektive und Szene

- Schräge 2,5D-Draufsicht, **kein** rautenförmig-isometrisches Grundraster.
- Quadratische Kartenfelder mit getrennten Höheninformationen (level); Höhen, Ufer, Treppen/Rampen und Steigungen sollen ablesbar sein.
- Von Figuren werden in Frontansicht Kopf bis Füße sichtbar; die Kamera zeigt dennoch Boden und Dächer aus schräger Sicht.
- Häuser erhalten erkennbare Dächer und Vorder-/Seitenflächen; verdeckende Dächer/Wände oder Baumkronen lassen sich kontextabhängig transparent beziehungsweise ausblendbar darstellen.
- Konsistente Bodenanker, Sortierreihenfolge von Sprites, Licht und Schatten; keine frei gemischten Front-, Profil- und Vogelperspektiven.
- Exakte Kameraneigung und Projektion vertikaler Höhen bleiben bis zur Waldcamp-Szenenstudie offen.

## 4. Zoom: Nahdetail bis Stadtübersicht

Verschiebbare Kamera mit sehr großem Zoombereich, ohne die zugrunde liegenden Simulationsregeln zu verändern.

| Quadratischer Orientierungs-Ausschnitt | Primäre Funktion |
| --- | --- |
| 12 × 12 m = 384 × 384 nominale Weltpixel | Person, Handgriff, Werkstück |
| 24 × 24 m | Lager und unmittelbares Umfeld |
| 48 × 48 m | Waldlichtung und Gehöft |
| 120 × 120 m | Lagerumgebung, großer Siedlungsausschnitt |
| 256 × 256 m | Dorf |
| 512 × 512 m | größere Siedlung / Stadtteil |
| 1024 × 1024 m und mehr | Stadt- und Landschaftsübersicht |

Dies sind **keine festen Zoomstufen** und keine Zusage bestimmter Stadtabmessungen: stufenloses Zoomen und verschiedene Bildschirmseitenverhältnisse sind zu berücksichtigen. Die tatsächlich gezeichneten Bildpixel hängen von Displaygröße und Zoom ab; 384 Pixel bedeuten nur den nominalen Weltpixelraum von 12 Metern.

**Level of Detail (LOD):**
- Nah: vollständige Sprites, Animationen, einzelne Werkstücke, lokale Effekte.
- Mittel: reduzierte Bodendetails, vereinfachte Animation/Partikel, weiterhin erkennbare Personen und Gebäude.
- Fern: zusammengefasste Vegetation, vereinfachte Objekte und Gebäude, ggf. Personengruppen statt Individuen.
- Stadtübersicht: Wege, Baukörper, Feldflächen und räumliche Orientierung, bei Bedarf zusätzliche symbolische Kennzeichnungen.

Wichtig: Nur die Darstellung vereinfacht sich; Ressourcen und Bevölkerung entstehen nicht neu, und näher heranzoomen beschleunigt keine Prozesse. Kamerabewegung und Zoomfokus sollen stabil sein, ohne störendes Pixelzittern. Die konkreten LOD-Schwellen und Filter werden erst durch Tests fixiert.

## 5. Stil, Palette und Lesbarkeit

- Stil zwischen atmosphärischer RPG-Naturdarstellung und lesbarer Simulationsgrafik, **keine** fotorealistischen oder malerisch verwischten Oberflächen.
- Definierte, deutlich sichtbare Pixelcluster und klare Objektsilhouetten.
- Organische Formen, gemäßigtes Mitteleuropa: Grün/Olive/Moos/Erde, natürlich schieferblaues Wasser, warme Holzfarben, graue Steine, glaubwürdige Stoffe.
- Gemeinsame abgestimmte Farbpalette, keine starre historische Hardware-Farbgrenze.
- Grundterrain relativ ruhig und kontrastarm; Personen, Werkstücke und wichtige Objekte durch selektiv stärkere Lesbarkeit hervorgehoben.
- Hoher Detailgrad für relevante Menschen, Werkplätze und markante Bäume; mittlerer für Sträucher/Steine/Ufer; ruhige Flächen für großräumiges Gelände.
- Keine übertriebenen Comic-Proportionen; keine visuelle Überladung mit gleich starkem Detailkontrast.
- Nacht, Schatten und Regen bleiben atmosphärisch und mechanisch relevant; Inspektionsansichten dürfen unbekannte Weltinformationen nicht verraten.

## 6. Modulare Asset-Pipeline

Geplante unabhängige Grafikschichten:
1. Grundterrain: Gras, Erde, Waldboden, Wasser, ggf. Sand.
2. Übergänge: gerade Kanten, Innen- und Außenecken, Ufer, Wege.
3. Bodendekor: Laub, Blumen, Steine, Pilze, Grasbüschel.
4. Vegetation: Stämme/Kronen, Büsche und Wachstumsformen.
5. Weltobjekte: Feuer, Schlafplätze, Holzlager, Werkzeuge, Werkstätten/Gebäude.
6. Personen/Tiere und separat angehängte Gegenstände.
7. Wetter, Licht, Schatten, Rauch, Feuerpartikel.

Terrain muss ohne sichtbare Wiederholungsnähte kachelbar sein, mehrere Grundvarianten und geeignete Übergänge besitzen. Dekor wird getrennt verteilt und bestimmt nicht die Simulationsdaten. Große Objekte benötigen transparente Hintergründe, Bodenanker und nachvollziehbare Sortierung. Vorgesehen sind PNG, transparente Alpha-Kanäle, Nearest-Neighbor bei pixelgenauen Maßstäben, Sprite-Atlanten nach technischer Validierung.

## 7. Zustände statt bloßer Dekoration

Die Grafik zeigt echte Zustände der Simulation: Nässe und Pfützen, Trockenheit, Frost, Schnee, Wind, Rauchrichtung, Feuer/Glut/Erlöschen, Baumwachstum/Abholzung, Feldreife/Ernte, getragene Gegenstände, sichtbare Werkstücke und Vorratsänderungen.

Menschen zeigen unter anderem Gehen, Sitzen, Arbeiten, Tragen, Schlafen, Frieren, Hinken, Essen und Gespräche. Ein Prozess darf nicht visuell weiterlaufen, wenn er simulativ blockiert oder beendet ist.

## 8. Animationskonzept: viel Ausdruck durch Wiederverwendung

Die Simulationsbreite erfordert **einfach gehaltene, modulare und wiederverwendbare** Animationsfamilien statt einer komplett individuell gezeichneten Animation für jedes Handwerk.

| Familie | Beispiele |
| --- | --- |
| Idle | Stehen, Warten, Beobachten |
| Walk | Gehen, Reisen, einfacher Transport |
| Reach / Use | Verwenden, Bearbeiten, Greifen |
| Strike | Hacken, Hämmern, Schlagen |
| Bend / Gather | Sammeln, Pflanzen, Ernten, Aufheben |
| Carry | Tragen von Holz, Wasser, Körben |
| Sit / Rest | Sitzen, Essen, Unterhalten, Ausruhen |
| Sleep | Liegen, Schlafen |

- Vier Richtungen als Startpunkt.
- Wenige Schlüsselbilder: z. B. Walk mit 4 Frames, Tätigkeiten häufig 2–4 Frames; Zahlen vorläufig.
- Werkzeug, Gegenstand und Handanker getrennt von der Körper-Grundbewegung.
- Variationen über Timing, Richtung, Sprite-Layer und wo möglich Spiegelung; keine falsche Spiegelung asymmetrischer Ausrüstung.
- Beispiel: Tätigkeit Holz hacken → Familie Strike → Werkzeug Axt → Ziel Baumstamm; andere Schlagarbeiten nutzen verwandte Bewegungen.
- Simulation liefert Tätigkeit/Zustand; Darstellung wählt Bewegungsfamilie, Objekt-Sprite, Takt und gegebenenfalls Effekt.
- Neue Tätigkeiten sollen möglichst durch Kombination bestehender Animationen integrierbar sein.

## 9. Nächster Meilenstein: integrierte Waldcamp-Konzeptszene

**Statt weiterer Einzelassets** folgt eine zusammenhängende 64 × 64 m große Waldcamp-Szene, nominal 2048 × 2048 Weltpixel. Eine Konzeptansicht muss nicht bereits eine begehbare Godot-Szene sein; sie muss aber eine konsistente Spielprojektion und glaubwürdige Proportionen vorführen.

Bildinhalte:
- Waldlichtung in gemäßigter Region, Naturwald mit älteren und jungen Laubbäumen, Waldrand und unterschiedlicher Dichte;
- Gras- und Waldboden, sichtbare Übergänge, Laub, Moos, Steine, Büsche, Pilze;
- Teich oder Bach mit natürlichem Ufer, angedeuteter Fußpfad;
- provisorischer Lagerplatz (Feuer mit Steinkreis, zwei einfache Schlafplätze, Holzvorrat, lose Äste, wenige Werkzeuge), optional einfacher Wetterschutz;
- zwei vollständig sichtbare erwachsene Menschen mit unterscheidbarer Kleidung und lesbaren Haltungen, mindestens eine kleine Alltagstätigkeit;
- optional eine Kinderfigur **nur zur Maßstabsprüfung**, nicht als implizite Änderung des ersten Spielszenarios.

Anmutung: ruhiger Tageszeitpunkt mit warmem Licht; naturnahes, improvisiertes Survival-Camp statt romantisierte Fantasy-Siedlung.

Prüfansichten: Gesamtübersicht der Lichtung, 12 × 12 m Nahansicht, Darstellung in nativer Pixelskalierung sowie auf 120 × 120 m herausgezoomt. Die 64 × 64 m Szene selbst kann naturgemäß kein 120 × 120 m Detailfeld füllen; dafür muss der Bildausschnitt um weitere Umgebung ergänzt oder exemplarisch demonstriert werden.

## 10. Abnahme

Das Konzept-/Szenen-MVP ist gestalterisch geeignet, wenn:

1. Landschaft und Charaktere eine zusammenhängende visuelle Sprache haben.
2. Perspektive und Größenrelationen bei Erwachsenen, Bäumen, Feuer und Gegenständen stimmen.
3. Figuren vollständig sichtbar sind und vor dem Gelände lesbar bleiben.
4. Pixel-Art in Nahansicht klar statt verwaschen wirkt.
5. Gras, Waldboden, Wasser und Ufer natürlich ineinander übergehen.
6. Die Szene auch ohne rein dekorative Überladung Atmosphäre besitzt.
7. Sprite-Anker, Überdeckungen und Modularisierung technisch sinnvoll realisierbar erscheinen.
8. Vereinfachte Arbeitsbewegungen plausibel mehrfach wiederverwendet werden können.
9. Eine Mittel-Zoomansicht ihre Orientierung und Lesbarkeit erhält.
10. Die Konzepte sich in echte Godot-Sprites/Tilesets überführen lassen.

**Abgrenzung:** Eine einzelne vorgerenderte Szene beweist noch keine echte Tilebarkeit, Pixelgenauigkeit, Animation oder spielbare Godot-Integration. Das sind eigene technische Abnahmestufen.

## 11. Reihenfolge und offene Fragen

1. Dieses freigegebene Konzept im Git versionieren.
2. Erste integrierte Waldcamp-Bildstudie erzeugen.
3. Perspektive, Figurengröße, Detailgrad und Farben anhand der Gesamtszene beurteilen.
4. Varianten und Korrekturen erstellen; visuelle Richtung verbindlich machen.
5. Terrain-Tiles, Character-Sheets, Animationsfamilien und mehrschichtige Weltobjekte erstellen.
6. Godot-Präsentationsprototyp mit Zoom und LOD aufbauen.
7. Simulation gemäß docs/project/BACKLOG.md integrieren.

**Noch offen:** genaue Neigung und Höhenprojektion, Erwachsenengröße bei 32 px/m, Animationsfps/Frameraten, LOD-Schwellen, Baumkronen-Transparenz, Licht- und Schattenumsetzung und Zielauflösung des Präsentationsfensters.
