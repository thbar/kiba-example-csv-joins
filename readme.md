This repository shows how to join 3 CSV:

* [data/main.csv] is the main file (with columns `client_id` and `language_id`)
* [data/languages.csv] contains languages, with their language id and name
* [data/clients.csv] contains clients, with their client id and name

To run:

```
bundle install
bundle exec ruby demo.rb
```

Once run you'll get [data/main-enriched.csv], which joins the main file with the 2 other.
