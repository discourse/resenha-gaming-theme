import { apiInitializer } from "discourse/lib/api";
import ResenhaWorkspaceTabs from "../components/resenha-workspace-tabs";

export default apiInitializer((api) => {
  api.renderInOutlet("after-header", ResenhaWorkspaceTabs);
});
