# Health

- Source: `openapi.json`
- Live Requests: `disabled`

## Health Check

`GET /health`

### Request

```bash
curl --request GET \
	--url 'https://tradingview-data1.p.rapidapi.com/health' \
	--header 'x-rapidapi-host: tradingview-data1.p.rapidapi.com' \
	--header 'x-rapidapi-key: YOUR_RAPIDAPI_KEY'
```

### Response

OpenAPI example / fallback

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "timestamp": 1776767673990,
    "charts": 1,
    "quoteSessions": 4,
    "authenticated": false
  },
  "msg": "Success"
}
```

## Realtime connection and performance metrics

`GET /health/realtime`

### Request

```bash
curl --request GET \
	--url 'https://tradingview-data1.p.rapidapi.com/health/realtime' \
	--header 'x-rapidapi-host: tradingview-data1.p.rapidapi.com' \
	--header 'x-rapidapi-key: YOUR_RAPIDAPI_KEY'
```

### Response

OpenAPI example / fallback

```json
{
  "note": "No response example is defined in OpenAPI. Set LIVE_REQUESTS=1 to capture a live response."
}
```
