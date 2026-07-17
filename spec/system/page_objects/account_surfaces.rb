# frozen_string_literal: true

module PageObjects
  module Pages
    class AccountSurfaces < PageObjects::Pages::Base
      def visit_summary(user)
        page.visit("/u/#{user.username}/summary")
        self
      end

      def visit_preferences(user)
        page.visit("/u/#{user.username}/preferences/account")
        self
      end

      def visit_activity(user)
        page.visit("/u/#{user.username}/activity")
        self
      end

      def visit_notifications(user)
        page.visit("/u/#{user.username}/notifications")
        self
      end

      def visit_messages(user)
        page.visit("/u/#{user.username}/messages")
        self
      end

      def visit_invites(user)
        page.visit("/u/#{user.username}/invited")
        self
      end

      def visit_badges(user)
        page.visit("/u/#{user.username}/badges")
        self
      end

      def has_summary_surface?
        has_css?("body.user-summary-page .user-content .top-section")
      end

      def has_preferences_surface?
        has_css?("body.user-preferences-page .user-content.user-preferences")
      end

      def has_activity_surface?
        has_css?("body.user-activity-page .user-content")
      end

      def has_notifications_surface?
        has_css?("body.user-notifications-page .user-content")
      end

      def has_messages_surface?
        has_css?("body.user-messages-page .user-content")
      end

      def has_invites_surface?
        has_css?("body.user-invites-page .user-content")
      end

      def has_badges_surface?
        has_css?("body.user-badges-page .user-content")
      end

      def has_no_horizontal_page_overflow?
        page.evaluate_script(
          "document.documentElement.scrollWidth <= document.documentElement.clientWidth",
        )
      end

      def has_admin_rail_item?
        has_css?(".resenha-rail-nav__item a[href^='/admin']")
      end

      def open_admin_dashboard_from_rail
        find(".resenha-rail-nav__item a[href^='/admin']").click
      end
    end
  end
end
