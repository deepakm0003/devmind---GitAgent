# devmind Memory

> This file is the living memory of devmind's understanding of this project.
> Do not edit manually. Managed by devmind. Last updated: 2025-11-01T12:00:00Z

## Interview Complete
Date: 2025-11-01T12:00:00Z
Interviewed by: devmind interview-project skill v1.0.0

### Core Problem
The RealWorld project is a demo blogging platform API (like Medium.com) that shows real-world backend patterns — user auth, articles, comments, and other common features.

### Users and Use Patterns
Developers use it as a reference implementation. They clone it, study the folder structure, run tests, and copy patterns into their own projects.

### Architecture Decisions
- NX monorepo was chosen for scalability but never documented.
- TypeScript strict mode is on but no style guide exists.
- JWT is used for auth.

### Anti-Patterns (never do these)
- NEVER: Putting business logic directly in route handlers instead of keeping it in service classes.
- NEVER: Bypassing the repository pattern by querying the database directly from controllers.

### Current Priority
Add a rate limiting middleware to prevent API abuse. It's urgent because the project is being used as a public demo and needs to be protected from abuse.

### Failed Experiments
- Swagger auto-generation was tried but abandoned because the decorators cluttered the controllers.
- A custom middleware auth approach was attempted but dropped in favor of a more standardized JWT strategy.

### Definition of Done
All RealWorld spec endpoints work, tests pass, code is clean enough to learn from, and a new developer can clone and run it in under 5 minutes.

## Memory Log
- 2025-11-01T12:00:00Z Interview conducted. 7 of 7 questions answered.