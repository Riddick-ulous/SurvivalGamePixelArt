# Terrain-Rendering-Spike v0.1 — kleinster ehrlicher Grafiktest

Status: **geplant, NICHT implementiert oder visuell bestanden**. Ziel: herausfinden, ob ein aus Weltzustand gerendertes Heightfield unserer freigegebenen atmosphaerischen Pixel-Art-Referenz nahekommen kann, ohne denselben Detail- und Uebergangsverlust wie bei Tilesets.

## Testfrage
Kann ein *tatsaechlich aus Terrain-/Materialdaten gerendertes* 2,5D-Bild in 1x-Pixelskalierung glaubhafte Gras-/Erde-Grenzen, natuerliche Details und eine lesbare Hoehenveraenderung liefern? Ein generiertes Gesamtbild, ein Fake-Tileset oder ein nachtraeglich bearbeitetes Referenzbild zaehlt nicht.

## Minimalumfang (absichtlich ohne Simulation)
- 16 x 16 m Terrain, CPU-Hoehenfeld von 65 x 65 Eck-Samples (25 cm), ein zusammenhaengendes, editierbares Mesh. Kein Chunk-Streaming, Wasser, Personen, Untergrund oder Navigation.
- Nur zwei Materialien (Gras/Moos und offene Erde). Materialgewicht aus Weltkoordinaten; organische Grenze ueber mehrskalige Maske plus farb-/detailbewahrende Texturierung. Kein Wiederholen identischer 32x32-Bildquadrate.
- 6–12 transparente Einzelobjekte (Grasbueschel, Farn, Steine) getrennt vom Terrain. Falls keine freigegebenen Quellassets vorliegen, **Debug-Sprites deutlich als Platzhalter kennzeichnen**.
- Fixe orthografische Kamera mit 45 Grad Neigung als Startwert, alternative 35/55 Grad Vergleichsbilder; gleiche Kamera fuer alle Testfaelle.
- Drei Weltzustandsvarianten aus denselben Eingabedaten: (A) unberuehrte Wiese mit Erdpfad, (B) 1,5 m breite, 0,5 m tiefe Grube, (C) 1 m hoher Huegel. Hoehen- und Materialaenderung muessen sichtbar sein; Texturen bleiben weltverankert.
- Bildausgaben: PNG der Renderpipeline in Originalauflösung und 4x-Nearest-Vorschau; Material-/Hoehen-Debugansicht, Referenz-und-Renderer-Vergleich bei normalisiertem Ausschnitt. Kein erneutes ImageGen fuer die Auswertung.

## Versuchsdesign: drei Renderer statt blindes Feintuning
R0: einfache Farb-/Noise-Materialien als Geometrie-Kontrolle (soll funktionieren, visuelle Qualitaet unwichtig).
R1: Weltkoordinaten-basiertes Texture-Sampling aus freigegebener Quellbildregion mit Makrovariation, organischer Maske, ohne Objekttexturen einzubrennen.
R2: gleiche Geometrie, aber bewusst pixelart-gerechtes Detailverfahren: begrenzte Farbpalette, diskrete Cluster/Nearest und getrennte Pflanzen-Overlays. Kein globaler 'pixelate'-Filter als alleinige Strategie.

WICHTIG: Ein Pixelart-Referenzbild ist keine automatisch saubere Texture-Source. Nur echte saubere Bodenbereiche fuer R1/R2 verwenden; keine Felsen/Blumen versehentlich in repetierende Grundtextur backen. Bei zu wenig Material markieren statt Halluzination oder ungepruefte Lueckenfuellung.

## Mess- und Abnahmeprotokoll
- G1 Reproduzierbar: ein Seed/Parameter-Satz erzeugt dieselben Weltwerte, Render-Konfiguration und Bilder (Hash je Konfiguration dokumentieren).
- G2 Geometrie: A/B/C ueber denselben Renderer; Grube und Huegel veraendern sichtbare Kanten, Occlusion und Schatten richtig.
- G3 Kontinuitaet: keine rechtwinkligen Material-Grenzen, kein UV-Schwimmen beim Editieren, keine ploetzlichen Textur-Stretch-Artefakte.
- G4 Detail: in 1x und typischem Gamezoom mit Referenz vergleichen. Keine prominent wiederholten Blumen/Felsen, keine grossen homogenen Flecken oder chaotisches Pixelrauschen.
- G5 Pixel-Disziplin: kontrollierte Pixelcluster, keine verwaschene Skalierung, konsistente Projektion der Objektfuesse.
- G6 A/B blind beurteilen: Referenz (Ziel), R1, R2 mit identischer Pixelgroesse; notiere je Fall 'erreicht / teilweise / nicht erreicht' mit konkreten Bildregionen, keine pauschale 'sieht gut aus'-Aussage.
- G7 Performance nur grob: Renderzeit und Speicher, aber keine FPS-Zusage vor lauffaehigem Prototyp.

## Stop/Go
Go erst wenn **G2–G5** fuer mindestens einen Renderer erfuellt sind und die Originalatmosphaere bei normalem Zoom **grob erhalten** ist. Wenn nicht: Ursachen auf Materialquelle, Detailmassstab, Perspektive oder Shader eingrenzen. Keine Wasserphysik und keine Asset-Massenproduktion als naechster Schritt.

## Artefakte
`experiments/terrain-rendering-spike/`: kleine Godot-Szene oder reproduzierbares offscreen Render-Skript, Seed/Parameterdatei, Screenshots A/B/C fuer R0/R1/R2, Messprotokoll und side-by-side Vergleich. Ein Prototyp nur als Design-Text besteht das Gate **nicht**.

## Referenz-Luecke
Die im Chat erzeugte vollstaendige Waldszene ist als PNG verfuegbar, aber das Repo fuehrt die freigegebene Referenz bislang nur als **nicht uebertragene Datei**. Sie muss unveraendert als Binaerdatei ins Repo und per SHA-256 geprueft werden; bis dahin ist das visuelle Abnahme-Gate blockiert. Keine alten Tilesheets als neue Masterreferenz deklarieren.
