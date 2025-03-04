# README

Prerequisite:
- Redis running locally with the default port

To reproduce the problem:

```
# Start the RPC
bundle exec anycable

# Start the anycable
/bin/anycable-go --debug --path=/v1

# Connect using Websocat
websocat 'ws://127.0.0.1:8080/v1'
```

## Unsubscribe with the `unsubscribe` command

Send this command
```json
{"command":"subscribe","identifier":"{\"channel\":\"PriceChannel\"}"}
```

We'll get:
```json
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"message":"Subscribed!"}}
{"identifier":"{\"channel\":\"PriceChannel\"}","type":"confirm_subscription"}
```

Subscribe to three symbols:
```json
{"command":"message","identifier":"{\"channel\":\"PriceChannel\"}","data":"{\"symbols\":[\"bsc\",\"eth\",\"base\"],\"action\":\"set_symbols\"}"}
```

We'll get these responses:
```json
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"message":"Subscribed to price_channel_bsc!"}}
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"message":"Subscribed to price_channel_eth!"}}
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"message":"Subscribed to price_channel_base!"}}
```

Open the Rails console and run these:
```ruby
AnyCable.broadcast "price_channel_bsc", { price: "1" }.to_json; AnyCable.broadcast "price_channel_eth", { price: "2" }.to_json; AnyCable.broadcast "price_channel_base", { price: "3" }.to_json
```

We should be receiving:
```json
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"price":"1"}}
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"price":"2"}}
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"price":"3"}}
```

Unsubscribe with:
```json
{"command":"unsubscribe","identifier":"{\"channel\":\"PriceChannel\"}"}
```

We'll receive:
```json
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"message":"Unsubscribed!"}}
```

Send the same command from your Rails console again and we'll receive:
```json
{"identifier":"{\"channel\":\"PriceChannel\"}","message":{"price":"2"}}
```

Which shouldn't be happening as we have already unsubscribed.
