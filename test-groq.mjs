import { query } from "file:///C:/Users/deepa/AppData/Roaming/npm/node_modules/gitclaw/dist/sdk.js";

// Google Gemini needs both env var names
if (process.env.GOOGLE_API_KEY && !process.env.GEMINI_API_KEY) {
  process.env.GEMINI_API_KEY = process.env.GOOGLE_API_KEY;
}

console.log("Testing Google Gemini via pi-ai...");
console.log("GEMINI_API_KEY set:", !!process.env.GEMINI_API_KEY);

try {
  const result = await query({
    dir: "D:\\Lyzr AI\\devmind",
    systemPrompt: "You are a helpful assistant. Reply in one sentence.",
    model: "google:gemini-2.0-flash",
    prompt: "Say hello in one sentence",
  });

  for await (const msg of result) {
    if (msg.type === "delta") process.stdout.write(msg.content);
    if (msg.type === "system" && msg.subtype === "error") {
      console.error("\nERROR:", msg.content);
    }
    if (msg.type === "assistant") {
      console.log("\nFull response:", msg.content);
      console.log("Stop reason:", msg.stopReason);
    }
  }
  console.log("\nSUCCESS - Gemini is working!");
} catch (err) {
  console.error("Fatal error:", err.message);
}
