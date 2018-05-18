# frozen_string_literal: true

module Parhelion
  class Field
    attr_reader :value, :name
    # Value can be an array or a string
    def initialize(name: '', value: '')
      @value = value
      @name  = name
    end

    def display?
      !value.empty?
    end

    # Helpful for tests and maybe more
    def ==(other)
      value == other.value && name == other.name
    end
  end
end