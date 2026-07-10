import HeaderTopicCell from "discourse/components/topic-list/header/topic-cell";
import { withPluginApi } from "discourse/lib/plugin-api";
import ResenhaTopicCard from "../components/card/resenha-topic-card";

const TopicCard = <template>
  <ResenhaTopicCard
    @topic={{@topic}}
    @hideCategory={{@hideCategory}}
    @bulkSelectEnabled={{@bulkSelectEnabled}}
    @isSelected={{@isSelected}}
    @onBulkSelectToggle={{@onBulkSelectToggle}}
  />
</template>;

const CARD_CONTEXTS = ["discovery", "user-activity", "group-activity"];

const isCardContext = ({ listContext, category }) =>
  CARD_CONTEXTS.includes(listContext) && !category?.doc_index_topic_id;

function applyCardLayout(columns) {
  columns.delete("bulk-select");
  columns.delete("topic");
  columns.delete("posters");
  columns.delete("replies");
  columns.delete("likes");
  columns.delete("op-likes");
  columns.delete("views");
  columns.delete("activity");

  columns.add("resenha-card", {
    header: HeaderTopicCell,
    item: TopicCard,
  });
}

export default {
  name: "resenha-topic-list",

  initialize() {
    withPluginApi((api) => {
      api.registerValueTransformer(
        "topic-list-class",
        ({ value: classes, context }) => {
          if (isCardContext(context)) {
            classes.push("--resenha-cards");
          }
          return classes;
        }
      );

      api.registerValueTransformer(
        "topic-list-columns",
        ({ value: columns, context }) => {
          if (isCardContext(context)) {
            applyCardLayout(columns);
          }
          return columns;
        }
      );

      api.registerValueTransformer(
        "topic-list-item-class",
        ({ value: classes, context }) => {
          if (!isCardContext(context)) {
            return classes;
          }

          const { topic } = context;

          if (topic.pinned || topic.pinned_globally) {
            classes.push("--featured");
          }

          return classes;
        }
      );

      api.registerValueTransformer(
        "topic-list-item-mobile-layout",
        ({ value, context }) => {
          if (isCardContext(context)) {
            return false;
          }
          return value;
        }
      );

      api.registerBehaviorTransformer(
        "topic-list-item-click",
        ({ context, next }) => {
          const { event, topic, listContext } = context;

          if (!isCardContext({ listContext, category: topic?.category })) {
            return next();
          }

          if (
            (event.target.closest("a, button, input") &&
              !event.target.closest(".topic-excerpt")) ||
            event.target.closest(".topic-excerpt-more")
          ) {
            return next();
          }

          event.preventDefault();
          event.stopPropagation();

          const topicLink = event.target
            .closest("tr")
            .querySelector("a.raw-topic-link");

          if (event.button === 1) {
            window.open(topicLink.href, "_blank", "noopener,noreferrer");
            return;
          }

          topicLink.dispatchEvent(
            new MouseEvent("click", {
              ctrlKey: event.ctrlKey,
              metaKey: event.metaKey,
              shiftKey: event.shiftKey,
              button: event.button,
              which: event.which,
              bubbles: true,
              cancelable: true,
            })
          );
        }
      );
    });
  },
};
