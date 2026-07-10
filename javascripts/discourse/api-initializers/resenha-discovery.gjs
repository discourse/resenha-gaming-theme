import { apiInitializer } from "discourse/lib/api";
import ResenhaDiscoveryHeader from "../components/resenha-discovery-header";

export default apiInitializer((api) => {
  api.renderInOutlet("discovery-above", ResenhaDiscoveryHeader);
});
