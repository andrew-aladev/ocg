# Option combination generator

| AppVeyor | Circle | Github Actions | Codecov | Gem |
| :------: | :----: | :------------: | :-----: | :-: |
| [![AppVeyor test status](https://ci.appveyor.com/api/projects/status/github/andrew-aladev/ocg?branch=master&svg=true)](https://ci.appveyor.com/project/andrew-aladev/ocg/branch/master) | [![Circle test status](https://circleci.com/gh/andrew-aladev/ocg/tree/master.svg?style=shield)](https://circleci.com/gh/andrew-aladev/ocg/tree/master) | [![Github Actions test status](https://github.com/andrew-aladev/ocg/workflows/test/badge.svg?branch=master)](https://github.com/andrew-aladev/ocg/actions) | [![Codecov](https://codecov.io/gh/andrew-aladev/ocg/branch/master/graph/badge.svg)](https://codecov.io/gh/andrew-aladev/ocg) | [![Gem](https://img.shields.io/gem/v/ocg.svg)](https://rubygems.org/gems/ocg) |

## Installation

```sh
gem install ocg
```

You can build it from source.

```sh
rake gem
gem install pkg/ocg-*.gem
```

You can also use [overlay](https://github.com/andrew-aladev/overlay) for gentoo.

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

generator.each { |combination| puts combination }
```

It will populate all option combinations.

## Docs

`OCG.new options` will prepare a generator.
It will provide all possible option combinations.

| Method      | Description |
|-------------|-------------|
| `and`       | provides all combinations between generators |
| `mix`       | merges combinations without combining, guarantees that both left and right generator combinations will be provided at least once |
| `or`        | concats generator combinations without merging |
| `reset`     | allows to receive combinations once again |
| `next`      | returns next combination |
| `last`      | returns last combination |
| `started?`  | returns true when at least one combination was generated |
| `finished?` | returns true when all combination were generated |
| `length`    | returns combinations length |
| `dup`       | returns generator duplicate |
| `clone`     | returns generator clone |

Generator is responsible to any method from [`Enumerable`](https://ruby-doc.org/core-3.0.0/Enumerable.html).
Enumerator will be provided using generator duplicate.
So enumerable api is separated from bare metal api (`reset`, `next`, `last`, `started?`, `finished?`).

You can combine generators using `and`, `mix` and `or`.

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

## Why?

Many software uses multiple options and have complex relations between them.
We want to test this software.
We need to provide optimal option combination to maximize test coverage.
The amount of combinations can be more than billion, it is not possible to store them (fuzzing testing).

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
  :hashLog   => 0..10,
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
  :ldmHashLog                 => 0..10,
  :ldmMinMatch                => 0..10,
  ...
)
```

General compression and long distance matching option groups correlate between each other.
We want to have all possible combinations between these option groups.

```ruby
main_generator = general_generator.and ldm_generator
```

`contentSizeFlag`, `checksumFlag`, `dictIDFlag` options are additional options.
These options may correlate between each other but don't correlate with main options.

```ruby
almost_complete_generator = main_generator.mix(
  :contentSizeFlag => [true, false],
  :checksumFlag    => [true, false],
  :dictIDFlag      => [true, false]
)
```

`nbWorkers`, `jobSize` and `overlapLog` options are thread related options.
When `nbWorkers` equals `0`, `jobSize` and `overlapLog` should not be used.
These options correlate between each other but don't correlate with main options.

```ruby
complete_generator = almost_complete_generator.mix(
  OCG.new(
    :nbWorkers => [0]
  )
  .or(
    :nbWorkers  => 1..2,
    :jobSize    => 1..10,
    :overlapLog => 0..9
  )
)
```

## Operating systems

GNU/Linux, FreeBSD, OSX, Windows (MinGW).

## CI

Please visit [scripts/test-images](scripts/test-images).
See universal test script [scripts/ci_test.sh](scripts/ci_test.sh) for CI.
You can run this script using many native and cross images.

## License

MIT license, see [LICENSE](LICENSE) and [AUTHORS](AUTHORS).
