import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { themePrefix } from "virtual:theme";
import PluginOutlet from "discourse/components/plugin-outlet";
import BulkSelectCheckbox from "discourse/components/topic-list/bulk-select-checkbox";
import TopicExcerpt from "discourse/components/topic-list/topic-excerpt";
import TopicLink from "discourse/components/topic-list/topic-link";
import UnreadIndicator from "discourse/components/topic-list/unread-indicator";
import TopicPostBadges from "discourse/components/topic-post-badges";
import TopicStatus from "discourse/components/topic-status";
import lazyHash from "discourse/helpers/lazy-hash";
import topicFeaturedLink from "discourse/helpers/topic-featured-link";
import dAvatar from "discourse/ui-kit/helpers/d-avatar";
import { categoryLinkHTML } from "discourse/ui-kit/helpers/d-category-link";
import { i18n } from "discourse-i18n";

const MAX_POSTERS = 3;

export default class ResenhaTopicCard extends Component {
  get hasExcerpt() {
    return this.args.topic.hasExcerpt;
  }

  get hasReplies() {
    return this.args.topic.replyCount > 0;
  }

  get posters() {
    const seen = new Set();
    const posters = [];

    for (const poster of this.args.topic.posters ?? []) {
      const user = poster.user;
      if (!user || seen.has(user.username)) {
        continue;
      }

      seen.add(user.username);
      posters.push(poster);

      if (posters.length === MAX_POSTERS) {
        break;
      }
    }

    return posters;
  }

  get replyCountLabel() {
    return i18n(themePrefix("discovery.reply_count"), {
      count: this.args.topic.replyCount,
    });
  }

  get viewCountLabel() {
    return i18n(themePrefix("discovery.view_count"), {
      count: this.args.topic.views,
    });
  }

  @action
  onTitleFocus(event) {
    event.target.closest(".topic-list-item").classList.add("selected");
  }

  @action
  onTitleBlur(event) {
    event.target.closest(".topic-list-item").classList.remove("selected");
  }

  <template>
    <td class="resenha-topic-card">
      {{#if @bulkSelectEnabled}}
        <BulkSelectCheckbox
          @topic={{@topic}}
          @isSelected={{@isSelected}}
          @onToggle={{@onBulkSelectToggle}}
          class="resenha-topic-card__bulk-select"
        />
      {{/if}}

      <div class="resenha-topic-card__chip">
        {{categoryLinkHTML @topic.category}}
      </div>

      <div class="resenha-topic-card__title" role="heading" aria-level="2">
        <TopicLink
          {{on "focus" this.onTitleFocus}}
          {{on "blur" this.onTitleBlur}}
          @topic={{@topic}}
          class="raw-link raw-topic-link"
        />
        {{~#if @topic.featured_link~}}
          &nbsp;{{topicFeaturedLink @topic}}
        {{~/if~}}
        <PluginOutlet
          @name="topic-list-after-title"
          @outletArgs={{lazyHash topic=@topic}}
        />
        <UnreadIndicator @topic={{@topic}} />
        <TopicPostBadges
          @unreadPosts={{@topic.unread_posts}}
          @unseen={{@topic.unseen}}
          @url={{@topic.lastUnreadUrl}}
        />
      </div>

      <div class="resenha-topic-card__status">
        <TopicStatus @topic={{@topic}} @context="topic-list" />
      </div>

      {{#if this.hasExcerpt}}
        <TopicExcerpt @topic={{@topic}} />
      {{/if}}

      <div class="resenha-topic-card__meta">
        {{#if this.posters.length}}
          <div class="resenha-topic-card__posters">
            {{#each this.posters as |poster|}}
              {{dAvatar poster.user imageSize="small"}}
            {{/each}}
          </div>
        {{/if}}

        {{#if this.hasReplies}}
          <span class="resenha-topic-card__stat">{{this.replyCountLabel}}</span>
        {{/if}}

        <span class="resenha-topic-card__stat">{{this.viewCountLabel}}</span>
      </div>
    </td>
  </template>
}
