# Interview-Transkript – Key-Stakeholder: Lehrkraft

- Datum: 2025-11-12
- Teilnehmer:innen: 
  - Interviewer (Requirements Engineer)
  - Lehrkraft (Key-Stakeholder)
- Kontext: Mobile App zur schnellen Protokollierung der Mitarbeit im Unterricht

---

## Einstieg

**Interviewer:** Danke, dass Sie sich Zeit nehmen. Ich möchte verstehen, wie Sie im Unterricht die Mitarbeit erfassen möchten. Können Sie kurz das Ziel beschreiben?

**Lehrkraft:** Ich will die Mitarbeit meiner Schüler schnell und unauffällig direkt im Unterricht protokollieren. Ein kurzer Tap auf das Schüler-Icon zählt als positive Mitarbeit, ein Long-Press öffnet Gründe für negative Mitarbeit (z. B. stört, unvorbereitet, Hausaufgaben vergessen). Es muss sehr schnell gehen, ohne den Unterrichtsfluss zu stören.

---

## Nutzungsszenarien & Workflow

**Interviewer:** In welchen Situationen protokollieren Sie positive Mitarbeit?

**Lehrkraft:** Wenn sich Schüler melden, gute Beiträge liefern, bei Gruppenarbeit konstruktiv sind oder andere unterstützen. Ich möchte dafür nur einmal tippen – maximal 1 Sekunde Interaktion.

**Interviewer:** Und negative Mitarbeit?

**Lehrkraft:** Bei Störungen, Unruhe, Unpünktlichkeit, fehlenden Hausaufgaben. Da brauche ich eine Auswahl mit typischen Gründen. Idealerweise Long-Press auf das Icon → Menü mit den häufigsten Gründen → ein weiterer Tap.

**Interviewer:** Wie starten Sie eine Stunde in der App?

**Lehrkraft:** Ich wähle die Klasse und Stunde aus, dann sehe ich eine Rasteransicht aller Schüler mit großen Touch-Flächen. Optional will ich einen Sitzplan um schneller zu treffen.

**Interviewer:** Brauchen Sie eine Zusammenfassung am Ende?

**Lehrkraft:** Ja, eine kurze Stunden-Zusammenfassung: Anzahl positiver/negativer Punkte, Liste der betroffenen Schüler, optional Kurznotizen. Export als CSV/PDF wäre super – für Notenbuch oder Elterngespräche.

---

## UI/Interaktion

**Interviewer:** Wie soll das Schüler-Grid aussehen?

**Lehrkraft:** Große Kacheln mit Name oder Kürzel, farbliche Markierung (z. B. grün für zuletzt positiv, rot für negativ, neutral grau). Ein Zähler je Schüler wäre hilfreich. Haptisches Feedback bei Tap/Long-Press. Eine Undo-Möglichkeit (z. B. Snackbar „Rückgängig“ 5 Sekunden).

**Interviewer:** Long-Press-Dauer?

**Lehrkraft:** Standard 500 ms passt. Wenn möglich konfigurierbar zwischen 400–700 ms.

**Interviewer:** Brauchen Sie Schnellgründe?

**Lehrkraft:** Ja, 4–6 häufige Gründe direkt wählbar. Außerdem will ich Gründe anpassen und eigene hinzufügen.

**Interviewer:** Benötigen Sie eine Suche?

**Lehrkraft:** Eine Scrollliste reicht meist, aber eine schnelle Suche nach Namen wäre gut für große Klassen.

**Interviewer:** Was ist mit Gewichtung von Punkten?

**Lehrkraft:** Standardmäßig +1 für positiv, −1 für negativ. Optional möchte ich Gewichtungen konfigurieren (z. B. schwere Störung −2). Aber das ist nachrangig fürs MVP.

---

## Klassen- & Sitzplan-Management

**Interviewer:** Wie legen Sie Klassen und Schüler an?

**Lehrkraft:** Manuell reicht zunächst. Später vielleicht Import (CSV) oder aus einem Schulverwaltungssystem. Wichtig: schnelles Hinzufügen/Entfernen, Umbenennen.

**Interviewer:** Sitzplan?

**Lehrkraft:** Sitzplan ist sehr hilfreich. Quadratisches Raster, Schüler zu Positionen ziehen. Für MVP optional, aber ich hätte gern wenigstens eine einfache Reihen/Spalten-Anordnung.

---

## Berichte & Exporte

**Interviewer:** Welche Auswertungen brauchen Sie?

**Lehrkraft:** Pro Stunde, pro Woche und pro Schüler. Trend über Zeit, z. B. Diagramm optional später. Export als CSV für Excel reicht fürs Erste. PDF mit Stundenübersicht wäre nett.

**Interviewer:** Teilen mit Eltern/Schulleitung?

**Lehrkraft:** Nicht automatisch. Bei Bedarf exportiere ich manuell. Keine automatische Schüler-/Eltern-App im MVP.

---

## Datenschutz & Compliance

**Interviewer:** Wie gehen wir mit Datenschutz um?

**Lehrkraft:** DSGVO-konform. Keine Fotos nötig, Kürzel oder Namen genügen. Daten lokal auf meinem Gerät speichern, standardmäßig kein Cloud-Sync. App mit PIN/biometrischem Schutz. Datenhaltung auf das Nötigste beschränken. Löschkonzept: z. B. automatische Löschung nach Schuljahr oder manuell.

**Interviewer:** Cloud-Sync perspektivisch?

**Lehrkraft:** Optional, aber nur mit schulischer Infrastruktur (z. B. Nextcloud/On-Prem) und Verschlüsselung. Für MVP offline-first lokal.

---

## Nicht-funktionale Anforderungen

**Interviewer:** Performance- und Usability-Anforderungen?

**Lehrkraft:** Jede Aktion < 1 Sekunde. Große Touch-Ziele, einhändig bedienbar. Offline zuverlässig. Akkuschonend. Keine Ablenkung: minimale Interaktionsschritte, klare visuelle Bestätigung.

**Interviewer:** Barrierefreiheit?

**Lehrkraft:** Große Schrift/kontrastreicher Modus wünschenswert. VoiceOver/ TalkBack Unterstützung ist gut, aber nicht MVP-kritisch.

---

## Randbedingungen & Technische Präferenzen

**Interviewer:** Zielplattformen?

**Lehrkraft:** iOS und Android. Wenn möglich eine Cross-Platform-Lösung. Kein obligatorisches Login für MVP – nur lokaler Geräteschutz.

**Interviewer:** Integrationen?

**Lehrkraft:** Später vielleicht Notenbuch-/SIS-Integration. Im MVP nicht nötig.

**Interviewer:** Zeitrahmen fürs MVP?

**Lehrkraft:** Schnell nutzbar – wenige Kernfunktionen reichen: Klassen/Schüler-Verwaltung, Raster/Seating, Tap/Long-Press Logging, Undo, Stundenabschluss mit kurzer Übersicht, CSV-Export.

---

## Risiken & Pain Points

**Interviewer:** Was darf auf keinen Fall passieren?

**Lehrkraft:** Fehlbedienungen und doppelte Taps ohne Kontrolle. Datenverlust. Zu viele Schritte pro Aktion. Und ich möchte nicht für jede Stunde viel einrichten müssen.

**Interviewer:** Wie minimieren wir Fehlbedienungen?

**Lehrkraft:** Kurze haptische Bestätigung, deutliche visuelle Rückmeldung, Undo-Funktion, optional ein kurzes Tap-Cooldown (z. B. 300 ms) gegen Doppel-Taps.

---

## Abschluss

**Interviewer:** Zusammengefasst: Fokus auf sehr schnelle, unaufdringliche Bedienung, offline-first, Datenschutz, Undo, Stundenübersicht mit Export. Stimmt das?

**Lehrkraft:** Ja, genau. Wenn das reibungslos läuft, nutze ich es täglich.

---

## Vorläufige MVP-Kernfunktionen (aus dem Gespräch abgeleitet)

1. Klassen- und Schülerverwaltung (manuell)
2. Rasteransicht/optional einfacher Sitzplan
3. Tap = +1 positive Mitarbeit
4. Long-Press = Auswahl häufiger negativer Gründe (konfigurierbar)
5. Visuelles + haptisches Feedback; Undo (5 s)
6. Stundenabschluss: Übersicht, Notizfeld, CSV-Export
7. Lokal, offline-first; App-Sperre (PIN/Biometrie); kein Cloud-Sync im MVP

## Nicht-funktionale MVP-Ziele

- Interaktion < 1 s, UI reaktionsschnell (<100–200 ms visuelle Rückmeldung)
- Große Touch-Ziele; einhändig nutzbar
- Offline robust; geringer Energieverbrauch
- Datenschutz: minimale Daten, keine Fotos, Löschkonzept
