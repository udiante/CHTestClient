# Test Crypto Screener API

## Requests

### Base url:

```
https://test.cryptojet.io
```

### Available Endpoints:

- [Get list of coins](#get-the-list-of-coins)
- [Get a coin details](#get-a-coins-details)
- [Get a coin historical](#get-a-coin-historical)
- [Get authed user portfolio](#get-authed-user-portfolio)
- [Store a new trade in the authed user portfolio](#store-a-new-trade-in-the-authed-user-portfolio)


#### Get the list of coins

```
GET /coins

+ Request
  + Headers
    Accept: 'application/json'
  + Body
    {
      "page": 1
    }

+ Response 200
  {
    "coins": {
      "total": 100,
      "per_page": 25,
      "current_page": 1,
      "last_page": 4,
      "first_page_url": "http://dev.cryptos.com/coins?page=1",
      "last_page_url": "http://dev.cryptos.com/coins?page=4",
      "next_page_url": "http://dev.cryptos.com/coins?page=2",
      "prev_page_url": null,
      "path": "http://dev.cryptos.com/coins",
      "from": 1,
      "to": 25,
      "data":[
        {
          // Coin Object
        },
        {
          // Coin Object
        },
        ...
      ]
    }
  }
```

#### Get a coin details

```
GET /coins/{coin_id}

+ Parameters
  + coin_id (number) - Coin ID

+ Request
  + Headers
    Accept: 'application/json'

+ Response 200
  {
    "coin": {
      // Coin Object
    }
  }

+ Response 404
  {
    error: "Coin {coin_id} not found"
  }
```

#### Get a coin historical

```
GET /coins/{coin_id}/historical

+ Parameters
  + coin_id (number) - Coin ID

+ Request
  + Headers
    Accept: 'application/json'

+ Response 200
  {
    "historical": [
      {
        // Historical Object
      },
      ...
    ]
  }

+ Response 404
  {
    error: "Coin {coin_id} not found"
  }
```


#### Get authed user portfolio

```
GET /portfolio

+ Request
  + Headers
    Accept: 'application/json'
    Authorization: Basic richard@rich.com:secret

+ Response 200
  {
    coins: [
      {
        coin_id: int,
        amount: float,
        price_usd: float
      },
      ...
    ]
  }

+ Response 401 Unauthorized
```

#### Store a new trade in the authed user portfolio

```
POST /portfolio

+ Request
  + Headers
    Accept: 'application/json'
    Authorization: Basic richard@rich.com:secret

  + Body
    {
      coin_id: int
      amount: float, (could be negative)
      price_usd: float,
      traded_at: date, ('2018-04-20T16:40:51.620Z', Iso8601)
      notes: 'I want that lambo!' (optional)
    }

+ Response 200
  {
    trade: {
      "coin_id": "2",
      "user_id": 1,
      "amount": "-2.2183",
      "price_usd": "675.982",
      "total_usd": -1499.5308706,
      "notes": null,
      "traded_at": "2018-04-20T16:40:51+00:00",
      "updated_at": "2018-05-03T09:08:26+00:00",
      "created_at": "2018-05-03T09:08:26+00:00",
      "id": 5
    }
  }

+ Response 400
  {
    coin_id: [
      "The coin id field is required.",
      "The selected coin id is invalid."
    ],
    amount: [
      "The amount field is required.",
      "The amount must be a number."
    ],
    price_usd: [
      "The price usd field is required.",
      "The price usd must be a number.",
      "The price usd must be at least 0."
    ],
    traded_at: [
      "The traded at field is required.",
      "The traded at must be a date before 2018-05-03T09:14:39+00:00."
    ]
  }

+ Response 401 Unauthorized
```


## Objects

### Coin

```json
{
  "id": 2,
  "name": "Ethereum",
  "symbol": "ETH",
  "logo": null,
  "rank": 2,
  "price_usd": "719.98600000",
  "price_btc": "0.07797240",
  "24h_volume_usd": 3014730000,
  "market_cap_usd": 71421998446,
  "available_supply": 99199149,
  "total_supply": 99199149,
  "percent_change_1h": "0.28000000",
  "percent_change_24h": "5.52000000",
  "percent_change_7d": "14.58000000",
  "created_at": "2018-05-03T08:54:02+00:00",
  "updated_at": "2018-05-03T08:54:02+00:00"
}
```

### Historical

```json
{
  "price_usd": "2962.04162456",
  "snapshot_at": "2018-04-03T10:54:02+00:00"
}
```

### Individual Trade

```json
{
  "coin_id": 2,
  "user_id": 1,
  "amount": "-2.2183",
  "price_usd": "675.982",
  "total_usd": -1499.5308706,
  "notes": null,
  "id": 3,
  "created_at": "2018-05-03T09:00:07+00:00",
  "updated_at": "2018-05-03T09:00:07+00:00",
  "traded_at": "2018-04-20T16:40:51+00:00"
}
```

### Grouped Trades

```json
{
  "coin_id": 2,
  "amount": "-11.09150000",
  "price_usd": "-7497.65435300"
}
```