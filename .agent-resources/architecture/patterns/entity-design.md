# Entity Design Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Tactical Design Pattern  
> **Ebene:** Domain Layer

---

## 🎯 Ziel

Repräsentieren **fachliche Objekte mit Identität** (z. B. `User`, `Order`).

---

## 📋 Prinzipien

* **Identität = dauerhafte Referenz** (z. B. UUID).
* **Equals basiert auf ID**, nicht auf Werten.
* **Mutationen nur über Methoden, die Invarianten wahren.**

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **ID ist unveränderlich** | UUID oder andere eindeutige ID wird bei Erstellung gesetzt - siehe `uuid-best-practice.md`|
| **Keine öffentlichen Setter** | Zustandsänderungen nur über benannte Methoden (z.B. `changeEmail()`). |
| **Invarianten-Prüfung** | Jede Mutation validiert Geschäftsregeln. |
| **Equals basiert auf ID** | Zwei Entities sind gleich, wenn ihre IDs übereinstimmen. |

---

## 💻 Beispiel (Java)

```java
public class User {
    private final UUID id;
    private Email email;

    public User(UUID id, Email email) {
        this.id = Objects.requireNonNull(id);
        changeEmail(email);
    }

    public void changeEmail(Email newEmail) {
        if (newEmail.equals(this.email)) return;
        this.email = Objects.requireNonNull(newEmail);
        // Domain Event: UserEmailChanged
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User user)) return false;
        return id.equals(user.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
```

---

## 🤖 KI-Agent Hinweise

* Prüfe immer auf Invarianten bei Mutationen.
* Keine öffentlichen Setter generieren.
* Nur Factories oder Aggregate dürfen Entities direkt erzeugen.
* `equals()` und `hashCode()` nur auf Basis der ID implementieren.

---

## 📌 Checkliste

- [ ] ID ist `final` und wird im Konstruktor gesetzt
- [ ] `equals()` vergleicht nur die ID
- [ ] `hashCode()` basiert nur auf der ID
- [ ] Keine öffentlichen Setter für kritische Attribute
- [ ] Mutationen über benannte Methoden mit Invarianten-Prüfung
- [ ] Optionale Domain Events bei Zustandsänderungen

---

## ⚠️ Anti-Patterns vermeiden

❌ **Öffentliche Setter**
```java
// FALSCH
user.setEmail(newEmail);  // Keine Validierung, keine Events
```

✅ **Benannte Methode**
```java
// RICHTIG
user.changeEmail(newEmail);  // Validierung + Event
```

❌ **Equals auf Attributen**
```java
// FALSCH
return email.equals(other.email);  // Entity-Identität ist ID!
```

✅ **Equals auf ID**
```java
// RICHTIG
return id.equals(other.id);
```

---

## 🔗 Referenzen

- Related Patterns: `aggregate-design.md`, `value-object-design.md`
