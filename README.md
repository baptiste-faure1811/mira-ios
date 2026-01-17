# Mira — Human‑like AI Chat Experience

**Disclaimer:** You need an OpenAI API key to run the app.

Mira is an iOS chat experience designed to feel like messaging a real person. The goal is presence: natural timing, human‑like pacing, and the small details that make conversations feel alive.

## What it feels like
- Mira can appear **online**, **offline**, or **last seen** to mirror real messaging apps. About 10 seconds after the last message, Mira switches to **last seen**, then 10 seconds later goes **offline**.
- Replies often arrive as **multiple short messages** instead of one long block, just like real texting.
- Mira uses **micro‑delays** and a **typing indicator** to create a natural rhythm.
- Mira can **react to your messages** to feel more expressive and human.
- You can **react to Mira’s messages** as well.
- You can **interrupt** by sending multiple messages; Mira will take them into account and respond accordingly.

## How it works (simple overview)
Messages are captured on the client, sent to an LLM, and then displayed with human‑like pacing and UI behavior. The experience is tuned to make the AI feel present and responsive rather than robotic.

## Why I used AI Proxy
I used **AI Proxy** because I’ve shipped a personal project with it and I’m very familiar with it. It’s complete, easy to use, and lets me swap AI models quickly. Any Swift library could have worked here, but AI Proxy made it fast to build and flexible to iterate on the experience.

## Tool calling (not implemented)
I initially wanted to add tool calling to the LLM chat, but I didn’t have enough time to do it properly. It could have been great to let the AI call tools for things like message reactions, image search, or other utilities. I chose not to include it because it’s not the most important part of this project.

## Chat history (not persisted yet)
For now, chat history is not saved on device. It would be a great feature to reopen the app and keep the conversation, but I didn’t take the time to implement persistence.

## Tools used
- Xcode
- Cursor
- GPT‑5.2 Codex

## Deliverables
- Codebase in this repository
- Short screen recording demo (≤ 1 min)
