import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import CategoryDrop from "discourse/select-kit/components/category-drop";
import { i18n } from "discourse-i18n";

export default class ResenhaDiscoveryHeader extends Component {
  @service router;
  @service site;

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
      </section>
    {{/if}}
  </template>
}
