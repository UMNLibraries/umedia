# frozen_string_literal: true

require 'test_helper'

class TranscriptSanitizeTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end

  describe 'when viewing bad transcript data' do
    it 'escapes html special characters' do
      Capybara.current_driver = :selenium

      visit '/item/p16022coll460:672'
      find(:xpath, '//a[@data-section="transcriptions"][1]').click
      # A raw <A in the rendered content means it was not converted to a link
      # and therefore it is escaped as expected
      _(page).must_have_content('<A')
    end
  end
end

