# frozen_string_literal: true

module EventRadar
  class Config

    VARCHAR_MAX_LENGTH = 255
    TEXT_MAX_LENGTH = 65_535

    class << self

      def themes
        ENV.fetch('THEMES', 'system,dark,light')
           .split(',')
           .map(&:strip)
           .freeze
      end

    end

    # .theme_system, .theme_dark, .theme_light
    self.themes.each do |theme|
      define_singleton_method("theme_#{theme}") { theme }
    end

  end
end
