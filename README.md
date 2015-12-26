# TxtServer (2nd Task - Search Service)

HTTP-based recipe search service. Clients of the API should be able to use the query language specified in 1st Task: Query Language Evaluator.
This repository also includes a sample data set full of text files (cooking recipes).

#### Example session

assuming that you started the server locally with:

```shell
bundle exec rackup -p 9292 config.ru
```

```shell

curl -X POST -d'{ "query" : "garlic AND peppers" }' localhost:9292/_search

```


Example response

```json

{
  "total": 10,
  "hit" : 2,
  "documents" : [
    { "name" : "enchiladas", "content" : "1 pepper\n2 cloves of garlic...", "filename": "enchiladas.txt" },
    { "name" : "sweet and sour chicken", "content" : "3 peppers\n1 pineapple...", "filename": "sweet_and_sour_chicken.txt" }
  ]
}
```

Here are allowed parts of the query syntax:

- `AND` signifies AND operation
-  `OR` signifies OR operation
-  `-` negates a single token
-  `"` wraps a number of tokens to signify a phrase for searching
-  `*` at the end of a term signifies a wildcard query
-  `(` and `)` signify precedence

Therefore the following queries are possible:

```shell
curl X POST -d'{ "query" : "bananas AND apples" localhost:9292/_search
curl X POST -d'{ "query" : "bana*" localhost:9292/_search
curl X POST -d'{ "query" : "\"not so much\"" localhost:9292/_search
curl X POST -d'{ "query" : "bananas -apples" localhost:9292/_search
curl X POST -d'{ "query" : "bananas OR mangos" localhost:9292/_search
curl X POST -d'{ "query" : "(bananas OR mangos) AND much" localhost:9292/_search
curl X POST -d'{ "query" : "(bananas OR mangos) AND frozen" localhost:9292/_search
```

## Installation

Type

```shell
bundle install
```

to install dependencies. Note that as txt_search gem is not released you need to install it manually 

Type

```shell
rake spec
```

to run tests

Type

```shell
bundle exec rackup -p 9292 config.ru
```

to start the server locally



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kolach/txt_server.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

