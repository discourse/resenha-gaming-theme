import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { service } from "@ember/service";
import { modifier } from "ember-modifier";
import { themePrefix } from "virtual:theme";
import SearchMenu from "discourse/components/search-menu";
import CategoryDrop from "discourse/select-kit/components/category-drop";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

const SEARCH_INPUT_ID = "welcome-banner-search-input";

export default class ResenhaDiscoveryHeader extends Component {
  @service appEvents;
  @service router;
  @service search;
  @service site;

  // Reuses the welcome-banner integration points: the header keeps
  // `welcomeBannerSearchInViewport` true so the "/" shortcut focuses this
  // search instead of toggling the (hidden) header search, and tags the input
  // with `no-blur` so core does not blur it on route/query-param changes.
  setupSearch = modifier((element) => {
    element.querySelector(`#${SEARCH_INPUT_ID}`)?.classList.add("no-blur");

    this.search.welcomeBannerSearchInViewport = true;

    const focusOnShortcut = (appEvent) => {
      if (appEvent.type === "search") {
        this.search.focusSearchInput();
        appEvent.event?.preventDefault();
      }
    };
    this.appEvents.on("header:keyboard-trigger", focusOnShortcut);

    return () => {
      this.appEvents.off("header:keyboard-trigger", focusOnShortcut);
      this.search.welcomeBannerSearchInViewport = false;
    };
  });

  get shouldRender() {
    return this.router.currentRouteName !== "discovery.categories";
  }

  get topLevelCategories() {
    return (this.site.categoriesList ?? []).filter(
      (category) => !category.parent_category_id
    );
  }

  <template>
    {{#if this.shouldRender}}
      <section class="resenha-discovery-header">
        <div class="resenha-discovery-header__intro">
          <CategoryDrop
            @category={{@outletArgs.category}}
            @categories={{this.topLevelCategories}}
            @options={{hash subCategory=false noSubcategories=false}}
            class="resenha-discovery-header__category-drop"
          />
          <h1 class="resenha-discovery-header__title">
            {{i18n (themePrefix "discovery.title")}}
          </h1>
        </div>

        <div
          class="resenha-discovery-header__search search-menu"
          {{this.setupSearch}}
        >
          {{dIcon
            "magnifying-glass"
            class="resenha-discovery-header__search-icon"
          }}
          <SearchMenu
            @location="welcome-banner"
            @searchInputId={{SEARCH_INPUT_ID}}
            @searchInputPlaceholder={{themePrefix
              "discovery.search_placeholder"
            }}
          />
          <kbd class="resenha-discovery-header__search-hint">/</kbd>
        </div>
      </section>
    {{/if}}
  </template>
}
