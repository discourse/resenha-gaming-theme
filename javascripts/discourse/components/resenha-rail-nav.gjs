import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { getOwner } from "@ember/owner";
import { service } from "@ember/service";
import { settings, themePrefix } from "virtual:theme";
import getURL from "discourse/lib/get-url";
import DiscourseURL from "discourse/lib/url";
import dConcatClass from "discourse/ui-kit/helpers/d-concat-class";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

const HIDDEN_ROUTES = [
  "login",
  "login-preferences",
  "password-reset",
  "preferences",
  "signup",
];

// The workspace modes rendered as icons in the core left nav rail, right under
// the logo. Items come from the rail_nav_items theme setting; an item with a
// blank URL means "the most active voice room" and is dropped when the voice
// plugin (or every room) is absent.
export default class ResenhaRailNav extends Component {
  @service currentUser;
  @service router;
  @service site;

  get showAdmin() {
    return !!this.currentUser?.admin;
  }

  get adminActive() {
    return this.mode === "admin";
  }

  get adminHref() {
    return getURL("/admin");
  }

  get shouldRender() {
    return (
      this.site.desktopView &&
      !HIDDEN_ROUTES.some((route) =>
        this.router.currentRouteName.startsWith(route)
      )
    );
  }

  get chatUnreadCount() {
    const channelsManager = getOwner(this)?.lookup(
      "service:chat-channels-manager"
    );

    if (!channelsManager) {
      return 0;
    }

    return (channelsManager.allChannels ?? []).reduce(
      (total, channel) => total + (channel.tracking?.unreadCount ?? 0),
      0
    );
  }

  get liveRoomUrl() {
    const rooms = getOwner(this)?.lookup("service:resenha-rooms")?.rooms ?? [];
    const room =
      rooms.find((r) => r.active_participants?.length > 0) ?? rooms[0];

    return room ? `/resenha/r/${room.slug}` : null;
  }

  get mode() {
    const routeName = this.router.currentRouteName;

    if (routeName.startsWith("chat")) {
      return "chat";
    }

    if (routeName.startsWith("resenha-room")) {
      return "voice";
    }

    if (routeName.startsWith("discourse-ai")) {
      return "ai";
    }

    if (routeName.startsWith("admin")) {
      return "admin";
    }

    return "forum";
  }

  kindFor(url) {
    if (url.startsWith("/chat")) {
      return "chat";
    }

    if (url.startsWith("/resenha")) {
      return "voice";
    }

    if (url.startsWith("/discourse-ai")) {
      return "ai";
    }

    return "forum";
  }

  get items() {
    return (settings.rail_nav_items ?? [])
      .map((item) => {
        const url = item.url || this.liveRoomUrl;

        if (!url) {
          return null;
        }

        const kind = this.kindFor(url);
        const unreadCount = kind === "chat" ? this.chatUnreadCount : 0;

        return {
          ...item,
          href: getURL(url),
          active: kind === this.mode,
          unreadCount,
          label: unreadCount
            ? i18n(themePrefix("rail_nav.unread"), {
                name: item.name,
                count: unreadCount,
              })
            : item.name,
        };
      })
      .filter(Boolean);
  }

  @action
  navigate(event) {
    if (
      event.metaKey ||
      event.ctrlKey ||
      event.shiftKey ||
      event.altKey ||
      event.button !== 0
    ) {
      return;
    }

    event.preventDefault();
    DiscourseURL.routeTo(event.currentTarget.getAttribute("href"));
  }

  <template>
    {{#if this.shouldRender}}
      {{#each this.items as |item|}}
        <li class="resenha-rail-nav__item header-dropdown-toggle">
          <a
            class={{dConcatClass
              "resenha-rail-nav__link"
              "icon"
              (if item.active "is-active")
            }}
            href={{item.href}}
            title={{item.label}}
            aria-label={{item.label}}
            aria-current={{if item.active "page"}}
            {{on "click" this.navigate}}
          >
            {{dIcon item.icon}}
            {{#if item.unreadCount}}
              <span class="resenha-rail-nav__unread" aria-hidden="true"></span>
            {{/if}}
          </a>
        </li>
      {{/each}}
      {{#if this.showAdmin}}
        <li class="resenha-rail-nav__item header-dropdown-toggle">
          <a
            class={{dConcatClass
              "resenha-rail-nav__link"
              "icon"
              (if this.adminActive "is-active")
            }}
            href={{this.adminHref}}
            title={{i18n "sidebar.sections.community.links.admin.content"}}
            aria-label={{i18n "sidebar.sections.community.links.admin.content"}}
            aria-current={{if this.adminActive "page"}}
            {{on "click" this.navigate}}
          >
            {{dIcon "wrench"}}
          </a>
        </li>
      {{/if}}
    {{/if}}
  </template>
}
