# ADR 0002 — Definitionen als JSON, Verhalten als typisierte Operationen
Status: vorgeschlagene Ausgangsentscheidung, 2026-10-08.

Einzelne Rezepte in thematischen Verzeichnissen, getrennte Workflows und laufende
Jobs. Geschlossene Schemata; IDs statt Dateipfade als Referenzen. JSON ist diffbar
und direkt validierbar. Kein frei ausführbarer Code in Inhaltsdateien.
Nachteil: neues Verhalten braucht C#-Code plus Datenvertrag; das ist beabsichtigt.
Kein generisches Modding- oder universelles Prozessframework vor dem Prototyp.
