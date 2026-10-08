# Lebendige Welt — Entwicklungsgrundlage v0.1

Stand: 2026-10-08. Eigenständig lebende Welt, Survival und soziale Simulation.

**Dieses Repository enthält Design, Architektur, konkrete Inhaltsdaten und einen
ausführbaren Inhaltsprüfer. Es enthält noch kein spielbares Godot-Projekt und
keine implementierte C#-Simulation.** Die Architektur ist ein begründeter erster
Vorschlag; Änderungen werden über Architecture Decision Records dokumentiert.

## Einstieg

1. [Spielkonzept](docs/game-concept-v02.md): unveränderte beigefügte Grundlage.
2. [Ergänzende Spielregeln](docs/design/game-systems.md): Abgrenzungen und offene Fragen.
3. [Technik](docs/architecture/technical-design.md): Module, Dateien, Datenfluss.
4. [Prozessvertrag](docs/architecture/process-contract.md): Rezepte, Aufträge, Phasen.
5. [Inhalte bearbeiten](docs/content/authoring.md) und [Rezeptkatalog](docs/content/recipe-catalog.md).
6. [Implementierungsstand](docs/project/STATUS.md), [Backlog](docs/project/BACKLOG.md).
7. [Startprompt für Coding-Agenten](docs/project/IMPLEMENTATION_PROMPT.md).

## Direkt ausführbar

Python 3.10 oder neuer, ausschließlich Standardbibliothek:

```sh
python3 tools/validate_content.py
python3 -m unittest discover -s tests/content -v
git log --oneline
```

Unter Windows kann `py -3` statt `python3` verwendet werden. Die beiden Prüfungen
testen Inhaltsstruktur und Referenzen; sie führen keine Spielsimulation aus.
Keine Engineinstallation ist für die Durchsicht dieses Standes erforderlich.

## Repository und Übergabe

Das ZIP enthält das lokale Git-Repository einschließlich `.git` und erstem Commit.
Nach dem Entpacken im Ordner `lebendige-welt` arbeiten. Es gibt noch keinen Remote.
Für einen eigenen leeren Git-Server/GitHub/Gitea-Remote:

```sh
git remote add origin <URL-DES-EIGENEN-REPOSITORIES>
git push -u origin main
```

Kein Hostinganbieter ist Teil der Architektur. Ein späterer privater Remote kann
frei gewählt werden. Es wurde keine Open-Source-Lizenz festgelegt; Veröffentlichung
und Lizenzierung bleiben eine separate Entscheidung.

## Umfang

`content/core` enthält Item-, Rezept-, Wissens-, Arbeitsplatz-, Umwelt-, Workflow-
und Kulturpflanzendefinitionen. Die genaue Zahl wird vom Validator ausgegeben.
Rezepte liegen **einzeln** in thematischen Unterordnern. Arbeitsabläufe verwenden
explizit registrierte Operationen; deren Laufzeitimplementierung ist offen.

Simulation und Darstellung sollen später in `src/` und `game/` entstehen. Die dort
vorhandenen README-Dateien beschreiben die Zuständigkeit und sind keine Stubs mit
vorgetäuschter Spielfunktionalität.
