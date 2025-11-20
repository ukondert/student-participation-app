---
description: Create an optimized agent.md file based on GitHub best practices
---

This workflow guides you through creating a high-quality, specialized agent for your project, following the best practices from GitHub's "How to write a great agents.md" guide.

1. **Identify Agent Type**:
   Ask the user what kind of agent they want to build. Suggest the following common types if they are unsure:
   - **Docs Agent**: For writing and updating documentation.
   - **Test Agent**: For writing and running tests.
   - **Lint Agent**: For fixing linting errors and maintaining code style.
   - **API Agent**: For managing API endpoints and integration.
   - **Dev/Deploy Agent**: For build and deployment tasks.

2. **Gather Information**:
   Ask the user for the specific details needed to populate the template. If the user provided a "Theme" or "Type" in step 1, you can suggest defaults for Role and Focus.
   
   **Required Inputs:**
   - **Name**: A short, descriptive name (e.g., `docs-agent`, `test-agent`).
   - **Description**: A one-sentence description.
   - **Role**: The persona (e.g., "Expert technical writer").
   - **Focus**: What the agent specializes in.
   - **Tech Stack**: The technologies and versions (e.g., "React 18, TypeScript, Vite").
   - **Project Structure**: Key directories (e.g., `src/`, `tests/`, `docs/`).
   - **Tools/Commands**: *Crucial!* Ask for the exact commands to build, test, and lint (e.g., `npm run build`, `mvn test`).
   - **Standards**: Naming conventions or specific code style rules.
   - **Boundaries**:
     - **Always**: What must the agent always do?
     - **Ask first**: When should the agent pause for approval?
     - **Never**: What is strictly forbidden (e.g., "Commit secrets")?

3. **Generate Content**:
   Construct the `agent.md` content using the following template. Replace the placeholders with the gathered information.

   ````markdown
   ---
   name: [Name]
   description: [Description]
   ---
   You are an expert [Role] for this project.

   ## Persona
   - You specialize in [Focus]
   - You understand the codebase and translate that into [Output]
   - Your output: [Specific Output] that [Benefit]

   ## Project knowledge
   - **Tech Stack:** [Tech Stack]
   - **File Structure:**
   [Project Structure]

   ## Tools you can use
   [Tools/Commands]

   ## Standards
   Follow these rules for all code you write:
   [Standards]

   ## Boundaries
   - ✅ **Always:** [Always Rules]
   - ⚠️ **Ask first:** [Ask First Rules]
   - 🚫 **Never:** [Never Rules]
   ````

4. **Review and Refine**:
   Present the generated content to the user. Ask if they want to make any changes or if it looks good.

5. **Save File**:
   Once approved, save the file to `.github/agents/[Name].agent.md`.
   - Ensure the directory `.github/agents/` exists.
   - Use the `write_to_file` tool.
