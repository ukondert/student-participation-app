# Value Object Design Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Tactical Design Pattern  
> **Ebene:** Domain Layer

---

## 🎯 Ziel

Repräsentieren ein **unveränderliches, bedeutungsvolles Konzept** ohne eigene Identität (z. B. `Email`, `Money`, `Address`).

---

## 📋 Prinzipien

* **Immutability**: Keine Setter. Änderungen → neues Objekt.
* **Always valid**: Kein ungültiger Zustand erlaubt.
* **Equality by value**: `equals()` & `hashCode()` basieren auf Attributen.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **VOs validieren sich selbst** | Validierung erfolgt im Konstruktor oder in einer Factory. |
| **Annotations an DTOs, nicht am VO** | Bean Validation (`@Email`, `@NotNull`) in DTOs; VO prüft Invarianten selbst. |
| **Optional Integration** | VO kann zusätzlich eigene `ConstraintValidator`s für DTO-Validierung bereitstellen. |

---

## 💻 Beispiel (Java)

```java
public record Email(String value) {
    public Email {
        if (value == null || !value.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
            throw new IllegalArgumentException("Invalid email: " + value);
    }
    public static Email of(String value) { return new Email(value); }
}
```

---

## 🤖 KI-Agent Hinweise

* Erstelle VO-Klassen **immer unveränderlich**.
* Füge **automatische Validierung** im Konstruktor hinzu.
* Vermeide Bean Validation **direkt** im VO, außer explizit erlaubt.

---

## 📌 Checkliste

- [ ] Konstruktor ist `private` oder validiert
- [ ] Factory Method `of()` oder `create()` vorhanden
- [ ] Alle Felder sind `final`/`readonly`
- [ ] Validierung im Konstruktor (vor Zuweisung)
- [ ] `equals()` vergleicht alle Attribute
- [ ] Keine Setter (nur Getter)
- [ ] Bei Änderung: Neues VO erstellen (Copy-on-Write)

---

## ⚠️ Anti-Patterns vermeiden

❌ **Public Setter**
```java
// FALSCH
email.setValue("new@email.com")  // Mutiert Objekt
```

✅ **Neues VO erstellen**
```java
// RICHTIG
email = Email.of("new@email.com")  // Unveränderlich
```

❌ **Validierung außerhalb**
```java
// FALSCH
if (isValidEmail(emailString)) {
  email = new Email(emailString)  // Zu spät!
}
```

✅ **Validierung im VO**
```java
// RICHTIG
email = Email.of(emailString)  // Wirft Exception bei Fehler
```

---

## 🔗 Referenzen

- Projekt-Beispiele: `docs/architecture/agregates-entites-value_obj.md`
- DDD Blue Book (Eric Evans)
- Implementing DDD (Vaughn Vernon)
