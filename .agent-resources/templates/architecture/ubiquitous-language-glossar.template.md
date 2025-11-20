# Ubiquitous Language / Glossar

Kurzbeschreibung
-----------------
Dieses Dokument ist die zentrale, von allen Projektbeteiligten genutzte Quelle für die offizielle Terminologie (Ubiquitous Language). Es enthält Begriffsdefinitionen, Angaben zu Bounded Contexts, Code‑Repräsentationen, Owner und Pflegehinweise.

> Wichtig: Änderungen nur per Pull Request mit Review durch einen Domänenexperten. Dieses Dokument liegt versioniert im Repository.

## Versionshistorie
| Datum | Version | Autor | Kommentar |
|---|---:|---|---|
| {{YYYY-MM-DD}} | 0.1 | {{INITIALEN}} | Erstfassung aus Software-Architect Chatmode |

---

## Verwendungshinweise
- **Single Source of Truth**: Diese Datei ist die offizielle Quelle für Projektbegriffe.
- Jede in Code oder Dokumentation neu eingeführte Fachbezeichnung soll mit einem Glossar‑Eintrag versehen werden (PR → Review).
- **Owner**: Jedes Glossar‑Item hat eine verantwortliche Person oder Team.
- **Status**: `draft / review / accepted / deprecated`.

---

## Template für einen Begriff
Nutze für neue Begriffe das folgende Mini‑Template (kopiere einen Block pro Begriff):

### Begriff: \<Term\>
- **Definition**: \<kurze, präzise Definition in Alltagssprache\>
- **Bounded Context**: \<z. B. {{context_name}}\>
- **Rolle im System**: \<Aggregate Root | Entity | Value Object | Service | Domain Event | sonstiges\>
- **Synonyme / Verwechslungsgefahr**: \<andere Begriffe und Hinweise\>
- **Beispiel(e)**: \<konkrete Sätze oder Code‑Snippets\>
- **Repräsentation im Code**: \<z. B. Klasse `ClassName`, DB‑Tabelle `table_name`\>
- **Owner**: \<Name / Team\>
- **Status**: \<draft/review/accepted/deprecated\>
- **Letzte Änderung**: YYYY‑MM‑DD
- **Referenzen**: \<User Story IDs, Diagramme, Dateien\>

---

## Nomen (Substantive) - Kandidaten für Aggregate, Entitäten, Value Objects

{{Für jedes identifizierte Nomen aus Phase 1.1 des Software-Architect Chatmodes}}

### Begriff: {{Nomen}}
- **Definition**: {{Definition basierend auf User Stories und Domänenverständnis}}
- **Bounded Context**: {{Zugeordneter Bounded Context}}
- **Rolle im System**: {{Aggregate Root | Entity | Value Object}}
- **Synonyme / Verwechslungsgefahr**: {{Falls vorhanden}}
- **Beispiel(e)**: {{Beispielsatz aus User Story oder Code}}
- **Repräsentation im Code**: {{z.B. class `{{Nomen}}`, DB-Tabelle `{{nomen_lowercase}}`}}
- **Owner**: {{Team/Person}}
- **Status**: draft
- **Letzte Änderung**: {{YYYY-MM-DD}}
- **Referenzen**: {{User Story IDs}}

---

## Verben (Aktionen) - Kandidaten für Methoden und Domain Services

{{Für jedes identifizierte Verb aus Phase 1.1 des Software-Architect Chatmodes}}

### Begriff: {{Verb}}
- **Definition**: {{Definition der Aktion/des Prozesses}}
- **Bounded Context**: {{Zugeordneter Bounded Context}}
- **Rolle im System**: {{Methode von Aggregat X | Domain Service}}
- **Synonyme / Verwechslungsgefahr**: {{Falls vorhanden}}
- **Beispiel(e)**: {{z.B. `aggregat.{{verb}}(parameter)`}}
- **Repräsentation im Code**: {{z.B. Methode `{{verb}}()` in Klasse `{{Aggregat}}`}}
- **Owner**: {{Team/Person}}
- **Status**: draft
- **Letzte Änderung**: {{YYYY-MM-DD}}
- **Referenzen**: {{User Story IDs}}

---

## Geschäftsregeln & Invarianten

{{Für jede identifizierte Geschäftsregel aus Phase 1.1}}

### Regel: {{Regelname}}
- **Definition**: {{Beschreibung der Regel}}
- **Bounded Context**: {{Zugeordneter Bounded Context}}
- **Betroffene Aggregate**: {{Liste der Aggregate}}
- **Implementierung**: {{Wo wird die Regel durchgesetzt}}
- **Beispiel(e)**: {{Konkretes Beispiel}}
- **Owner**: {{Team/Person}}
- **Status**: draft
- **Letzte Änderung**: {{YYYY-MM-DD}}
- **Referenzen**: {{User Story IDs, Acceptance Criteria}}

---

## Domain Events

{{Für jedes identifizierte Domain Event}}

### Event: {{EventName}}
- **Definition**: {{Was ist passiert}}
- **Bounded Context**: {{Wo wird es ausgelöst}}
- **Auslöser**: {{Welches Aggregat/Welcher Service}}
- **Payload**: {{Welche Daten werden übertragen}}
- **Subscriber**: {{Wer reagiert darauf}}
- **Beispiel(e)**: {{z.B. `FahrtAngeboten(fahrtId, anbieterId, zeitpunkt)`}}
- **Repräsentation im Code**: {{Event-Klasse}}
- **Owner**: {{Team/Person}}
- **Status**: draft
- **Letzte Änderung**: {{YYYY-MM-DD}}
- **Referenzen**: {{User Story IDs}}

---

## CSV / Excel‑Export (Empfehlung)
Für nicht‑technische Stakeholder kann das Glossar als CSV/Excel bereitgestellt werden. Empfohlene Spalten:

`Term,Definition,BoundedContext,Role,Synonyms,Example,CodeRepresentation,Owner,Status,LastUpdated,References`

---

## JSON‑Export (Tooling)
Wenn du Tooling oder CI‑Checks nutzen willst, lege zusätzlich eine maschinenlesbare Datei `glossary.json` mit ähnlicher Struktur an (Term‑Array mit Feldern wie oben). Dadurch lassen sich automatisierte Prüfungen und Generierung realisieren.

**Beispielstruktur:**
```json
{
  "version": "1.0",
  "lastUpdated": "{{YYYY-MM-DD}}",
  "terms": [
    {
      "term": "{{Begriff}}",
      "definition": "{{Definition}}",
      "boundedContext": "{{Context}}",
      "role": "{{Aggregate Root|Entity|Value Object|Service|Event}}",
      "synonyms": [],
      "examples": [],
      "codeRepresentation": "{{Klassenname}}",
      "owner": "{{Team}}",
      "status": "{{draft|review|accepted|deprecated}}",
      "lastChanged": "{{YYYY-MM-DD}}",
      "references": ["{{US-001}}", "{{US-002}}"]
    }
  ]
}
```

---

## Governance & Best Practices (Kurzcheckliste)

- ✅ **Owner festlegen**: Für jeden neuen Begriff eine verantwortliche Person/Team benennen.
- ✅ **Definition of Done**: Glossar‑Updates sind Teil der DoD für Features mit neuen Begriffen.
- ✅ **Review-Pflicht**: Domänenexperten müssen Glossar-Updates reviewen (PR mit Label `glossary-update`).
- ✅ **Code-Beispiele**: Kurze Code‑Snippets zeigen, wie Begriffe im Code repräsentiert werden.
- ✅ **Status-Tags**: Nutze `draft / review / accepted / deprecated` und halte Änderungsdatum aktuell.
- ✅ **Bounded Context Zuordnung**: Jeder Begriff muss einem oder mehreren Contexts zugeordnet sein.
- ✅ **Konsistenz prüfen**: Bei Context-übergreifenden Begriffen auf unterschiedliche Bedeutungen achten.
- ✅ **Versionierung**: Änderungshistorie pflegen für Nachvollziehbarkeit.

---

## Hilfe & Unterstützung

Bei Fragen zur Pflege des Glossars:
- **Domain Owner**: {{Name/Team für fachliche Fragen}}
- **Tech Lead**: {{Name für technische Repräsentation}}
- **Prozess**: Siehe `.github/chatmodes/software-architect.chatmode.md` Phase 1.1

---

**Letzte Aktualisierung dieses Templates**: {{YYYY-MM-DD}}
