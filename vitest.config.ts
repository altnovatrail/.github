// Trial (T64, never merged): tests in Node and in the three engines of the stage, one instance a
// browser, named "browser (<engine>)", as app names its own.
import { playwright } from "@vitest/browser-playwright";
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    coverage: {
      provider: "v8",
      include: ["trial/**/*.ts"],
      exclude: ["trial/**/*.test.ts"],
      reporter: ["lcovonly", "text-summary"],
    },
    projects: [
      {
        test: {
          name: "node",
          include: ["trial/**/*.test.ts"],
          exclude: ["trial/**/*.browser.test.ts"],
          environment: "node",
        },
      },
      {
        test: {
          name: "browser",
          include: ["trial/**/*.browser.test.ts"],
          browser: {
            enabled: true,
            provider: playwright(),
            headless: true,
            instances: ["chromium", "webkit", "firefox"].map((browser) => ({
              browser: browser as "chromium" | "webkit" | "firefox",
              name: `browser (${browser})`,
            })),
          },
        },
      },
    ],
  },
});
