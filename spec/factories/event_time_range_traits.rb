# frozen_string_literal: true

# Conveniently abstracted shared time range traits to be used in event, online and offline meeting models
FactoryBot.define do
  trait :future do
    start_time { Faker::Time.between(from: DateTime.now + 1.day, to: DateTime.now + 5.days, format: :default) }
    end_time { Faker::Time.between(from: DateTime.now + 5.days, to: DateTime.now + 10.days, format: :default) }
  end

  trait :past do
    start_time { Faker::Time.between(from: DateTime.now - 10.days, to: DateTime.now - 5.days, format: :default) }
    end_time { Faker::Time.between(from: DateTime.now - 5.days, to: DateTime.now - 1.day, format: :default) }
  end

  trait :ongoing do
    start_time { Faker::Time.between(from: DateTime.now - 1.day, to: DateTime.now, format: :default) }
    end_time { Faker::Time.between(from: DateTime.now + 1.hour, to: DateTime.now + 2.days, format: :default) }
  end

  trait :open_ended do
    end_time { nil }
  end
end
