# Context-Slot Asset Generation Workflow v0.1

**Projekt:** Lebendige Welt — Waldcamp  
**Stand:** 2026-10-09  
**Status:** Experimenteller Produktionsvertrag; für Pilot freigegeben, noch nicht als belastbare Asset-Pipeline validiert  
**Vorgänger:** [Asset-Generation-Workflow v0.1](asset-generation-workflow-v0.1.md)  
**Anforderungen:** [Grafikkonzept v0.3](graphics-concept-v0.3.md) und [Waldcamp-Assetliste](forest-camp-asset-list-v0.1.md)

## 1. Idee und klare Grenzen

Nicht zuerst isolierte Sprites zeichnen. Eine **globale, freigegebene Stilscene** ist verbindlich für Perspektive, Palette, Pixelcluster, Kontrast, Größenrelationen und Beleuchtung. Für jedes Asset wird eine lokale Scene-Kopie mit identifizierbarem **Bodenanker**, passender Weltgröße, Nachbarobjekten und einem **objektspezifischen Insertionsbereich (Context Slot)** vorbereitet. Die KI soll nur die gewünschte Ergänzung gestalten. Dann wird das Ergebnis in ein transparentes Einzelasset extrahiert, technisch aufbereitet und per deterministischer Komposition wieder eingesetzt.

**Wichtig:** „1×1 m“ bezeichnet nur den logischen Boden-Footprint (= 32×32 nominale Terrainpixel); eine kleine Eiche kann eine **größere 128×160-Pixel-Silhouette** und mehr als eine Tilebreite Krone haben. Ein 32×32-Ausschnitt darf daher nicht mit der gesamten Baumgrafik gleichgesetzt werden.

Ein generatives Bildwerkzeug kann trotz Inpainting-Vorgabe Teile des Umfeldes umzeichnen. Die Einhaltung einer Maske ist **nicht garantiert**. Vorher/Nachher-Bilder müssen registriert und außerhalb der erlaubten Zone pixelweise geprüft werden. Erfolgt eine Neuinterpretation der ganzen Szene, ist das ein **Stilvergleich, aber kein sauberer Slot-Insertion-Nachweis**.

## 2. Eingabe je Produktionslauf

| Feld | Beispiel / Regel |
| --- | --- |
| `global_style_reference` | unveränderte genehmigte Waldcamp-Szene; SHA256 im Manifest |
| `style_crop` | 256×256 Weltpixel = 8×8 m lokaler Ausschnitt (sofern echte Weltpixelmaßstäblichkeit gegeben ist) |
| `asset_id` | `tree_oak_small_01`, `campfire_01`, `stump_01`, `villager_a_01` |
| `world_footprint_m` | z. B. 1×1 m |
| `native_canvas_px` | z. B. 128×160 px Eiche; 64×64 px Feuer |
| `anchor_px` | Bodenanker (x,y) im Objekt-Canvas, Pixelkoordinaten |
| `insertion_mask` | transparente/markierte Pixelzone für Objekt, **inklusive Krone** |
| `preserve_mask` | Umgebung, die unverändert bleiben muss |
| `depth_layers` | Grundterrain, Basis/Objekt, Figur, Vordergrund, Effekte |
| `variants` | benötigte Formen/Zustände, z. B. `fire_on` |
| `source_prompt` / `seed` / `tool` | Nachvollziehbarkeit soweit vom Generator verfügbar |

Der Slot ist **objektspezifisch**, nicht einfach ein Quadrat. Neben dem opaken Kern sind weiche/auskragende Konturbereiche für Baumkrone, Zweige, Schatten oder Rauch zulässig, wenn explizit festgelegt. Die Bodenschicht bleibt darunter erhalten und ist keine Freistellmaske.

## 3. Produktionsphasen

### A. Master und lokaler Kontext

1. Originalreferenz und Prüfsumme fixieren (kein Up- oder Downscale vor dem Master-Snapshot).
2. World-Pixelmaßstab **kalibrieren**: Bestätigen, wie viel sichtbare Weltfläche der Bildausschnitt enthält. Ein hübsches 1280×1280-Bild ist ohne Kalibrierung **nicht** automatisch eine 8×8-m-Szene.
3. Passenden Ausschnitt mit genügend Umgebung wählen: Boden, Vegetation, Licht, Figuren als Größenvergleich, aber möglichst wenig Verdeckungen.
4. **Before** als unveränderliche Datei speichern; zusätzlich transparente Maske, Slot-Rechteck, Objektanker und Welt-Footprint.

### B. Gezielte Slot-Insertion

5. Eine Slot-Vorlage aus **Before + Maske** herstellen. Außerhalb des Slots darf nichts semantisch verändert werden.
6. Pro Edit-Aufruf **genau eine Objektklasse** anfordern. Beispiel: „Hier eine junge Eiche, Fußpunkt bei (x,y), stimmig zur Szene; gesamter Baum darf über seine 1×1-m-Wurzelzelle hinausragen, aber nicht über die Silhouettenmaske; gleiche Palette/Neigung; erhalte alle anderen Pixel.“
7. **After** und Prompt/Tooldaten archivieren; bis zu zwei gezielte Korrekturen nur bei klar zuordenbaren Fehlern.
8. Original und Edit ausrichten; Pixelabweichungen außerhalb des Slots messen. Fehlender Pixelidentität ist ein Fehler des strikten Inpainting-Gates, auch wenn das Ergebnis ästhetisch besser aussieht.

### C. Objektorientierte Extraktion

9. Aus der After-Szene **nicht** den ganzen Crop übernehmen: Eiche/Stamm/Krone/Feuer/Figur als Objekt segmentieren, Hintergrundpixel entfernen und Löcher/Verdeckungen gezielt ergänzen.
10. Objekt nach Möglichkeit in separater, zum Edit gehörender Isolationsvariante nachgenerieren; deren Geometrie **muss** zum In-Szene-Objekt passen. Reines Neuzeichnen einer ähnlichen Eiche ist **keine** geometriegetreue Extraktion.
11. In transparente PNG-RGBA mit definiertem Canvas, Padding und Bodenanker ausgeben; Rauch/Flammen/Schatten nach Möglichkeit separate Ebenen.
12. Pixelmaßstab und Perspektive überprüfen, Pixelcluster kontrolliert per nearest-neighbor resampeln bzw. direkt pixelgenau nachbearbeiten. Kein unbemerktes Glätten oder Fantasie über tatsächliche 32-px-Assetauflösung.

### D. Deterministische Rekonstruktion

13. **Original-Bodenplatte**, nicht ein neu erdachtes Terrain, als Hintergrund nutzen (für den isolierten Pilot); später echte Tiles verwenden.
14. Freigestelltes Asset anhand des Bodenankers mit einem **eigenständigen Skript oder Editor** platzieren — keine generative Neumalerei bei der Rekonstruktion.
15. Szenen-Soll und Rekonstruktion in exakt gleicher Perspektive, Größe, Crop und Farbprofil vergleichen.
16. Zusätzliche Reinsert-Position in einer **anderen** lokalen Szene testen, um Hintergrundreste/unnatürliche Schatten sichtbar zu machen.
17. Abweichungen dokumentieren und Asset als `experiment`, `needs_rework`, `qa_passed` oder `approved` kennzeichnen.

## 4. QA-Gates und messbare Kriterien

| Gate | Verfahren | Passkriterium |
| --- | --- | --- |
| I – Input | Referenz-SHA, Crop, Maske, Footprint, Anker | vollständig erfasst |
| M – Maskentreue | Nach Registrierung `abs(Before-After)` außerhalb Insertion-Maske | für **strenge** Slot-Insertion 0 veränderte Pixel; abweichende Bilder gesondert als `unconstrained_edit` deklarieren |
| O – Objekttrennung | RGBA, Alphamaske, Hintergrund-Verschmutzung | isolierte Silhouette und keine dunkle Tafel oder ungewollte Terrainreste |
| S – Skalierung | native Größe und 4×-Nearest-Vorschau | klare Pixelcluster, glaubwürdiger Footprint |
| R – Rekonstruktion | deterministische Komposition, Bilddifferenz/Überlagerung | Position und Perspektive passen; sichtbare Ränder/Lichtbrüche dokumentiert |
| U – Umsetzbarkeit | selbes Asset ein zweites Mal umsetzen | erkennbar wiederverwendbar und nicht ortsgebunden |
| T – Terrain | 8×8-Wiederholung, 16×16-Mischung | kein auffälliger Rand-/Wiederholungsfehler |

**Maskentreue ≠ Extraktionsgüte:** Eine stabile Szene kann trotzdem schlechte Alpha-Sprites ergeben. Ebenso kann ein schöner freigestellter Baum ohne identische Geometrie kein echter Nachweis der Slot-Insertion sein. JPEG- oder Model-Resampling darf nicht als unveränderter Pixelbereich gewertet werden.

## 5. Assetklassenspezifische Grenzen

- **Bäume, Büsche, Felsen, Baumstümpfe:** bevorzugte Kandidaten; Kronen/Äste dürfen über mehrere Tilegrenzen ragen, Anker am Stammfuß.
- **Feuer:** Steinkreis als eigenes Basisobjekt, Flammen/Glut/Rauch als separate Zustands-/Effekt-Ebenen; anfangs statisch.
- **Figur:** vollständige Körper-Silhouette; Front/Back/Links/Rechts sind später konsistente Variationen **derselben Figur**. Animationsfamilien kommen erst nach Grundkörperfreigabe.
- **Terrain:** nicht ungeprüft per Szenencrop extrahieren. Nahtloses 32×32-Gras, Waldboden, Wasser und Ufermasken benötigen explizite Randbedingungen, manuelle/prozedurale Optimierung und Kacheltests.

## 6. Pilotlauf v0.1 – vier Assetklassen

Reihenfolge: **kleine Eiche, Lagerfeuer, Baumstumpf, stehende Person**. Erste Runde darf am wichtigsten und am zuverlässigsten kontrollierbaren Objekt beginnen. Jeden Status einzeln dokumentieren.

Für **jede** geprüfte Klasse werden soweit möglich diese Artefakte erzeugt:

```text
pilot/<asset_id>/
  input_scene.png
  slot_mask.png
  edit_after.png
  isolation_rgba.png
  reinsert_native.png
  reinsert_4x_nearest.png
  alternate_location.png
  measurements.json
```

Zusätzlich zentral:
- `reference_master.png` (exakter verwendeter Stilausschnitt oder referenziertes Original)
- `comparison_contact_sheet.png`: Master / Slotvorlage / generierter Edit / Alpha / Reinsert
- `REPORT.md` mit Gate-Status, erkennbaren Fehlerbildern und Empfehlung.

**Erlaubter Fallback bei Toolbeschränkungen:** Ein aus dem Original ausgeschnittener Gegenstand mit kontrollierter Maske ist ein **Extraktions-Baseline-Test**, aber keine erfolgreich generierte Slot-Insertion. Ein komplett neugeneriertes Wald-Bild ist **nur** ein Kontext-/Stiltest. Beides nicht als erfolgreichen M-Gate verbuchen.

## 7. Fortschritt / Stop-Regeln

Nach der ersten Eiche bereits auswerten: Wenn kein identischer Bildkontext erhalten bleibt oder die Objektextraktion nicht sauber gelingt, **nicht** blind weitere 69 Assets herstellen. Alternativ A/B-Vergleich `isoliertes Asset` vs. `szenegeführtes Editing` oder direkt kontrolliert pixelgenau nachzeichnen. Ergebnisse und Grenzen als Testbericht dokumentieren.

**Erfolg dieses Pilots:** klar dokumentierte echte PNG-Objekte und mindestens eine wiederverwendbare deterministische Mini-Rekonstruktion. **Kein Erfolg** ist eine allein bildgenerierte schöne Szene ohne freigestellte Objekte, Anker und Reinsert-Nachweis.

## 8. Abgrenzung zum Spiel

Kein Gameplay, keine Kollision, keine Animation, keine AI-Agenten, keine Simulation, keine Godot-Laufzeit. Erst nach Grafikanerkennung und belastbaren Asset-Tests wird der Umfang der eigentlichen Produktionspipeline entschieden.
