# Validierung — 2026-10-08

Ausgeführt in der Erstellungsumgebung mit Python 3; keine externen Pythonpakete.

```sh
python3 tools/validate_content.py --catalog
python3 -m unittest discover -s tests/content -v
```

Ergebnis: Inhaltsprüfung bestanden; 10 von 10 Regressionstests bestanden.

| Definition | Zahl |
|---|---:|
| Gegenstandstypen | 107 |
| Rezepte | 68 |
| Wissensdefinitionen | 68 |
| Arbeitsabläufe | 14 |
| Arbeitsplatztypen | 12 |
| Umweltprofile | 14 |
| Kulturpflanzen | 2 |
| Szenariofixtures | 1 |
| Inhalts-Packs | 1 |
| Operations-Registries | 1 |

Geprüft: geschlossene Datenstrukturen, IDs, Referenzen, positive Mengen und Zeiten,
diskrete Stückzahlen, Werkzeugfähigkeiten, Workflow-Operationen, Pausenbedingungen
und optimistische Erreichbarkeit von Produktionsketten aus deklarierten Quellen.

Die Tests provozieren unbekannte Items/Operationen, doppelte IDs, negative Mengen,
unbekannte Felder, halbe Werkzeugstücke, fehlende Pausenlimits, fehlende Erzquellen
und unbekannte Schema-Keywords. Der unveränderte Ausgangsbestand muss gültig sein.

**Nicht geprüft:** lauffähiges Gameplay, C#-Build, Godot-Start, Mengenbuchführung zur
Laufzeit, Save/Load, Versorgung über zehn Spieltage, historische Verfahrenstreue,
Massen-/Energiebilanz oder Performance. Dafür gibt es in diesem Stand keinen Code.
