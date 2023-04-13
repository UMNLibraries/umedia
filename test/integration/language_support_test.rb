# frozen_string_literal: true

require 'test_helper'

class LanguageSupportTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end

  describe 'when an item supports spanish language metadata' do
    it 'presents a link to switch to spanish' do
      Capybara.current_driver = :selenium
      visit '/item/p16022coll613:15'

      click_link 'Cambiar a Español'
      _(page).must_have_content('Descripción:')
      _(page).must_have_content('"Periódico hispano semanal de negocios, artes y noticias comunitarias." En inglés y español.')
      _(page).wont_have_content('"Weekly Hispanic Newspaper for Business, Arts, and Community News." In English and Spanish.')

      click_link 'Change to English'
      _(page).must_have_content('Description:')
      _(page).must_have_content('"Weekly Hispanic Newspaper for Business, Arts, and Community News." In English and Spanish.')
      _(page).wont_have_content('"Periódico hispano semanal de negocios, artes y noticias comunitarias." En inglés y español.')
    end
  end

  it 'does not present a link to switch to spanish' do
    visit '/item/p16022coll460:672'

    _(page).wont_have_content('Cambiar a Español')
    _(page).wont_have_content('Descripción:')
  end

  it 'allows language= prarm in the URL' do
    visit '/details/p16022coll613:15?language=es'

    _(page).must_have_content('Descripción:')
    _(page).must_have_link('Change to English')
    _(page).wont_have_link('Cambiar a Español')
  end

  it 'sets a data-locale= attribute with a param-specific language' do
    visit '/item/p16022coll613:15?language=es'
    _(page).must_have_xpath('//div[@id="main" and @data-locale="es"]')
  end

  it 'sets a data-locale= attribute with a default language' do
    visit '/item/p16022coll613:15'
    _(page).must_have_xpath('//div[@id="main" and @data-locale="en"]')
  end
end
