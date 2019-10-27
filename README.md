# Option combination generator

[![Travis test status](https://travis-ci.org/andrew-aladev/ocg.svg?branch=master)](https://travis-ci.org/andrew-aladev/ocg)
[![AppVeyor test status](https://ci.appveyor.com/api/projects/status/github/andrew-aladev/ocg?branch=master&svg=true)](https://ci.appveyor.com/project/andrew-aladev/ocg/branch/master)
[![Cirrus test status](https://api.cirrus-ci.com/github/andrew-aladev/ocg.svg?branch=master)](https://cirrus-ci.com/github/andrew-aladev/ocg)
[![Circle test status](https://circleci.com/gh/andrew-aladev/ocg/tree/master.svg?style=shield)](https://circleci.com/gh/andrew-aladev/ocg/tree/master)

## Installation

```sh
gem install ocg
```

You can build it from source.

```sh
rake gem
gem install pkg/ocg-*.gem
```

## Usage

```ruby
require "ocg"

generator = OCG.new(
  :a => %w[a b],
  :b => 1..2
)
.or(
  :c => %i[c d],
  :d => 3..4
)
.and(
  :e => %w[e f],
  :f => 5..6
)
.mix(
  :g => %i[g h],
  :h => 7..8
)

until generator.finished?
  puts generator.next
end
```

It will populate all option combinations.

## Docs

Options should be prepared in the following form:

```ruby
{
  option_name => option_values,
  ...
}
```

Options hash should not be empty.
`option_name` can be any valid hash key.
`option_values` should be convertable to array using `to_a`.
`option_values` should not be empty.

`OCG.new options` will prepare a generator.
It will provide all possible option combinations.

You can combine generators using `and`, `mix` and `or`.

`and` method will provide all combinations between generators.
`mix` method will merge combinations without combining. `mix` guarantees that both left and right generator combinations will be provided at least once.
`or` method will concat generator combinations without merging.

`reset` method allows to receive combinations once again.

`next` method returns next combination.

`last` method returns last combination.

`started?` method returns true when at least one combination was generated.

`finished?` method returns true when all combination were generated.

`length` returns combinations length.

`to_a` returns combinations array.

## Why?

Many software uses multiple options and have complex relations between them.
We want to test this software.
We need to provide optimal option combination to maximize test coverage.

Let's look at [zstd compressor options](http://facebook.github.io/zstd/zstd_manual.html#Chapter5).

`compressionLevel` option is a preset for `windowLog`, `hashLog`, etc options.
We may set `compressionLevel` or other options, mixing is pointless.
We can say that there are 2 option groups: group with single `compressionLevel` option and group with other options.

```ruby
general_generator = OCG.new(
  :compressionLevel => -10..10
)
.or(
  :windowLog => 0..10,
  :hashLog => 0..10,
  ...
)
```

`enableLongDistanceMatching` option enables usage of `ldmHashLog`, `ldmMinMatch`, etc options.
We may use `:enableLongDistanceMatching => false` or `:enableLongDistanceMatching => true` with other options.

```ruby
ldm_generator = OCG.new(
  :enableLongDistanceMatching => [false]
)
.or(
  :enableLongDistanceMatching => [true],
  :ldmHashLog => 0..10,
  :ldmMinMatch => 0..10,
  ...
)
```

General compression and long distance matching option groups correlate between each other.
We want to have all possible combinations between these option groups.

```ruby
main_generator = general_generator.and ldm_generator
```

`contentSizeFlag`, `checksumFlag`, `dictIDFlag` options are additional options.
These options don't correlate between each other or with main options.
We want just to mix their values with main options.

```ruby
almost_complete_generator = main_generator.mix(
  :contentSizeFlag => [true, false]
)
.mix(
  :checksumFlag => [true, false]
)
.mix(
  :dictIDFlag => [true, false]
)
```

`nbWorkers`, `jobSize` and `overlapLog` options are thread related options.
These options correlate between each other but don't correlate with main options.

```ruby
complete_generator = almost_complete_generator.mix(
  :nbWorkers => 0..2,
  :jobSize => 1..10,
  :overlapLog => 0..9
)
```

## CI

Travis and Appveyor CI uses [scripts/toolchains.sh](scripts/toolchains.sh) directly.
Cirrus and Circle CI uses prebuilt [scripts/test-images](scripts/test-images).
Cirrus CI uses amd64 image, Circle CI - i686.

## License

MIT license, see LICENSE and AUTHORS.
