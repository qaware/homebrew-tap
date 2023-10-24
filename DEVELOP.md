# How to develop with this repo?

To create test files run:

```bash
# Only latest
touch Formula/foo1.rb

# Only major.minor
touch Formula/foo2@1.9.rb
touch Formula/foo2@1.10.rb

# Only major
touch Formula/foo3@1.rb
touch Formula/foo3@2.rb

# All => latest, major, major.minor
touch Formula/foo10.rb
touch Formula/foo10@1.rb
touch Formula/foo10@1.0.rb
touch Formula/foo10@1.1.rb
```

Run locally with:

```bash
./.ci-scripts/parse-formulas.sh
./.ci-scripts/enforce-formula-policies.sh
./.ci-scripts/parse-formulas.sh
./.ci-scripts/generate-aliases.sh
./.ci-scripts/update-toc.sh
```
