# tradingview-api-integration

Agent skill for integrating with and querying the [TradingView Data API](https://rapidapi.com/tradingview-data1/api/tradingview-data1) on RapidAPI (`tradingview-data1`).

Helps AI agents choose the right endpoints, resolve symbols and metadata, and run live API calls for quotes, candlesticks, fundamentals, technical analysis, screeners, news, calendars, and more.

## Install

```bash
npx skills add hypier/tradingview-api-integration-skill -g -y
```

Project-scoped install:

```bash
npx skills add hypier/tradingview-api-integration-skill -y
```

List without installing:

```bash
npx skills add hypier/tradingview-api-integration-skill -l
```

Works with Cursor, Claude Code, Codex, OpenCode, and [other supported agents](https://github.com/vercel-labs/skills#supported-agents).

## API key

Most endpoints require a RapidAPI key. The helper script resolves it in this order:

1. `--key` CLI argument
2. `RAPIDAPI_KEY` environment variable
3. `.rapidapi-key` in the skill root (created only with explicit consent)

```bash
export RAPIDAPI_KEY='your-key-here'

# Or save locally after consent
python3 skills/tradingview-api-integration/scripts/tv_api.py --save-key 'your-key-here'
```

Never commit API keys. `.rapidapi-key` should stay local.

## Manual API calls

`skills/tradingview-api-integration/scripts/tv_api.py` is stdlib-only and pretty-prints JSON responses when working from a source checkout:

```bash
python3 skills/tradingview-api-integration/scripts/tv_api.py GET '/api/quote/NASDAQ:AAPL'
python3 skills/tradingview-api-integration/scripts/tv_api.py GET '/api/price/BINANCE:BTCUSDT?timeframe=60&range=20'
python3 skills/tradingview-api-integration/scripts/tv_api.py GET '/api/metadata/markets'
python3 skills/tradingview-api-integration/scripts/tv_api.py POST '/api/screener/scan' --body '{"market":"america","range":[0,20]}'
```

## What's included

| Path | Purpose |
|------|---------|
| `skills/tradingview-api-integration/SKILL.md` | Agent instructions: endpoint mapping, workflows, symbol format |
| `skills/tradingview-api-integration/scripts/tv_api.py` | CLI helper for live API calls |
| `skills/tradingview-api-integration/references/endpoint-catalog.md` | Full parameter tables and enums |
| `skills/tradingview-api-integration/references/examples/` | Captured request/response examples per endpoint family |

## Capabilities

- Stock, crypto, forex, and futures quotes and OHLCV history
- Company fundamentals, financials, dividends, analyst ratings
- Technical analysis (RSI, MACD, buy/sell signals)
- Market and symbol search
- Leaderboards (gainers, losers, movers)
- Stock and crypto screeners
- News and community trading ideas
- Economic calendars (earnings, IPO, dividends, macro)
- World economy indicators
- Metadata for markets, tabs, columnsets, languages, exchanges
- Streaming via token + SSE/WebSocket (documented in examples)

## Symbol format

Always use `EXCHANGE:TICKER` (e.g. `NASDAQ:AAPL`, `BINANCE:BTCUSDT`). Resolve bare names via `/api/search/market/` first.

## Documentation

See [SKILL.md](./skills/tradingview-api-integration/SKILL.md) for the full integration guide. For parameter details, see [references/endpoint-catalog.md](./skills/tradingview-api-integration/references/endpoint-catalog.md).

## License

MIT — see [LICENSE](./LICENSE).
