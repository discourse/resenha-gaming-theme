# frozen_string_literal: true

module PageObjects
  module Components
    class WorkspaceChrome < PageObjects::Pages::Base
      def has_no_workspace_tabs?
        has_no_css?(".resenha-workspace-tabs")
      end

      def has_active_admin_workspace_tab?
        has_css?(".resenha-workspace-tabs__tab.--admin.is-active[aria-current='page']")
      end

      def has_no_default_header_logo?
        has_no_css?(".d-header .home-logo-wrapper-outlet", visible: true)
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
