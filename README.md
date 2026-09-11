# telegram-bot-api-railway

Railway wrapper around the official [Telegram Bot API server](https://github.com/tdlib/telegram-bot-api)
(`aiogram/telegram-bot-api`).

The upstream image sets an `ENTRYPOINT`, so a Railway start command cannot be used — it would
replace the entrypoint that assembles the server's arguments. This wrapper keeps that entrypoint
and adds the three Railway-specific fixes documented at the top of `railway-entrypoint.sh`:
the injected `$PORT` is used as the HTTP listen port, the two deployer-owned credentials are
validated with a readable message before the server starts, and local mode is on by default.

Image: `ghcr.io/bon5co/telegram-bot-api-railway:latest`
