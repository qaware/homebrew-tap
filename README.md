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
* protocurl
<!-- END TOC -->

## Formulae maintainer

_TL;DR Deploy only your `Formula/[foo]@[major].[minor].rb` files and enjoy the benefits of the CI!_

If you want to push your own `Formulae` these are the steps:

* Get a `Deploy Token` for your repo/CI (can be requested by the maintainers of this tap-repo)
* Set up your CI to push the ruby files to `Formula`.
  You can push either of these `Formulae`:  
  `foo.rb`, `foo@1.rb`, `foo@1.2.rb`  
  **Other formats (with bugfix version or with buildpostfix) will be removed by the CI.**  
  This behaviour is accordingly to [brew Versions](https://docs.brew.sh/Versions).
* The CI of `qaware/homebrew-tap` will create the `latest` (`Aliases/foo.rb`) symlink and the `major` (`Aliases/foo@1.rb`) symlink.
  This behaviour provides an easy way to only push one `Formulae` and still have a full version selection available.  
  If you want to manage these "high-level" versions on your own, the CI will not create aliases if a `Formulae` is present.
  `Formulae` have precedence over `Aliases`.

## Maintainers

* Alexander Eimer ([@qa-alexander-eimer](https://github.com/qa-alexander-eimer))
