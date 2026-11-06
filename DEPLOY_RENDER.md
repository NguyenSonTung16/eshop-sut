# EShop SUT on Render

This fork provides one Render web service for the customer web app, admin web app, and API.

- Customer web: `/`
- Admin web: `/admin`
- API: `/api/*`
- Health check: `/healthz`

The Render Blueprint is in `render.yaml`. Deploy the `codex/render-deploy` branch as a Blueprint. Its Dockerfile builds both Vite apps and the SQLite native module in the same Debian environment used at runtime; Express serves the resulting files and API from the same origin.

This is a deliberately faulty software testing target. Use only test data. The seeded demo accounts and passwords are already documented in the upstream README. The SQLite database is recreated on each server start. On Render's free plan, the filesystem is ephemeral and the service may sleep after inactivity, so registrations, orders, and other changes can disappear. For a test run requiring stable state, use a paid persistent disk or another persistent database and revise the database initialization strategy.
