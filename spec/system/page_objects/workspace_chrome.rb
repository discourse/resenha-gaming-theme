# frozen_string_literal: true

module PageObjects
  module Components
    class WorkspaceChrome < PageObjects::Pages::Base
      def has_no_workspace_nav_items?
        has_no_css?(".resenha-rail-nav__item")
      end

      def has_active_admin_rail_item?
        has_css?(".resenha-rail-nav__item a.is-active[aria-current='page'][href^='/admin']")
      end

      def has_rail_logo?
        has_css?(".d-header .home-logo-wrapper-outlet", visible: true)
      end

      def has_aligned_chat_panes?
        has_css?(".c-routes.--channel > .c-navbar-container") &&
          has_css?(".c-routes.--channel-thread > .c-navbar-container") &&
          page.evaluate_script(<<~JS)
            (() => {
              const channelHeader = document.querySelector(
              ".c-routes.--channel > .c-navbar-container"
              );
              const threadHeader = document.querySelector(
              ".c-routes.--channel-thread > .c-navbar-container"
              );
              const channelPane = document.querySelector(".chat-channel");
              const threadPane = document.querySelector(".chat-thread");

              const rectanglesMatch = (first, second) =>
              Math.abs(first.top - second.top) < 1 &&
              Math.abs(first.bottom - second.bottom) < 1;

              return (
                rectanglesMatch(
              channelHeader.getBoundingClientRect(),
              threadHeader.getBoundingClientRect()
                ) &&
                  rectanglesMatch(
                    channelPane.getBoundingClientRect(),
                    threadPane.getBoundingClientRect()
                  )
              );
            })();
          JS
      end
    end
  end
end
