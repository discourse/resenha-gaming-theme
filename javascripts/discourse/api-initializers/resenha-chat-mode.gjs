import { apiInitializer } from "discourse/lib/api";

// Chat is always full page, never the
// drawer. The preferred mode is a client-side KV flag, so re-asserting it on
// every boot is the supported way to keep chat pinned to full page.
export default apiInitializer((api) => {
  const siteSettings = api.container.lookup("service:site-settings");

  // The chat-state-manager service only exists when the chat plugin is
  // installed and enabled; bail out otherwise.
  if (!siteSettings.chat_enabled) {
    return;
  }

  const chatStateManager = api.container.lookup("service:chat-state-manager");
  chatStateManager?.prefersFullPage();
});
