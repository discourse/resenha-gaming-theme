import Component from "@glimmer/component";
import { getOwner } from "@ember/owner";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
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
const MAX_UNREAD_COUNT = 99;

export default class ResenhaWorkspaceTabs extends Component {
  @service capabilities;
  @service currentUser;
  @service resenhaRooms;
  @service router;
  @service siteSettings;

  get chatEnabled() {
    return !!this.siteSettings.chat_enabled;
  }

  // Total unread across every followed channel. Looked up defensively so the
  // theme keeps working when the chat plugin is absent.
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

  get chatUnreadBadge() {
    const count = this.chatUnreadCount;
    return count > MAX_UNREAD_COUNT ? `${MAX_UNREAD_COUNT}+` : count;
  }

  get shouldRender() {
    return (
      // from `sm` up the nav rail carries the workspace modes; the tab bar
      // only exists below that as the bottom navigation
      !this.capabilities.viewport.sm &&
      this.siteSettings.resenha_enabled &&
      !HIDDEN_ROUTES.some((route) =>
        this.router.currentRouteName.startsWith(route)
      )
    );
  }

  get mode() {
    if (this.router.currentRouteName.startsWith("admin")) {
      return "admin";
    }

    if (this.router.currentRouteName.startsWith("chat")) {
      return "chat";
    }

    if (this.router.currentRouteName.startsWith("resenha-room")) {
      return "live";
    }

    return "forum";
  }

  get liveRoom() {
    return (
      this.resenhaRooms.rooms.find(
        (room) => room.active_participants?.length > 0
      ) ?? this.resenhaRooms.rooms[0]
    );
  }

  get hasLiveRoom() {
    return !!this.liveRoom;
  }

  get isForum() {
    return this.mode === "forum";
  }

  get isChat() {
    return this.mode === "chat";
  }

  get isLive() {
    return this.mode === "live";
  }

  get isAdminRoute() {
    return this.mode === "admin";
  }

  get canAccessAdmin() {
    return !!this.currentUser?.admin;
  }

  // Landing from the tab is a "join the conversation" gesture, so bring the
  // room chat panel along — but only on wide viewports. Below lg the plugin
  // renders the room chat as a full-screen drawer, which would land narrow
  // viewports on the chat instead of the room itself.
  get liveRoomQuery() {
    return { chat: this.capabilities.viewport.lg };
  }

  <template>
    {{#if this.shouldRender}}
      <nav
        class="resenha-workspace-tabs"
        aria-label={{i18n (themePrefix "workspace.label")}}
      >
        <div class="resenha-workspace-tabs__modes">
          <LinkTo
            @route="discovery.latest"
            class={{dConcatClass
              "resenha-workspace-tabs__tab"
              (if this.isForum "is-active")
            }}
            aria-current={{if this.isForum "page"}}
          >
            {{dIcon "layer-group"}}
            <span>{{i18n (themePrefix "workspace.forum")}}</span>
          </LinkTo>
          {{#if this.chatEnabled}}
            <LinkTo
              @route="chat"
              class={{dConcatClass
                "resenha-workspace-tabs__tab"
                (if this.isChat "is-active")
              }}
              aria-current={{if this.isChat "page"}}
            >
              {{dIcon "comments"}}
              <span>{{i18n (themePrefix "workspace.chat")}}</span>
              {{#if this.chatUnreadCount}}
                <span class="resenha-workspace-tabs__unread">
                  {{this.chatUnreadBadge}}
                </span>
              {{/if}}
            </LinkTo>
          {{/if}}
          {{#if this.hasLiveRoom}}
            <LinkTo
              @route="resenha-room"
              @model={{this.liveRoom.slug}}
              @query={{this.liveRoomQuery}}
              class={{dConcatClass
                "resenha-workspace-tabs__tab"
                "--live"
                (if this.isLive "is-active")
              }}
              aria-current={{if this.isLive "page"}}
            >
              {{dIcon "wave-square"}}
              <span>{{i18n (themePrefix "workspace.live_room")}}</span>
            </LinkTo>
          {{/if}}
          {{#if this.canAccessAdmin}}
            <LinkTo
              @route="admin"
              class={{dConcatClass
                "resenha-workspace-tabs__tab"
                "--admin"
                (if this.isAdminRoute "is-active")
              }}
              aria-current={{if this.isAdminRoute "page"}}
            >
              {{dIcon "wrench"}}
              <span>{{i18n
                  "sidebar.sections.community.links.admin.content"
                }}</span>
            </LinkTo>
          {{/if}}
        </div>
      </nav>
    {{/if}}
  </template>
}
