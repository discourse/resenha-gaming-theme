# frozen_string_literal: true

require_relative "page_objects/topic_cards"

RSpec.describe "Resenha topic cards" do
  before { upload_theme }

  fab!(:category)
  fab!(:topic) do
    Fabricate(:topic, category:, title: "Bitstream will not load on my Artix-7 board")
  end

  let(:topic_cards) { PageObjects::Components::TopicCards.new }

  it "shows every topic's category chip" do
    visit("/latest")
    expect(topic_cards).to have_category_chip(topic)
    screenshot_marker(label: "resenha-topic-card", only: :desktop)

    visit(category.url)
    expect(topic_cards).to have_category_chip(topic)
  end

  context "when viewing mobile", mobile: true do
    it "keeps a topic card within the viewport" do
      visit("/latest")

      expect(topic_cards).to have_category_chip(topic)
      expect(topic_cards).to have_no_horizontal_page_overflow
      screenshot_marker(label: "resenha-topic-card-mobile", only: :mobile)
    end
  end
end
