# Seed instructions (from `patterns/` and `setup/` folders)

Purpose  
Provide a concise, repeatable process to seed data and project setup using the repository folders `patterns/` and `setup/`. These instructions assume template files are plain-text formats commonly used in repos (JSON, YAML, or .md documentation files).

## Assumptions
- Project root contains `patterns/` and `setup/` folders.
- Seed runners read templates from `patterns/` and use `setup/` for configuration and execution.

## Typical folder layout that should be read before processing
ai/toolkit/
    - patterns/
        - clean-architecture.md
        - constant-sizes.md
        - dart-patterns.md
        - eager-provider-initialization.md
        - enhanced-enums.md
        - error-handling.md
        - public-constructor-arguments.md
        - router.md
        - widget-classes-no-build-helpers.md
    - setup/
        - add-external-pkg.md
        - flutter-project-structure.md
    - breaking/
        - dart.md
        - flutter.md
        - riverpod.md
    - aliases/
        - dart.md
    - commands/
        - git-commit.md   
        - make-plan.md    
        - common-initial-setup.md 