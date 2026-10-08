# ADR 0001 — Godot, C# und eigenständiger Core
Status: vorgeschlagene Ausgangsentscheidung, 2026-10-08.

Kontext: 2D-Pixelwelt mit langfristig tiefer Simulation und vielen UI-Inspektoren.
Entscheidung: Godot 4 .NET für Darstellung; C#-Core ohne Engineabhängigkeit.
Folge: Headless-Langläufe und getrennte Tests möglich; mehr explizite Übergaben
zwischen Welt und Darstellung. Toolchainversion folgt in T01.
Alternativen: Rust/Bevy bei ausdrücklicher Rust-Präferenz; zusätzliche Sprache
für einzelne Engpässe erst nach Messung. Kein Browserexport im Zielumfang.
