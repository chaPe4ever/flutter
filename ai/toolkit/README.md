# Flutter AI Toolkit

A collection of AI-powered commands and patterns to enhance your Flutter development experience.

## Motivation

Building Flutter applications can be complex and time-consuming. The Flutter AI Toolkit aims to simplify this process by providing developers with AI-driven tools and commands that streamline common tasks, improve code quality, and boost productivity.

AI agents understand the context of your Flutter projects and can assist with code generation, debugging, optimization, and more.

This toolkit was designed to make AI assistance accessible and effective for Flutter developers of all skill levels.

## Usage

Add this repository as a submodule to your existing project:

```zsh
git submodule add https://github.com/chaPe4ever/flutter.git ai/toolkit
cd ai/toolkit
git sparse-checkout init --cone
git sparse-checkout set ai/toolkit
git checkout
```
```

Then, back in the superproject, you can update the submodule to get the latest changes:

```zsh
git submodule update --remote --merge ai/toolkit
```


## What's Inside

### Aliases

- Dart aliases: `aliases/dart.md`

### Breaking Changes Guides

- Dart language: `breaking/dart.md`
- Flutter framework: `breaking/flutter.md`
- Riverpod state management: `breaking/riverpod.md`

### Commands

- Seed instructions: `commands/seed-instructions.md`
- Make Github PR: `commands/make-github-pr.md`

### Patterns

- Absolute imports: `patterns/absolute-imports.md`
- Clean Architecture: `patterns/clean-architecture.md`
- Enhanced enums: `patterns/enhanced-enums.md`
- Constant sizes: `patterns/constant-sizes.md`
- Error handling: `patterns/error-handling.md`
- Eager provider initialization: `patterns/eager-provider-initialization.md`
- Public constructor arguments: `patterns/public-constructor-arguments.md`
- Dart Patterns: `patterns/dart-patterns.md`

### Project Setup

- Flutter project structure: `setup/flutter-project-structure.md`
- Add external packages to the project: `setup/add-external-pkg.md`
- Setup spacing constants: `setup/spacing-constants.md`