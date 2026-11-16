import { expect, test } from "vitest";
import { sum } from "./sum.ts";

test("adds", () => {
  expect(sum(2, 3)).toBe(5);
});
