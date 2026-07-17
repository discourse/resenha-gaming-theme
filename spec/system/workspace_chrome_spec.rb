# frozen_string_literal: true

require_relative "page_objects/workspace_chrome"

RSpec.describe "Resenha workspace chrome" do
  before { upload_theme }

  fab!(:admin)
  fab!(:member, :user)
  fab!(:channel) { Fabricate(:chat_channel, threading_enabled: true) }
  fab!(:thread) { chat_thread_chain_bootstrap(channel: channel, users: [member, admin]) }

  let(:admin_dashboard) { PageObjects::Pages::AdminDashboard.new }
  let(:chat_page) { PageObjects::Pages::Chat.new }
  let(:preferences_page) { PageObjects::Pages::UserPreferences.new }
  let(:workspace_chrome) { PageObjects::Components::WorkspaceChrome.new }

  before do
    SiteSetting.resenha_enabled = true
    chat_system_bootstrap(member, [channel])
    sign_in(member)
  end

  it "keeps the channel and thread panes aligned" do
    chat_page.visit_thread(thread)

    expect(workspace_chrome).to have_aligned_chat_panes
    screenshot_marker(label: "resenha-chat-thread")
  end

  it "keeps the nav rail on administration and hides its items in preferences" do
    sign_in(admin)

    admin_dashboard.visit
    expect(workspace_chrome).to have_active_admin_rail_item
    expect(workspace_chrome).to have_rail_logo
    screenshot_marker(label: "resenha-admin-dashboard")

    preferences_page.visit(admin)
    expect(workspace_chrome).to have_no_workspace_nav_items
    screenshot_marker(label: "resenha-preferences")
  end
end
