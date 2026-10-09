# Context-Slot-Pilot v0.1 – Waldcamp: kleine Eiche

**Stand:** 2026-10-09  
**Workflow:** [Context-Slot Asset Generation Workflow v0.1](context-slot-asset-generation-workflow-v0.1.md)  
**Status:** Experiment durchgeführt; **kein erfolgreicher KI-Inpainting-Nachweis und keine Produktionsfreigabe**.

## Ziel

Auf Basis einer globalen Waldcamp-Stilscene eine kleine Eiche mit größerem Bildrahmen als ihrem logischen 1×1-m-Boden-Footprint herstellen, als eigenständiges transparentes PNG isolieren und anschließend an definierter Stelle sowie einer alternativen Position **mechanisch** in eine Szenenkopie einsetzen.

## Versuchsdesign

- Master: bereits erzeugtes Originalbild `pixel_art_camp_im_wald.png`.
- Lokaler Kontext: 512×512-Pixel-Crop aus dem Master, Pixelkoordinaten `(500,330,1012,842)`.
- Assetklasse: `tree_oak_small_01`, logischer Wurzelfootprint konzeptionell 1×1 m.
- Objekt-Canvas: 128×160 Pixel, Fußanker `(64,158)`.
- Slot: Rechteck entsprechend dem tatsächlichen Objekt-Canvas; **nicht** 32×32 Pixel, da dies nur die nominale 1-m-Bodenfläche beschreibt.
- **Skalierungsvorbehalt:** Die zugrunde liegende KI-Szene hat keine nachgewiesene Abbildung von Pixeln auf Weltmeter. Der 512px-Crop ist darum ausdrücklich **keine** verifizierte 16×16-m- oder 8×8-m-Szene.

## Was tatsächlich gelang

1. Ein zuvor generiertes kontextorientiertes Asset-Sheet wurde erneut als Quelle genutzt; die daraus bereits vorläufig freigestellte Eiche wurde per Alpha und zusammenhängender Objektmaske bereinigt (entfernter isolierter Bildrest).
2. Ein echtes, separates RGBA-Baumsprite auf 128×160-Pixel-Canvas wurde exportiert; zusätzlich eine direkt generierte Vergleichsversion.
3. Ein reproduzierbares Pillow-Skript setzte die Eiche in den originalen lokalen Szene-Crop ein, nicht durch Neugenerierung der Szene.
4. **Außerhalb der Slotbox: 0 RGB-Pixel geändert**. Das ist aufgrund des deterministischen Alpha-Compositings zu erwarten und **kein** Beleg für die Maskentreue eines Bildgenerators.
5. Erneutes Einsetzen desselben gespeicherten Sprites am ursprünglichen Anker lieferte ein **pixelidentisches** PNG. Eine zweite Position wurde ebenfalls getestet.

## Was nicht gelang

Zwei Versuche, den Bildgenerator zur gezielten lokalen Eichen-Generierung zu veranlassen, produzierten stattdessen allgemeine Infografiken des Produktionsprozesses. Ein echter generativer `before → mask → local after`-Durchlauf ist daher **nicht vorhanden**. Der eingesetzte Baum stammt aus einem zuvor erzeugten kontextgeführten **Asset-Sheet**, **nicht** aus einer validierten KI-Insertion in die markierte Lücke.

Die Transparenz basiert auf einer nur angenäherten Freistellung vor dunklem Hintergrund; Halos und Stil-/Lichtartefakte bleiben möglich. Ebenso sind die native Pixelgenauigkeit und ein tatsächlicher Maßstab von 32 px/m noch nicht validiert.

## QA-Status

| Gate | Status |
| --- | --- |
| Input / definiertes Slot-Canvas / Anker | PASS |
| Generativer lokaler Inpainting-Schritt mit Bildkonstanz | **FAIL / nicht nachgewiesen** |
| Freigestellte RGBA-Eiche | PROVISORISCH |
| Weltmaßstab und native Pixelstruktur | NICHT VERIFIZIERT |
| Deterministische Rekonstruktion | PASS |
| Wiederverwendung in anderer Szene-Position | TECHNISCH PASS, visuelle Abnahme offen |
| Nahtlose Terrain-Tiles | NICHT GETESTET |

## Experiment-Dateien

Das zugehörige Gesprächs-Artefakt `Waldcamp_ContextSlot_Pilot_v01.zip` enthält die verwendeten Bildquellen, `run_pilot.py`, die beiden PNG-Sprites, Slot-Maske, Original-Crop, Insertionen, Reinsertions, `pilot_comparison_6panel.png`, `measurements.json`, `checksums.json` und den ausführlichen lokalen `REPORT.md`. Diese Bild- und Binärartefakte sind mit diesem Markdown-Commit **nicht automatisch im Repository enthalten**.

## Ergebnis / nächste Entscheidung

**Die mechanische Hälfte des Workflows funktioniert**: Es gibt ein tatsächlich transparentes Einzelobjekt, das definiert platziert und erneut verwendet werden kann. **Die eigentliche Hypothese der kontextuellen Slot-Inpainting-Erzeugung ist offen**. Dafür braucht der nächste Test einen Bild-Editor mit explizit übergebener Maske und unverändertem Master, bei dem die Umgebung außerhalb des freigegebenen Bereichs überprüfbar konstant bleibt.

Keine Godot-, KI-Simulations-, Gameplay- oder sonstige Spielfunktion implementiert.
