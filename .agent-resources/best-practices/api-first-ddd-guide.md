# 💻 API-First Development mit Domain-Driven Design - Vollständiger Workflow-Guide

Dieser Guide beschreibt den **vollständigen Workflow** für die iterative Implementierung von User Stories unter Verwendung des **API-First Ansatzes** mit **Domain-Driven Design** und **Hexagonal Architecture**.

---

## 🎯 Zielsetzung

1. **API-First Development:** REST-APIs vor der Implementierung mit OpenAPI spezifizieren
2. **Domain-Driven Design:** Implementierung folgt der definierten Domain-Architektur
3. **Clean Architecture:** Trennung von Domain, Application, Infrastructure und Interface Layer
4. **Test-Driven Development:** Tests werden parallel zur Implementierung geschrieben
5. **Iterative Entwicklung:** Eine User Story nach der anderen umsetzen

---

## 📋 Voraussetzungen

Stelle sicher, dass folgende Artefakte vorhanden sind:

- ✅ Refined User Stories in `docs/requirements/user-stories/refined/`
- ✅ Domain Models in `docs/architecture/domain-models/`
- ✅ Bounded Contexts in `docs/architecture/bounded-contexts-overview.md`
- ✅ Aggregates/Entities/Value Objects in `docs/architecture/aggregates-entities-valueobjects.md`
- ✅ Architecture Decisions in `docs/architecture/architecture-decisions.md`
- ✅ Ubiquitous Language Glossar in `docs/architecture/ubiquitous-language-glossar.md`

---

## 🔄 Workflow: User Story → Implementation

### Phase 1: Story Selection & Analysis

**Step 1.1: User Story auswählen**

```prompt
Wähle die nächste umzusetzende User Story aus docs/requirements/user-stories/refined/:

- Priorisierung: MVP > Must-Have > Should-Have > Nice-to-Have
- Abhängigkeiten: Stories mit wenigen Dependencies zuerst
- Bounded Context: Gruppiere Stories nach Bounded Context

Zeige:
- User Story ID & Titel
- Epic & Bounded Context
- Priorität & Story Points
- Abhängigkeiten zu anderen Stories
```

**Step 1.2: Story analysieren**

Analysiere die ausgewählte User Story:

1. **Akzeptanzkriterien** durchgehen
2. **Gherkin-Szenarien** identifizieren
3. **Betroffene Bounded Contexts** ermitteln
4. **Aggregates & Entities** aus Domain Model referenzieren
5. **Business Rules** aus Ubiquitous Language extrahieren

**Output:** Story Analysis Document
```markdown
# Story Analysis: [US-ID] [Titel]

## Bounded Context
- Primary: [Context Name]
- Secondary: [Context Name] (optional)

## Betroffene Aggregates
- [Aggregate Root 1]: [Beschreibung]
- [Aggregate Root 2]: [Beschreibung]

## Business Rules
1. [Rule aus Glossar]
2. [Rule aus Glossar]

## Domain Events
- [Event Name]: Wann ausgelöst?
- [Event Name]: Wann ausgelöst?

## Externe Dependencies
- [Service/System]: Wofür?
```

---

### Phase 2: API-First Design

**Step 2.1: OpenAPI Specification erstellen**

Erstelle/erweitere die OpenAPI Spec für die Story:

```prompt
Erstelle eine OpenAPI 3.0 Spezifikation für [User Story]:

Datei: api/openapi/[bounded-context].yaml

Berücksichtige:
1. RESTful Design Principles
2. Resource Naming (aus Ubiquitous Language)
3. HTTP Methods (GET, POST, PUT, PATCH, DELETE)
4. Request/Response Schemas
5. Error Responses (4xx, 5xx)
6. Authentication & Authorization (Bearer Token)
7. Pagination für Listen
8. Filtering & Sorting
9. HATEOAS Links (optional)

Verwende Schemas aus:
- docs/architecture/aggregates-entities-valueobjects.md
- docs/architecture/ubiquitous-language-glossar.md
```

**Template:** `api/openapi/[bounded-context].yaml`

```yaml
openapi: 3.0.3
info:
  title: [Bounded Context] API
  description: API für [Bounded Context Beschreibung]
  version: 1.0.0
  contact:
    name: Development Team
    email: dev@school-rideshare.com

servers:
  - url: http://localhost:3000/api/v1
    description: Development Server
  - url: https://api.school-rideshare.com/v1
    description: Production Server

tags:
  - name: [Resource]
    description: [Resource Beschreibung]

paths:
  /[resource]:
    get:
      summary: Liste alle [Resources]
      tags: [Resource]
      parameters:
        - $ref: '#/components/parameters/PageParam'
        - $ref: '#/components/parameters/LimitParam'
      responses:
        '200':
          description: Erfolgreiche Antwort
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/[Resource]ListResponse'
    post:
      summary: Erstelle neue [Resource]
      tags: [Resource]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Create[Resource]Request'
      responses:
        '201':
          description: [Resource] erstellt
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'

components:
  schemas:
    [Resource]:
      type: object
      required:
        - id
        - [requiredField]
      properties:
        id:
          type: string
          format: uuid
          description: Eindeutige ID
        [field]:
          type: string
          description: [Beschreibung]
  
  responses:
    BadRequest:
      description: Ungültige Anfrage
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    
    Unauthorized:
      description: Nicht authentifiziert
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

  parameters:
    PageParam:
      name: page
      in: query
      description: Seitennummer (1-basiert)
      schema:
        type: integer
        minimum: 1
        default: 1
    
    LimitParam:
      name: limit
      in: query
      description: Anzahl Elemente pro Seite
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 20

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - BearerAuth: []
```

**Step 2.2: API Review**

```prompt
Überprüfe die OpenAPI Spec gegen:

1. ✅ Naming Conventions (aus Ubiquitous Language)
2. ✅ RESTful Best Practices
3. ✅ Vollständigkeit aller Akzeptanzkriterien
4. ✅ Error Handling
5. ✅ Security (Authentication/Authorization)
6. ✅ Pagination & Filtering
7. ✅ Documentation Quality
8. ✅ Schema Validations

Erstelle Review-Checklist und dokumentiere Findings.
```

**Step 2.3: Mock Server starten**

```bash
# Mit Prism Mock Server
npx @stoplight/prism-cli mock api/openapi/[bounded-context].yaml

# Oder mit Swagger UI
docker run -p 8080:8080 -e SWAGGER_JSON=/openapi.yaml -v $(pwd)/api/openapi:/api swaggerapi/swagger-ui
```

**Step 2.4: API Contract Tests schreiben**

Erstelle Contract Tests mit Dredd oder Pact:

```javascript
// tests/contract/[resource].contract.test.ts
import Dredd from 'dredd';

describe('API Contract Tests: [Resource]', () => {
  it('should comply with OpenAPI specification', (done) => {
    const dredd = new Dredd({
      endpoint: 'http://localhost:3000',
      path: ['api/openapi/[bounded-context].yaml']
    });
    
    dredd.run((err, stats) => {
      expect(stats.failures).toBe(0);
      done();
    });
  });
});
```

---

### Phase 3: Domain Layer Implementation

**Step 3.1: Value Objects implementieren**

Basierend auf `docs/architecture/agregates-entites-value_obj.md`:

```typescript
// src/domain/[bounded-context]/value-objects/[ValueObject].ts

export class [ValueObject] {
  private readonly _value: [Type];

  private constructor(value: [Type]) {
    this._value = value;
  }

  public static create(value: [Type]): Result<[ValueObject]> {
    // Validation
    if (![validation]) {
      return Result.fail<[ValueObject]>('[Error Message]');
    }
    
    return Result.ok<[ValueObject]>(new [ValueObject](value));
  }

  get value(): [Type] {
    return this._value;
  }

  public equals(other: [ValueObject]): boolean {
    return this._value === other._value;
  }
}
```

**Step 3.2: Entities implementieren**

```typescript
// src/domain/[bounded-context]/entities/[Entity].ts

export class [Entity] extends Entity<[EntityProps]> {
  
  private constructor(props: [EntityProps], id?: UniqueEntityID) {
    super(props, id);
  }

  public static create(props: [EntityProps], id?: UniqueEntityID): Result<[Entity]> {
    // Business Rule Validation
    const guardResult = Guard.againstNullOrUndefinedBulk([
      { argument: props.[field], argumentName: '[field]' },
    ]);

    if (!guardResult.succeeded) {
      return Result.fail<[Entity]>(guardResult.message);
    }

    const [entity] = new [Entity](props, id);
    
    return Result.ok<[Entity]>([entity]);
  }

  // Getters
  get [field](): [Type] {
    return this.props.[field];
  }

  // Business Methods
  public [method]([params]): Result<void> {
    // Business Logic
    if (![businessRule]) {
      return Result.fail('[Business Rule Violation]');
    }
    
    // Apply changes
    this.props.[field] = [newValue];
    
    // Domain Event
    this.addDomainEvent(new [DomainEvent]({
      aggregateId: this.id,
      [eventData]: [value]
    }));
    
    return Result.ok();
  }
}
```

**Step 3.3: Aggregate Root implementieren**

```typescript
// src/domain/[bounded-context]/aggregates/[AggregateRoot].ts

export class [AggregateRoot] extends AggregateRoot<[AggregateProps]> {
  
  private constructor(props: [AggregateProps], id?: UniqueEntityID) {
    super(props, id);
  }

  public static create(props: [AggregateProps], id?: UniqueEntityID): Result<[AggregateRoot]> {
    // Invariant Validation
    // ...
    
    const aggregate = new [AggregateRoot](props, id);
    
    // Domain Event für Create
    aggregate.addDomainEvent(new [Created]Event({
      aggregateId: aggregate.id
    }));
    
    return Result.ok<[AggregateRoot]>(aggregate);
  }

  // Business Methods orchestrieren Entities
  public [aggregateMethod]([params]): Result<void> {
    // 1. Validate business rules
    // 2. Orchestrate entities
    // 3. Emit domain events
    // 4. Return result
  }
}
```

**Step 3.4: Domain Services implementieren**

```typescript
// src/domain/[bounded-context]/services/[DomainService].ts

export class [DomainService] {
  
  // Multi-aggregate operations
  public [operation](
    [aggregate1]: [Aggregate1],
    [aggregate2]: [Aggregate2]
  ): Result<void> {
    // Cross-aggregate business logic
    
    return Result.ok();
  }
}
```

**Step 3.5: Domain Events definieren**

```typescript
// src/domain/[bounded-context]/events/[DomainEvent].ts

export class [DomainEvent] extends DomainEvent {
  public readonly [field]: [Type];

  constructor(data: { aggregateId: UniqueEntityID; [field]: [Type] }) {
    super(data.aggregateId);
    this.[field] = data.[field];
  }

  getAggregateId(): UniqueEntityID {
    return this.aggregateId;
  }
}
```

---

### Phase 4: Application Layer Implementation

**Step 4.1: DTOs erstellen**

Aus OpenAPI Schema generieren:

```typescript
// src/application/[bounded-context]/dtos/[Resource]DTO.ts

export interface [Resource]DTO {
  id: string;
  [field]: [Type];
  createdAt: string;
  updatedAt: string;
}

export interface Create[Resource]DTO {
  [field]: [Type];
}

export interface Update[Resource]DTO {
  [field]?: [Type];
}
```

**Step 4.2: Mapper erstellen**

```typescript
// src/application/[bounded-context]/mappers/[Resource]Mapper.ts

export class [Resource]Mapper {
  
  public static toDTO([domain]: [DomainModel]): [Resource]DTO {
    return {
      id: [domain].id.toString(),
      [field]: [domain].[field].value,
      createdAt: [domain].createdAt.toISOString(),
      updatedAt: [domain].updatedAt.toISOString()
    };
  }

  public static toDomain(raw: any): [DomainModel] {
    const [valueObject] = [ValueObject].create(raw.[field]);
    
    return [DomainModel].create({
      [field]: [valueObject].getValue()
    }, new UniqueEntityID(raw.id));
  }

  public static toPersistence([domain]: [DomainModel]): any {
    return {
      id: [domain].id.toString(),
      [field]: [domain].[field].value
    };
  }
}
```

**Step 4.3: Use Cases implementieren**

```typescript
// src/application/[bounded-context]/use-cases/[UseCase]/[UseCase].ts

export class [UseCase]UseCase implements UseCase<[Request]DTO, Result<[Response]DTO>> {
  
  private [repository]: I[Repository];
  private [domainService]?: [DomainService];

  constructor(
    [repository]: I[Repository],
    [domainService]?: [DomainService]
  ) {
    this.[repository] = [repository];
    this.[domainService] = [domainService];
  }

  public async execute(request: [Request]DTO): Promise<Result<[Response]DTO>> {
    try {
      // 1. Input Validation
      const validationResult = this.validateRequest(request);
      if (!validationResult.succeeded) {
        return Result.fail(validationResult.message);
      }

      // 2. Load Aggregate(s)
      const [aggregate] = await this.[repository].findById(request.id);
      if (![aggregate]) {
        return Result.fail('Not found');
      }

      // 3. Execute Business Logic
      const [result] = [aggregate].[method](request.[param]);
      if (![result].succeeded) {
        return Result.fail([result].error);
      }

      // 4. Persist Changes
      await this.[repository].save([aggregate]);

      // 5. Publish Domain Events
      await DomainEvents.dispatchEventsForAggregate([aggregate].id);

      // 6. Return Response
      return Result.ok([Mapper].toDTO([aggregate]));
      
    } catch (err) {
      return Result.fail(err.message);
    }
  }

  private validateRequest(request: [Request]DTO): Result<void> {
    // Validation logic
    return Result.ok();
  }
}
```

---

### Phase 5: Infrastructure Layer Implementation

**Step 5.1: Repository implementieren**

```typescript
// src/infrastructure/[bounded-context]/repositories/[Repository].ts

export class [Repository] implements I[Repository] {
  
  private models: any; // Sequelize/TypeORM/Prisma models

  constructor(models: any) {
    this.models = models;
  }

  public async save([aggregate]: [Aggregate]): Promise<void> {
    const raw = [Mapper].toPersistence([aggregate]);
    await this.models.[Model].upsert(raw);
  }

  public async findById(id: string): Promise<[Aggregate] | null> {
    const raw = await this.models.[Model].findByPk(id);
    if (!raw) return null;
    
    return [Mapper].toDomain(raw);
  }

  public async findAll(filters?: any): Promise<[Aggregate][]> {
    const results = await this.models.[Model].findAll({
      where: filters
    });
    
    return results.map([Mapper].toDomain);
  }

  public async delete(id: string): Promise<void> {
    await this.models.[Model].destroy({ where: { id } });
  }
}
```

**Step 5.2: External Services/Adapters**

```typescript
// src/infrastructure/services/[ExternalService]Adapter.ts

export class [ExternalService]Adapter implements I[ExternalService] {
  
  private client: [ClientLibrary];

  constructor(config: [Config]) {
    this.client = new [ClientLibrary](config);
  }

  public async [method]([params]): Promise<Result<[Response]>> {
    try {
      const response = await this.client.[apiMethod]([params]);
      return Result.ok(response);
    } catch (err) {
      return Result.fail(err.message);
    }
  }
}
```

**Step 5.3: Event Handlers**

```typescript
// src/infrastructure/[bounded-context]/subscribers/[EventHandler].ts

export class [EventHandler] implements IHandle<[DomainEvent]> {
  
  private [service]: [Service];

  constructor([service]: [Service]) {
    this.[service] = [service];
  }

  setupSubscriptions(): void {
    DomainEvents.register(
      this.on[Event].bind(this),
      [DomainEvent].name
    );
  }

  private async on[Event](event: [DomainEvent]): Promise<void> {
    // Handle event
    await this.[service].[method](event.[data]);
  }
}
```

---

### Phase 6: Interface Layer Implementation

**Step 6.1: REST Controller implementieren**

```typescript
// src/interface/http/controllers/[bounded-context]/[Resource]Controller.ts

export class [Resource]Controller {
  
  private [useCase]: [UseCase]UseCase;

  constructor([useCase]: [UseCase]UseCase) {
    this.[useCase] = [useCase];
  }

  public async [action](req: Request, res: Response): Promise<Response> {
    try {
      const dto = req.body as [Request]DTO;
      
      const result = await this.[useCase].execute(dto);
      
      if (result.isFailure) {
        return res.status(400).json({
          error: result.error
        });
      }
      
      return res.status(200).json(result.getValue());
      
    } catch (err) {
      return res.status(500).json({
        error: 'Internal server error'
      });
    }
  }
}
```

**Step 6.2: Routes definieren**

```typescript
// src/interface/http/routes/[bounded-context]/[resource].routes.ts

const router = express.Router();

const [controller] = new [Resource]Controller([useCase]);

router.get('/[resource]', [controller].[list].bind([controller]));
router.get('/[resource]/:id', [controller].[get].bind([controller]));
router.post('/[resource]', [controller].[create].bind([controller]));
router.put('/[resource]/:id', [controller].[update].bind([controller]));
router.delete('/[resource]/:id', [controller].[delete].bind([controller]));

export default router;
```

**Step 6.3: Middleware**

```typescript
// src/interface/http/middleware/authentication.ts
export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  // JWT verification
};

// src/interface/http/middleware/authorization.ts
export const authorize = (roles: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    // Role-based access control
  };
};

// src/interface/http/middleware/validation.ts
export const validate = (schema: OpenAPISchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    // OpenAPI schema validation
  };
};
```

---

### Phase 7: Testing

**Step 7.1: Unit Tests (Domain Layer)**

```typescript
// tests/unit/domain/[bounded-context]/[Aggregate].spec.ts

describe('[Aggregate]', () => {
  describe('create', () => {
    it('should create valid aggregate', () => {
      const result = [Aggregate].create({
        [field]: [validValue]
      });
      
      expect(result.isSuccess).toBe(true);
    });

    it('should fail with invalid data', () => {
      const result = [Aggregate].create({
        [field]: [invalidValue]
      });
      
      expect(result.isFailure).toBe(true);
    });
  });

  describe('[method]', () => {
    it('should apply business rule correctly', () => {
      // Arrange
      const aggregate = [Aggregate].create({...}).getValue();
      
      // Act
      const result = aggregate.[method]([params]);
      
      // Assert
      expect(result.isSuccess).toBe(true);
      expect(aggregate.[field]).toBe([expectedValue]);
    });

    it('should emit domain event', () => {
      // Test domain event emission
    });
  });
});
```

**Step 7.2: Integration Tests (Application Layer)**

```typescript
// tests/integration/application/[UseCase].spec.ts

describe('[UseCase]UseCase', () => {
  let useCase: [UseCase]UseCase;
  let repository: I[Repository];

  beforeEach(() => {
    repository = new InMemory[Repository]();
    useCase = new [UseCase]UseCase(repository);
  });

  it('should execute use case successfully', async () => {
    const request = {
      [field]: [value]
    };

    const result = await useCase.execute(request);

    expect(result.isSuccess).toBe(true);
  });
});
```

**Step 7.3: E2E Tests (API)**

```typescript
// tests/e2e/[resource].e2e.spec.ts

describe('[Resource] API', () => {
  let app: Express;

  beforeAll(async () => {
    app = await createApp();
  });

  describe('POST /api/v1/[resource]', () => {
    it('should create new resource', async () => {
      const response = await request(app)
        .post('/api/v1/[resource]')
        .set('Authorization', `Bearer ${token}`)
        .send({
          [field]: [value]
        });

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('id');
    });

    it('should validate against OpenAPI schema', async () => {
      // Schema validation test
    });
  });
});
```

**Step 7.4: Gherkin/BDD Tests**

```gherkin
# tests/features/[story].feature

Feature: [Story Title]

  Scenario: [Acceptance Criterion 1]
    Given [precondition]
    When [action]
    Then [expected result]
    And [additional expectation]

  Scenario: [Acceptance Criterion 2]
    Given [precondition]
    When [action]
    Then [expected result]
```

```typescript
// tests/steps/[story].steps.ts
import { Given, When, Then } from '@cucumber/cucumber';

Given('[precondition]', async () => {
  // Setup
});

When('[action]', async () => {
  // Execute
});

Then('[expected result]', async () => {
  // Assert
});
```

---

### Phase 8: Documentation & Review

**Step 8.1: Code Documentation**

```typescript
/**
 * [UseCase]UseCase
 * 
 * Implements the business logic for [Story Title].
 * 
 * Business Rules:
 * - [Rule 1 from Ubiquitous Language]
 * - [Rule 2 from Ubiquitous Language]
 * 
 * Domain Events:
 * - [Event 1]: Triggered when [condition]
 * 
 * @see docs/requirements/user-stories/refined/[story].md
 * @see docs/architecture/domain-models/[bounded-context].puml
 */
export class [UseCase]UseCase { }
```

**Step 8.2: API Documentation**

Generiere aus OpenAPI:
```bash
npx @redocly/cli build-docs api/openapi/[bounded-context].yaml -o docs/api/[bounded-context].html
```

**Step 8.3: Architecture Decision Record (ADR)**

Wenn wichtige Design-Entscheidungen getroffen wurden:

```markdown
# ADR-[NR]: [Title]

## Status
Accepted / Proposed / Deprecated

## Context
[Warum wurde diese Entscheidung nötig?]

## Decision
[Was wurde entschieden?]

## Consequences
Positive:
- [Pro 1]

Negative:
- [Con 1]

## Alternatives Considered
- [Alternative 1]: [Warum verworfen?]
```

**Step 8.4: Story Review Checklist**

```markdown
# Story Review: [US-ID]

## Implementation
- [ ] Alle Akzeptanzkriterien erfüllt
- [ ] Gherkin-Szenarien als Tests implementiert
- [ ] Business Rules korrekt umgesetzt
- [ ] Domain Events emittiert

## Code Quality
- [ ] Domain Layer: Business Logic isoliert
- [ ] Application Layer: Use Cases orchestrieren
- [ ] Infrastructure: Technical Details gekapselt
- [ ] Interface Layer: REST API konform zu OpenAPI

## Testing
- [ ] Unit Tests: >80% Coverage (Domain)
- [ ] Integration Tests: Use Cases
- [ ] E2E Tests: API Endpoints
- [ ] Contract Tests: OpenAPI Compliance

## Documentation
- [ ] Code Comments (komplexe Business Logic)
- [ ] OpenAPI Spec aktualisiert
- [ ] ADR erstellt (falls nötig)
- [ ] README aktualisiert

## Architecture
- [ ] Hexagonal Architecture eingehalten
- [ ] DDD Patterns korrekt angewendet
- [ ] Bounded Context Grenzen respektiert
- [ ] Ubiquitous Language verwendet

## Security
- [ ] Authentication implementiert
- [ ] Authorization (RBAC) implementiert
- [ ] Input Validation
- [ ] Error Messages (keine sensiblen Infos)
```

---

## 🎓 Best Practices

### API-First Development

1. **OpenAPI Spec ZUERST schreiben**
   - Diskutiere API Design mit Team/Stakeholder
   - Nutze Mock Server für Frontend-Entwicklung parallel
   - Validiere gegen RESTful Principles

2. **Contract Tests**
   - API muss mit Spec übereinstimmen
   - Breaking Changes vermeiden
   - Versionierung bei inkompatiblen Änderungen

3. **Documentation as Code**
   - OpenAPI ist Single Source of Truth
   - Auto-Generate Client SDKs
   - Auto-Generate API Docs

### Domain-Driven Design

1. **Ubiquitous Language verwenden**
   - Code spiegelt fachliche Begriffe wider
   - Variablen, Klassen, Methoden aus Glossar
   - Keine technischen Begriffe in Domain Layer

2. **Bounded Context Grenzen respektieren**
   - Kein direkter Zugriff zwischen Contexts
   - Kommunikation über Domain Events oder Anti-Corruption Layer
   - Context Map beachten

3. **Aggregates richtig designen**
   - Aggregate = Transaktionsgrenze
   - Nur Aggregate Root nach außen exponieren
   - Invarianten innerhalb Aggregate sicherstellen

### Clean Architecture

1. **Dependency Rule**
   - Domain Layer: Keine Dependencies
   - Application Layer: Nur Domain
   - Infrastructure: Domain + Application
   - Interface: Domain + Application

2. **Ports & Adapters**
   - Interfaces in Application Layer
   - Implementierungen in Infrastructure
   - Dependency Injection verwenden

### Testing Strategy

1. **Test Pyramid**
   - Viele Unit Tests (Domain Logic)
   - Mittelviele Integration Tests (Use Cases)
   - Wenige E2E Tests (Happy Paths)

2. **BDD mit Gherkin**
   - Akzeptanzkriterien → Feature Files
   - Shared Understanding mit Stakeholder
   - Living Documentation

---

## 📦 Recommended Tech Stack

### Backend
- **Language:** TypeScript / Node.js
- **Framework:** Express.js / NestJS / Fastify
- **ORM:** TypeORM / Prisma / Sequelize
- **Validation:** Joi / Zod / class-validator
- **Authentication:** Passport.js / JWT
- **Testing:** Jest / Vitest + Supertest
- **API Docs:** Swagger UI / ReDoc
- **Contract Testing:** Dredd / Pact

### Architecture
- **Pattern:** Hexagonal Architecture (Ports & Adapters)
- **DDD Library:** (Optional) ddd-toolkit / node-ddd
- **Event Bus:** EventEmitter / RabbitMQ / Kafka
- **DI Container:** tsyringe / InversifyJS / awilix

### Database
- **SQL:** PostgreSQL / MySQL
- **Migrations:** TypeORM Migrations / Knex / Prisma Migrate
- **Seeding:** Für Development/Testing

### DevOps
- **Containerization:** Docker + Docker Compose
- **CI/CD:** GitHub Actions / GitLab CI
- **Linting:** ESLint + Prettier
- **Git Hooks:** Husky + lint-staged

---

## 🔄 Iteration Loop

Nach jeder implementierten Story:

1. **Demo** mit Stakeholder (zeige funktionierende API)
2. **Retrospektive:** Was lief gut? Was verbessern?
3. **Refactoring:** Technical Debt reduzieren
4. **Dokumentation:** ADRs, README, API Docs aktualisieren
5. **Nächste Story:** Zurück zu Phase 1

---

## 📚 Referenzen

### Architektur-Dokumentation
- `docs/architecture/bounded-contexts-overview.md`
- `docs/architecture/domain-categorization.md`
- `docs/architecture/agregates-entites-value_obj.md`
- `docs/architecture/architecture-decisions.md`
- `docs/architecture/domain-models/*.puml`

### User Stories
- `docs/requirements/user-stories/refined/*.md`

### Best Practices
- `.agent-resources/best-practices/ddd.best-practices.md`
- `.agent-resources/best-practices/user-stories2tasks.best-practices.md`

### Templates
- `.agent-resources/templates/` (für neue Dokumente)

### Patterns
- `.agent-resources/architecture/patterns/*.md`
- `.agent-resources/architecture/layers/*.md`

---

**Version:** 1.0.0  
**Letzte Aktualisierung:** 12. November 2025  
**Maintainer:** Development Team
