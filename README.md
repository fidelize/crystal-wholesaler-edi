# Wholesaler EDI

Technologies:

* [Kemal](https://github.com/sdogruyol/kemal): Rack-like web framework
* [Crystal JWT](https://github.com/greyblake/crystal-jwt): Json Web Token authentication

## Installation

Install Crystal:

```bash
# OS X
brew update
brew install crystal-lang

# Debian / Ubuntu
curl http://dist.crystal-lang.org/apt/setup.sh | sudo bash
sudo apt install crystal
```

Install dependencies:

```bash
cd crystal-wholesaler-edi
shards install
```

## Usage

```bash
crystal build --release src/edi.cr
./edi
```

## Tests

```bash
crystal spec
```

## Contributing

1. Fork it ( https://github.com/alanwillms/crystal-wholesaler-edi/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [alanwillms](https://github.com/alanwillms) Alan Willms - creator, maintainer
