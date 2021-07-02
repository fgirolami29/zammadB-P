# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

require 'rails_helper'

RSpec.describe 'Manage > Users', type: :system do
  describe 'switching to an alternative user', authenticated_as: -> { original_user } do
    let(:original_user) { create(:admin) }
    let(:alternative_one_user) { create(:admin) }
    let(:alternative_two_user) { create(:admin) }

    before do
      alternative_one_user
      alternative_two_user
    end

    it 'starts as original user' do
      expect(current_user).to eq original_user
    end

    it 'switches to alternative user' do
      switch_to(alternative_one_user)
      expect(current_user).to eq alternative_one_user
    end

    it 'switches to another alternative user' do
      switch_to(alternative_one_user)
      switch_to(alternative_two_user)

      expect(current_user).to eq alternative_two_user
    end

    it 'switches back to original user' do
      switch_to(alternative_one_user)
      switch_to(alternative_two_user)

      click '.switchBackToUser-close'

      expect(current_user).to eq original_user
    end

    def switch_to(user)
      visit 'manage/users'

      within(:active_content) do
        row = find("tr[data-id=\"#{user.id}\"]", wait: 10)
        row.find('.js-action').click
        row.find('.js-switchTo').click
      end

      expect(page).to have_text("Zammad looks like this for \"#{user.firstname} #{user.lastname}\"", wait: 10)
    end
  end

  # Fixes GitHub Issue #3050 - Newly created users are only shown in the admin interface after reload
  describe 'adding a new user', authenticated_as: -> { user } do
    let(:user) { create(:admin) }

    it 'newly added user is visible in the user list' do
      visit '#manage/users'

      within(:active_content) do
        find('[data-type=new]').click

        find('[name=firstname]').fill_in with: 'NewTestUserFirstName'
        find('[name=lastname]').fill_in with: 'User'
        find('span.label-text', text: 'Customer').first(:xpath, './/..').click

        click '.js-submit'

        expect(page).to have_css('table.user-list td', text: 'NewTestUserFirstName')
      end

    end

  end
end
