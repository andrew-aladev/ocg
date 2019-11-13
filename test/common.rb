# Option combination generator.
# Copyright (c) 2019 AUTHORS, MIT License.

require "ocg"

class OCG
  module Test
    def self.get_data
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

      main_combinations = [
        get_option_combinations(
          :a => %w[a b],
          :b => [1, 2],
          :e => %w[e f],
          :f => [5, 6]
        ),
        get_option_combinations(
          :c => %i[c d],
          :d => [3, 4],
          :e => %w[e f],
          :f => [5, 6]
        )
      ]
      .flatten(1)

      mix_combinations = get_option_combinations(
        :g => %i[g h],
        :h => [7, 8]
      )

      combinations = main_combinations.map.with_index do |combination, index|
        combination.merge mix_combinations[index % mix_combinations.length]
      end

      [generator, combinations]
    end

    def self.get_data_rotated_around_or
      generator = OCG.new(
        :c => %i[c d],
        :d => 3..4
      )
      .or(
        :a => %w[a b],
        :b => 1..2
      )
      .and(
        :e => %w[e f],
        :f => 5..6
      )
      .mix(
        :g => %i[g h],
        :h => 7..8
      )

      main_combinations = [
        get_option_combinations(
          :c => %i[c d],
          :d => [3, 4],
          :e => %w[e f],
          :f => [5, 6]
        ),
        get_option_combinations(
          :a => %w[a b],
          :b => [1, 2],
          :e => %w[e f],
          :f => [5, 6]
        )
      ]
      .flatten(1)

      mix_combinations = get_option_combinations(
        :g => %i[g h],
        :h => [7, 8]
      )

      combinations = main_combinations.map.with_index do |combination, index|
        combination.merge mix_combinations[index % mix_combinations.length]
      end

      [generator, combinations]
    end

    def self.get_data_rotated_around_and
      generator = OCG.new(
        :e => %w[e f],
        :f => 5..6
      )
      .and(
        OCG.new(
          :a => %w[a b],
          :b => 1..2
        )
        .or(
          :c => %i[c d],
          :d => 3..4
        )
      )
      .mix(
        :g => %i[g h],
        :h => 7..8
      )

      first_combinations = get_option_combinations(
        :e => %w[e f],
        :f => [5, 6]
      )

      second_combinations = [
        get_option_combinations(
          :a => %w[a b],
          :b => [1, 2]
        ),
        get_option_combinations(
          :c => %i[c d],
          :d => [3, 4]
        )
      ]
      .flatten(1)

      main_combinations = first_combinations.flat_map do |first_combination|
        second_combinations.map do |second_combination|
          first_combination.merge second_combination
        end
      end

      mix_combinations = get_option_combinations(
        :g => %i[g h],
        :h => [7, 8]
      )

      combinations = main_combinations.map.with_index do |combination, index|
        combination.merge mix_combinations[index % mix_combinations.length]
      end

      [generator, combinations]
    end

    def self.get_data_rotated_around_mix
      generator = OCG.new(
        :g => %i[g h],
        :h => 7..8
      )
      .mix(
        OCG.new(
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
      )

      main_combinations = [
        get_option_combinations(
          :a => %w[a b],
          :b => [1, 2],
          :e => %w[e f],
          :f => [5, 6]
        ),
        get_option_combinations(
          :c => %i[c d],
          :d => [3, 4],
          :e => %w[e f],
          :f => [5, 6]
        )
      ]
      .flatten(1)

      mix_combinations = get_option_combinations(
        :g => %i[g h],
        :h => [7, 8]
      )

      combinations = main_combinations.map.with_index do |combination, index|
        mix_combinations[index % mix_combinations.length].merge combination
      end

      [generator, combinations]
    end

    def self.get_datas(&_block)
      yield get_data
      yield get_data_rotated_around_or
      yield get_data_rotated_around_and
      yield get_data_rotated_around_mix
    end

    private_class_method def self.get_option_combinations(options)
      combinations = options.reduce([]) do |result, (key, values)|
        values = values.map { |value| [key, value] }
        next values.map { |value| [value] } if result.empty?

        result.product(values).map { |prev_values, value| prev_values + [value] }
      end

      combinations.map(&:to_h)
    end
  end
end
