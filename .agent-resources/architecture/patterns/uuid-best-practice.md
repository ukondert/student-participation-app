# 🧭 UUID als Primary Key – Best Practices

*(DDD, Java, JPA/Hibernate – KI-Agent Optimiert)*

---

## 🧩 Meta

| Feld           | Wert                                                                                                                                                                      |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Titel**      | UUID als Primary Key – Best Practices                                                                                                                                     |
| **Version**    | 1.0                                                                                                                                                                       |
| **Zielgruppe** | KI-Agenten, Entwicklungsassistenten, Java-/DDD-Teams                                                                                                                      |
| **Ziele**      | - Deterministische Regeln und Rezepte für UUIDs als PK<br>- Automatisierbare Entscheidungen nach DB/Dialekt/Workload<br>- Sichere Defaults und klare Performance-Optionen |

---

## ⚙️ Decision Matrix

### Wann UUIDs als Primary Key?

* Verteilte Systeme, Microservices, Offline-First
* Entities benötigen ID vor Persistenz (z. B. DDD Aggregate Roots)
* Event Sourcing, CQRS, asynchrone Workflows

### Wann besser numerische PKs?

* Monolithische, zentralisierte DB mit sehr hohem Insert-Durchsatz
* Analytische Systeme, die kleine Indizes bevorzugen

---

## 🧱 Defaults

| Einstellung         | Wert                                                               |
| ------------------- | ------------------------------------------------------------------ |
| **UUID-Version**    | v4 (random)                                                        |
| **Java-Typ**        | `java.util.UUID`                                                   |
| **JPA-Generierung** | `@GeneratedValue` (Hibernate) oder manuell via `UUID.randomUUID()` |

### Datenbank-Speicherung

| Datenbank     | Typ                          | Empfehlung                |
| ------------- | ---------------------------- | ------------------------- |
| PostgreSQL    | `UUID`                       | ✅ nativ, performant       |
| SQL Server    | `uniqueidentifier`           | ✅ nativ                   |
| MySQL/MariaDB | `BINARY(16)` oder `CHAR(36)` | ⚠️ `BINARY(16)` bevorzugt |
| Oracle        | `RAW(16)`                    | ⚙️ kein nativer Typ       |
| SQLite        | `TEXT(36)`                   | ✅ textbasiert             |

---

## ☕ Java/JPA Rezepte

### 1️⃣ Automatische UUID-Erzeugung (Hibernate)

```java
import jakarta.persistence.*;
import java.util.UUID;

@Entity
public class User {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false, unique = true)
    private String email;

    protected User() {} // JPA

    public User(String email) { this.email = email; }

    public UUID getId() { return id; }
    public String getEmail() { return email; }
}
```

---

### 2️⃣ Manuelle UUID-Erzeugung (DDD Factory)

```java
import jakarta.persistence.*;
import java.util.UUID;

@Entity
public class Order {
    @Id
    private UUID id;

    protected Order() {}

    private Order(UUID id) { this.id = id; }

    public static Order createNew() {
        return new Order(UUID.randomUUID());
    }

    public UUID getId() { return id; }
}
```

---

### 3️⃣ COMB-/uuid2-Variante (sortierbar)

```java
import org.hibernate.annotations.GenericGenerator;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(generator = "uuid2")
    @GenericGenerator(name = "uuid2", strategy = "uuid2")
    @Column(columnDefinition = "BINARY(16)")
    private UUID id;

    protected Invoice() {}
}
```

---

## 🗃️ Hibernate Mapping Tipps

| DB                | DDL-Beispiel                      | Hinweise                                         |
| ----------------- | --------------------------------- | ------------------------------------------------ |
| **PostgreSQL**    | `id UUID PRIMARY KEY`             | Nutze native UUID-Unterstützung                  |
| **MySQL/MariaDB** | `id BINARY(16) PRIMARY KEY`       | Bevorzuge `BINARY(16)` statt `CHAR(36)`          |
| **SQL Server**    | `id uniqueidentifier PRIMARY KEY` | Verwende `NEWSEQUENTIALID()` bei Clustered Index |
| **Oracle**        | `id RAW(16) PRIMARY KEY`          | Standard-Lösung ohne nativen Typ                 |

---

## ⚡ Performance

### Mögliche Probleme

* Zufällige v4 UUIDs verursachen **Index-Fragmentierung**
* Größere Indizes, Page-Splits bei hohem Insert-Throughput

### Gegenmaßnahmen

* Sortierbare Varianten verwenden: `uuid2`, `COMB`, `UUIDv1`, `ULID`, `KSUID`
* Clustered Index anpassen
* Regelmäßig reindizieren
* Batch-Inserts bei hoher Last

### Alternativen

| Typ       | Beschreibung                                  |
| --------- | --------------------------------------------- |
| **ULID**  | Sortierbar, 26 Zeichen Base32, gut lesbar     |
| **KSUID** | Sortierbar, 160 Bit, sehr kollisionsresistent |

---

## 🧭 DDD Guidelines

### Entity Identity

* UUID als Primärschlüssel für **Aggregate Roots**
* IDs in der **Domain** erzeugen, nicht durch die DB

### Repository Contracts

* Repositories speichern **nur Aggregate Roots**
* Methoden: `save()`, `findById(UUID)`

### Domain Events

* Enthalten immer die **UUID** der Aggregate Root
* Serialisierungsformat (JSON/Avro) stabil halten

---

## 🧪 Testing

| Typ                  | Zweck                                | Beispiele                           |
| -------------------- | ------------------------------------ | ----------------------------------- |
| **Unit Test**        | UUID-Erzeugung, Parsing, Validierung | feste Seeds, deterministische UUIDs |
| **Integration Test** | DB-Mapping & Performance             | UUID vs. BINARY vs. RAW(16)         |
| **Load Test**        | Insert/Index-Verhalten               | Messung Insert-Rate & Latenz        |

---

## 🔒 Security & Privacy

* UUID v4 ist **nicht erratbar**, aber **kein Geheimnis**
* Niemals sensible Daten in UUIDs kodieren
* Public APIs: UUID ≠ Authentifizierung
* Access Control immer separat prüfen

---

## 🔁 Migration

### Von numerischen IDs auf UUID

1. Neue Spalte `uuid` hinzufügen
2. Werte auffüllen (`UUID.randomUUID()` oder deterministisch)
3. Anwendung auf neue IDs umstellen
4. Alte IDs entfernen oder als Fremdschlüssel behalten

### Komposite Keys

* **Vermeiden** → stattdessen UUID als Surrogate Key
* Eindeutigkeit über **Unique Constraints** erzwingen

---

## 🧠 Agent Prompts (KI-Automation)

### 🔹 Entity-Generierung

```
Aufgabe: Erzeuge eine JPA-Entity mit UUID als Primary Key.
Anforderungen:
- Feldtyp java.util.UUID
- @Id und @GeneratedValue (oder manuelle Vergabe)
- Dialekt-optimierte @Column-Definition (z. B. BINARY(16) für MySQL)
- Keine Setter für ID
Ausgabe: Vollständige Java-Klasse.
```

---

### 🔹 Repository Review

```
Aufgabe: Prüfe ein Repository-Interface für UUID-IDs.
Checkliste:
- findById(UUID), save(…)
- Keine Domain-Logik im Repository
- Paging/Sorting bei Listen-Endpunkten
```

---

### 🔹 PK-Strategie-Auswahl

```
Aufgabe: Wähle eine PK-Strategie.
Eingaben: DB-Dialekt, Insert-Rate, Verteilung (mono vs. verteilt), DDD-Anforderungen.
Regeln:
- Verteilte Systeme → UUID/ULID
- PostgreSQL/SQL Server → native UUID-Typ bevorzugen
- MySQL → BINARY(16) und COMB/uuid2 bei hohem Insert-Volumen
```

---

## ✅ Fazit

| Szenario                              | Empfehlung                      |
| ------------------------------------- | ------------------------------- |
| DDD, Microservices, verteilte Systeme | ✅ UUID (v4 oder uuid2)          |
| Klassische Monolithen                 | ⚙️ Sequence oder Auto-Increment |
| Performance-kritische Systeme         | 🧩 COMB/TimeUUID/ULID           |
| PostgreSQL, SQL Server                | ✅ native UUID-Typen             |
| MySQL                                 | ⚠️ `BINARY(16)` bevorzugen      |


