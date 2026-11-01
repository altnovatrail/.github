// Trial (T34, never merged): the tests in Node, with their coverage as lcov in coverage/lcov.info,
// and every module of trial/ in it, the ones no test loads too (R19).
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["trial/**/*.test.ts"],
    environment: "node",
    coverage: {
      provider: "v8",
      reporter: ["lcovonly"],
      include: ["trial/**/*.ts"],
      exclude: ["trial/**/*.test.ts"],
    },
  },
});
