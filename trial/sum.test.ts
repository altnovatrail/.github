import { expect, test } from "vitest";
import { sum } from "./sum.ts";

test("adds in Node", () => {
  expect(sum(2, 3)).toBe(5);
});
