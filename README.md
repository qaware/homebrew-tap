# QAware homebrew tap

This is the QAware wide
[homebrew](https://brew.sh)
[tap](https://docs.brew.sh/Taps).

## Usage

To add this tap (basically an additional source for packages (`Formulae`) beside
[brew-core](https://github.com/Homebrew/homebrew-core)),
you need to have brew installed an then run:

```bash
brew tap qaware/tap
```

After the successful registration, `Formulae` from this repo can be installed, like any other program:

```bash
brew install protocurl
# or to be more specfic (needed if a Formulae has the same name as in hombrew-core)
brew install qaware/tap/protocurl
```

## Content

<!-- BEGIN TOC -->
<!-- END TOC -->

## Formulae maintainer

If you want to push your own `Formulae` these are the steps:

* Get a `Deploy Token` for your repo/CI (can be requested by the maintainers of this tap-repo)

## Maintainers

* Alexander Eimer (@qa-alexander-eimer)
