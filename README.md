# spreadsheet-answer-reader
Script for reading answers in Google spreadsheet

## Setup

### config.json

Add your own `config.json` to the project root. Please see https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

### config.yml

Add `config.yml` to the project root and put your own configurations. Please refer `config.yml.example`.

### Install gems

```
bundle install
```

## How to run

Without names who answered:

```
bundle exec ruby ./lib/spreadsheet_answer_reader.rb
```

With names who answered: 

```
bundle exec ruby ./lib/spreadsheet_answer_reader.rb 1
```

## License

MIT License.
