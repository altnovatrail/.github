import { expect, test } from "vitest";

// Drawn and read back in a real Chromium: a pixel exists only where a browser painted it.
test("paints a canvas in Chromium", () => {
  const canvas = document.createElement("canvas");
  canvas.width = 4;
  canvas.height = 4;
  const context = canvas.getContext("2d");
  if (!context) throw new Error("no 2d context");
  context.fillStyle = "rgb(255, 0, 0)";
  context.fillRect(0, 0, 4, 4);
  expect(Array.from(context.getImageData(1, 1, 1, 1).data)).toEqual([255, 0, 0, 255]);
  expect(navigator.userAgent).toContain("Chrome");
});
