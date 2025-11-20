# Story Map – Mitarbeit-App (Lehrkraft)

Datum: 2025-11-12
Key-Stakeholder: Lehrkraft

---

## Workflow-Phasen (MVP gekennzeichnet)
1. Prepare Class (MVP)
2. Start Lesson (MVP)
3. Record Participation (MVP)
4. Review & Adjust (MVP)
5. Close & Export (MVP)
6. Secure & Maintain (MVP)

---

## Feature-Priorisierung (gesamt)

### Must-Have
- Klassen/Schüler manuell verwalten (CRUD) und Klasse für Stunde wählen
- Tap positiv: kurzer Tap = +1
- Long-Press negativ: Gründe-Auswahl (Default-Liste, 4–6 Schnellgründe)
- Punktgewichtung konfigurierbar (Standard +1/−1, z. B. −2 schwere Störung)
- Haptisches/visuelles Feedback; Undo (~5 s)
- Stundenstart/-ende: Session starten, Abschlussübersicht, Kurznotiz
- CSV-Export (pro Stunde)
- Lokale Speicherung, offline-first
- App-Sperre via PIN/Biometrie
- Farb-/Statusanzeige und Zähler pro Schüler

### Should-Have
- Suche nach Schülernamen
- Gründe/Schnellgründe verwalten (anpassen/ergänzen)
- Tap-Cooldown gegen Doppeltaps
- Long-Press-Dauer konfigurierbar (z. B. 400–700 ms)
- Datenlebenszyklus: manuelles/periodisches Löschen (z. B. pro Schuljahr)
- CSV-Export nach Zeitraum/Schüler

### Could-Have (Nicht-MVP)
- Sitzplan (Reihen/Spalten, Drag & Drop)
- PDF-Export, Diagramme/Trends
- CSV-Import, SIS/Notenbuch-Integrationen
- Cloud-Sync (on-prem, verschlüsselt)
- Erweiterte Barrierefreiheit (Screenreader-Optimierung)

---

## Story-Map-Tabelle

| Workflow-Phase    | MVP | Must-Have                                                                                 | Should-Have                                                       | Could-Have                           |
|-------------------|:---:|--------------------------------------------------------------------------------------------|-------------------------------------------------------------------|--------------------------------------|
| Prepare Class     |  ✓  | Klassen/Schüler CRUD; Punktgewichtung einstellen; App-Sperre aktivieren                   | Gründe/Schnellgründe pflegen; Long-Press-Dauer; Datenlöschung     | Sitzplan; CSV-Import; Integrationen  |
| Start Lesson      |  ✓  | Klasse auswählen und Stunde starten                                                        | Schnellsuche nach Schülern                                        | —                                    |
| Record Participation | ✓ | Tap = +1; Long-Press Gründe; Gewichtung anwenden; hapt./visuelles Feedback; Undo          | Tap-Cooldown                                                       | —                                    |
| Review & Adjust   |  ✓  | Zähler/Status pro Schüler sichtbar                                                         | Schnelle Korrektur/Anpassung einzelner Einträge                    | Trends/Diagramme                     |
| Close & Export    |  ✓  | Stundenabschluss: Übersicht + Kurznotiz; CSV-Export (Stunde)                               | CSV-Export nach Zeitraum/Schüler                                   | PDF-Export                           |
| Secure & Maintain |  ✓  | Lokale Datenhaltung; App-Sperre beim Wiederöffnen                                          | Periodische Löschregeln                                            | Cloud-Sync                           |

---

Hinweise
- MVP-Phasen enthalten jeweils mindestens ein Must-Have-Feature.
- Datenschutz: minimale Daten, keine Fotos, offline-first; Erweiterungen (Sync/Integrationen) nur nach DSGVO-Prüfung.
- Performance: Reaktionszeit auf Interaktion < 200 ms, jede Aktion < 1 s.
