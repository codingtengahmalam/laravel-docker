# Repository Guidelines

This repository hosts a Laravel 12 + Livewire stack with a Vite/Tailwind frontend and Docker-based tooling. Follow the practices below to keep contributions predictable and easy to review.

## Project Structure & Module Organization
- `app/` holds HTTP controllers, Livewire components, and domain services; prefer feature-focused subfolders.
- Frontend source lives in `resources/js` and `resources/views`; compiled assets go to `public/`.
- Routes are defined in `routes/web.php` and `routes/api.php`; queue/jobs reside under `app/Jobs`.
- Database migrations, factories, and seeders live in `database/`; automated tests in `tests/` (Pest feature/unit suites).
- Docker specs are under `docker/` with the entry stack described in `docker-compose.yml`.

## Build, Test, and Development Commands
- `composer setup` — end-to-end bootstrap: installs Composer/NPM deps, seeds `.env`, runs migrations, and builds assets.
- `composer dev` — launches the local stack (artisan server, queue worker, pail logs, Vite) via `concurrently`.
- `npm run dev` / `npm run build` — start Vite in watch mode or produce production assets.
- `php artisan serve` + `npm run dev` — lightweight alternative when you only need HTTP + assets.
- `docker compose up -d` — bring up the containerized stack; pair with `docker compose down` when done.

## Coding Style & Naming Conventions
- PHP code must follow PSR-12; run `./vendor/bin/pint` before opening a PR.
- Blade/Volt files use two-space indentation; JavaScript and Vue/Svelte components under `resources/js` follow ES Modules with camelCase filenames.
- Use descriptive class names (`UserInvitationController`) and snake_case database columns.
- Environment variables live in `.env`; never commit secrets.

## Testing Guidelines
- We use Pest (`./vendor/bin/pest` or `php artisan test`) with Feature and Unit suites stored under `tests/Feature` and `tests/Unit`.
- Name tests after behavior, e.g. `it_updates_the_profile_photo`.
- Clear and rebuild config before suites when adding stateful tests: `php artisan config:clear`.
- Aim to cover new branches/endpoints and include factories/seeders where possible for deterministic data.

## Commit & Pull Request Guidelines
- Follow the existing imperative style (`Implement initial project structure and setup`); keep messages short and scoped.
- Reference issues in the footer (`Refs #123`) and squash noisy WIP commits locally.
- PRs must describe the motivation, high-level changes, test evidence (command output or screenshots), and any deployment notes.
- Include screenshots or screencasts when touching UI and note if migrations, queues, or env changes are required.
