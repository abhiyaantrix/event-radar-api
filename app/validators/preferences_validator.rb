# frozen_string_literal: true

class PreferencesValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless valid_value?(value)
      record.errors.add(attribute, I18n.t('activerecord.errors.models.user.attributes.preferences.format.invalid'))
      return
    end

    validate_theme(value, record)
  end

  private

  def valid_value?(value)
    return true if value.is_a?(Hash)

    JSON.parse(value) if value.is_a?(String)
  rescue JSON::ParserError
    false
  end

  def validate_theme(preferences, record)
    valid_themes = EventRadar::Config.themes
    theme = preferences['theme']

    if theme.present? && !valid_themes.include?(theme)
      record.errors.add(
        :preferences,
        I18n.t('activerecord.errors.models.user.attributes.preferences.theme.invalid', themes: valid_themes.join(', '))
      )
    end
  end

end
