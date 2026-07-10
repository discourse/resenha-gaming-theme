# frozen_string_literal: true

module PageObjects
  module Components
    class TopicCards < PageObjects::Pages::Base
      def has_category_chip?(topic)
        has_css?(
          ".topic-list-item[data-topic-id='#{topic.id}'] .resenha-topic-card__chip .badge-category",
          text: topic.category.name,
        )
      end

      def has_no_horizontal_page_overflow?
        page.evaluate_script(
          "document.documentElement.scrollWidth <= document.documentElement.clientWidth",
        )
      end
    end
  end
end
