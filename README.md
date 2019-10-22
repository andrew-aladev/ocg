# Option combination generator

WIP

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
  :enableLongDistanceMatching => [true]
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

## License

MIT license, see LICENSE and AUTHORS.
