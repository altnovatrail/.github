import { expect, test } from "vitest";
import { sum } from "./sum.ts";

// Drawn and read back in a real browser: a pixel exists only where a browser painted it. The user
// agent names the engine, so that the log shows which ran.
test("paints a canvas", () => {
  const canvas = document.createElement("canvas");
  canvas.width = 4;
  canvas.height = 4;
  const context = canvas.getContext("2d");
  if (!context) throw new Error("no 2d context");
  context.fillStyle = "rgb(255, 0, 0)";
  context.fillRect(0, 0, sum(2, 2), 4);
  expect(Array.from(context.getImageData(1, 1, 1, 1).data)).toEqual([255, 0, 0, 255]);
  console.log(`engine: ${navigator.userAgent}`);
});
