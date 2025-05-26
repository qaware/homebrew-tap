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
* Casks
  * _n/a (no casks found)_
* Formulae
  * _n/a (no formulae found)_
<!-- END TOC -->

## Formulae maintainer

_TL;DR Deploy only your `Formula/[foo].rb` and `Formula/[foo]@[major].rb` files._

If you want to push your own `Formulae` these are the steps:

* Get a `Deploy Token` for your repo/CI (can be requested by the maintainers of this tap-repo)
* Set up your CI to push the ruby files to `Formula`.
  You can push either of these `Formulae`:  
  `foo.rb`, `foo@1.rb`, `foo@1.2.rb`  
  **Other formats (with bugfix version or with buildpostfix) may be removed by the CI in the future.**  
  This behaviour is accordingly to [brew Versions](https://docs.brew.sh/Versions).
* The CI of `qaware/homebrew-tap` will update the README.md TOC.
* You can use the `Aliases` folder as you want, if you stay within the brew conventions.

## Maintainers

* Alexander Eimer ([@aeimer](https://github.com/aeimer))

## Support

This project is made possible with the support of

[![QAware GmbH logo](https://blog.qaware.de/images/icons/logo_qaware.svg)](https://qaware.de)
