# frozen_string_literal: true
require 'i18n'

module Parhelion
  class Field
    attr_reader :value, :name, :locale
    # Value can be an array or a string
    def initialize(name: '', value: '')
      @value = value
      @name  = name
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

    # Support field i18n by 2 letter name prefix (e.g. es_field_name, de_field_name)
    # or default locale with no prefix (e.g. field_name)
    def locale
      @locale ||= locale_match || I18n.default_locale
    end

    # Field name without locale
    def universal_name
      @universal_name ||= locale ? name.sub(Regexp.new("^#{locale.to_s}_"), '') : name
    end

    # Helpful for tests and maybe more
    def ==(other)
      value == other.value && name == other.name
    end

    private
    def locale_match
      l = name.match /^([a-z][a-z])_(.*)/
      if l && l.length > 1 && I18n.available_locales.include?(l[1].to_sym)
        l[1].to_sym
      end
    end
  end
end
