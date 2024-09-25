# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventRadar::Config do
  describe 'themes' do
    let(:themes_env) { 'THEMES' }
    let(:expected_themes) { %w[system dark light] }
    let(:themes_string) { ' dark , light , system ' }

    describe '.themes' do
      context 'when environment variable is set' do
        before do
          allow(ENV).to receive(:fetch).with(themes_env, anything).and_return(themes_string)
        end

        it 'returns themes from environment variable' do
          expect(described_class.themes).to match_array(expected_themes)
        end
      end

      context 'when environment variable is not set' do
        it 'returns default themes' do
          expect(described_class.themes).to match_array(expected_themes)
        end
      end

      it 'freezes themes array' do
        expect(described_class.themes).to be_frozen
      end
    end

    describe '.theme_<name>' do
      before do
        allow(ENV).to receive(:fetch).with(themes_env, anything).and_return(themes_string)
      end

      %w[system dark light].each do |theme|
        it "defines method for #{theme} theme" do
          expect(described_class).to respond_to("theme_#{theme}")
          expect(described_class.public_send("theme_#{theme}")).to eq(theme)
        end
      end

      it 'raises NoMethodError for non-existent theme methods' do
        expect { described_class.theme_unknown }.to raise_error(NoMethodError)
      end
    end
  end
end
