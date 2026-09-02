import Component from "@glimmer/component";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { modifier } from "ember-modifier";
import { themePrefix } from "virtual:theme";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

// Chat parity: the chat sidebar leads with a "Search chat" row, so forum mode
// leads with the same row, routing to the full search page.
export default class ResenhaSidebarSearch extends Component {
  @service appEvents;
  @service router;

  // "/" routes to search now that the discovery header no longer hosts an
  // inline search input
  setupShortcut = modifier(() => {
    const onShortcut = (appEvent) => {
      if (appEvent.type === "search") {
        appEvent.event?.preventDefault();
        this.router.transitionTo("full-page-search");
      }
    };

    this.appEvents.on("header:keyboard-trigger", onShortcut);

    return () => this.appEvents.off("header:keyboard-trigger", onShortcut);
  });

  get shouldRender() {
    const routeName = this.router.currentRouteName;

    // chat, voice rooms, and AI conversations bring their own sidebar panels
    return (
      !routeName.startsWith("chat") &&
      !routeName.startsWith("voice-room") &&
      !routeName.startsWith("discourse-ai")
    );
  }

  <template>
    {{#if this.shouldRender}}
      <div
        class="sidebar-section resenha-sidebar-search"
        data-section-name="forum-search"
        {{this.setupShortcut}}
      >
        <ul class="sidebar-section-content">
          <li class="sidebar-section-link-wrapper">
            <LinkTo
              @route="full-page-search"
              class="sidebar-section-link sidebar-row"
              title={{i18n (themePrefix "workspace.search")}}
            >
              <span class="sidebar-section-link-prefix icon">
                {{dIcon "magnifying-glass"}}
              </span>
              <span class="sidebar-section-link-content-text">
                {{i18n (themePrefix "workspace.search")}}
              </span>
              <kbd class="resenha-sidebar-search__hint">/</kbd>
            </LinkTo>
          </li>
        </ul>
      </div>
    {{/if}}
  </template>
}
