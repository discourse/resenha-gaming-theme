# frozen_string_literal: true

require_relative "page_objects/account_surfaces"

RSpec.describe "Resenha account surfaces" do
  before { upload_theme }

  fab!(:admin)
  fab!(:topic) { Fabricate(:topic, user: admin) }

  let(:account_surfaces) { PageObjects::Pages::AccountSurfaces.new }

  before do
    SiteSetting.resenha_enabled = true
    sign_in(admin)
  end

  it "lets an administrator reach the dashboard and manage their account" do
    visit("/latest")
    expect(account_surfaces).to have_admin_workspace_tab

    account_surfaces.open_admin_dashboard_from_workspace
    expect(page).to have_current_path("/admin")

    account_surfaces.visit_summary(admin)
    expect(account_surfaces).to have_summary_surface
    screenshot_marker(label: "resenha-user-summary")

    account_surfaces.visit_preferences(admin)
    expect(account_surfaces).to have_preferences_surface
    screenshot_marker(label: "resenha-user-preferences")

    account_surfaces.visit_activity(admin)
    expect(account_surfaces).to have_activity_surface
    screenshot_marker(label: "resenha-user-activity")

    account_surfaces.visit_notifications(admin)
    expect(account_surfaces).to have_notifications_surface
    screenshot_marker(label: "resenha-user-notifications")

    account_surfaces.visit_messages(admin)
    expect(account_surfaces).to have_messages_surface
    screenshot_marker(label: "resenha-user-messages")

    account_surfaces.visit_invites(admin)
    expect(account_surfaces).to have_invites_surface
    screenshot_marker(label: "resenha-user-invites")

    account_surfaces.visit_badges(admin)
    expect(account_surfaces).to have_badges_surface
    screenshot_marker(label: "resenha-user-badges")
  end

  context "when viewing mobile", mobile: true do
    it "keeps account management pages within the viewport" do
      account_surfaces.visit_summary(admin)
      expect(account_surfaces).to have_summary_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow
      screenshot_marker(label: "resenha-user-summary-mobile", only: :mobile)

      account_surfaces.visit_preferences(admin)
      expect(account_surfaces).to have_preferences_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow
      screenshot_marker(label: "resenha-user-preferences-mobile", only: :mobile)

      account_surfaces.visit_activity(admin)
      expect(account_surfaces).to have_activity_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow

      account_surfaces.visit_notifications(admin)
      expect(account_surfaces).to have_notifications_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow

      account_surfaces.visit_messages(admin)
      expect(account_surfaces).to have_messages_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow

      account_surfaces.visit_invites(admin)
      expect(account_surfaces).to have_invites_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow

      account_surfaces.visit_badges(admin)
      expect(account_surfaces).to have_badges_surface
      expect(account_surfaces).to have_no_horizontal_page_overflow
      screenshot_marker(label: "resenha-user-badges-mobile", only: :mobile)
    end
  end
end
