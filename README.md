# Resenha Gaming

A dark-first Discourse theme for gaming communities running the [Resenha](https://resenha.falco.dev/) voice-rooms plugin. It turns the forum, chat, and live voice rooms into one workspace: persistent Forum / Chat / Live room tabs, a context-aware sidebar, card-style topic lists, full-page chat, and a bottom tab bar on mobile.

Based on the design at <https://resenha.falco.dev/>.

## Features

- **Workspace tabs** — Forum, Chat, and Live room tabs are the site header; on screens narrower than 48rem they become a fixed bottom navigation bar with safe-area support and an unread badge on the Chat tab.
- **Context-aware sidebar** — the Forum tab shows categories and tags, the Chat tab shows channels and direct messages, and the Live room tab shows voice rooms.
- **Card topic lists** — category chip, title, excerpt, poster avatars, and reply/view counts on every discovery and profile list; pinned topics get a featured treatment and solved topics a success-tinted edge.
- **Discovery header** — a category picker and an inline search box above the topic list; the `/` shortcut focuses it.
- **Full-page chat** — chat always opens full page with a single-pill composer and quiet separators.
- **Voice rooms** — a call-control rail, presenter layout styling, and a room chat panel that opens via the Live room tab.

## Requirements

- A recent Discourse (this theme relies on modern core APIs: topic-list transformers, `light-dark()` color tokens, and the `lib/viewport` breakpoint mixins).
- The **Resenha** plugin, installed and enabled (`resenha_enabled: true`).
- **Chat** enabled (`chat_enabled: true`) for the Chat tab, full-page chat, and room chat.
- Optional: **discourse-solved** — solved topics get their badge and card treatment automatically when the plugin is present.

## Installation

Install like any Discourse theme from a git repository:

1. Go to **Admin → Customize → Themes → Install → From a git repository**.
2. Enter this repository's URL and install.
3. Set the theme as default (or user selectable) and pick the **Resenha Night** color scheme for the intended appearance. **Resenha Day** ships as a deliberate cream alternative.

## Recommended site settings

- `resenha_video_enabled: true` — shows the camera and screen-share controls in the call rail.

The Live room tab navigates with `?chat=true` on desktop-sized viewports, so the room chat panel opens alongside the call; share room links with that query param to give others the same view.

## License

MIT
