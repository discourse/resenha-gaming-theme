import { apiInitializer } from "discourse/lib/api";
import ResenhaRailNav from "../components/resenha-rail-nav";
import ResenhaSidebarSearch from "../components/resenha-sidebar-search";
import ResenhaWorkspaceTabs from "../components/resenha-workspace-tabs";

export default apiInitializer((api) => {
  // the desktop nav rail (rail.scss) is too narrow for the full-width logo
  api.registerValueTransformer("home-logo-minimized", ({ value }) => {
    return value || api.container.lookup("service:site").desktopView;
  });

  // desktop: workspace modes live in the nav rail, right under the logo
  api.headerIcons.add("resenha-rail-nav", ResenhaRailNav, {
    before: "search",
  });

  // narrow viewports: workspace modes live in the bottom tab bar
  api.renderInOutlet("after-header", ResenhaWorkspaceTabs);

  // forum search leads the sidebar, mirroring chat's "Search chat" row
  api.renderInOutlet("before-sidebar-sections", ResenhaSidebarSearch);
});
