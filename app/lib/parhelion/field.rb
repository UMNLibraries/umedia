# frozen_string_literal: true

module Parhelion
  class Field
    attr_reader :value, :name
    # Value can be an array or a string
    def initialize(name: '', value: '')
      @value = value
      @name  = name
    end

    def missing?
      false
    end

    def exists?
      true
    end

    def display?
      if value.respond_to?(:empty?)
        !value.empty?
      else
        true
      end
    end

    # Helpful for tests and maybe more
    def ==(other)
      value == other.value && name == other.name
    end
  end
end