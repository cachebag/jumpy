package.path = package.path .. ";lua/?.lua;lua/?/init.lua"

local patch = require("jumpy.patch")

describe("patch.parse", function()
  it("parses a single search/replace block", function()
    local text = table.concat({
      "<<<< SEARCH",
      "old line",
      "====",
      "new line",
      ">>>> REPLACE",
    }, "\n")
    local blocks = patch.parse(text)

    assert.are.equal(1, #blocks)
    assert.are.same({ "old line" }, blocks[1].search)
    assert.are.same({ "new line" }, blocks[1].replace)
  end)

  it("parses multiple blocks", function()
    local text = table.concat({
      "<<<< SEARCH",
      "aaa",
      "====",
      "bbb",
      ">>>> REPLACE",
      "<<<< SEARCH",
      "ccc",
      "====",
      "ddd",
      ">>>> REPLACE",
    }, "\n")
    local blocks = patch.parse(text)

    assert.are.equal(2, #blocks)
    assert.are.same({ "aaa" }, blocks[1].search)
    assert.are.same({ "bbb" }, blocks[1].replace)
    assert.are.same({ "ccc" }, blocks[2].search)
    assert.are.same({ "ddd" }, blocks[2].replace)
  end)

  it("parses multi-line search and replace", function()
    local text = table.concat({
      "<<<< SEARCH",
      "line 1",
      "line 2",
      "line 3",
      "====",
      "new 1",
      "new 2",
      ">>>> REPLACE",
    }, "\n")
    local blocks = patch.parse(text)

    assert.are.equal(1, #blocks)
    assert.are.same({ "line 1", "line 2", "line 3" }, blocks[1].search)
    assert.are.same({ "new 1", "new 2" }, blocks[1].replace)
  end)

  it("parses deletion (empty replace)", function()
    local text = table.concat({
      "<<<< SEARCH",
      "delete me",
      "====",
      ">>>> REPLACE",
    }, "\n")
    local blocks = patch.parse(text)

    assert.are.equal(1, #blocks)
    assert.are.same({ "delete me" }, blocks[1].search)
    assert.are.same({}, blocks[1].replace)
  end)

  it("returns empty for text with no blocks", function()
    local blocks = patch.parse("just some random text\nno blocks here")
    assert.are.equal(0, #blocks)
  end)
end)

describe("patch.apply", function()
  it("applies a single replacement", function()
    local original = { "a", "b", "c" }
    local response = table.concat({
      "<<<< SEARCH",
      "b",
      "====",
      "X",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "a", "X", "c" }, result)
  end)

  it("applies multiple replacements", function()
    local original = { "a", "b", "c", "d", "e" }
    local response = table.concat({
      "<<<< SEARCH",
      "b",
      "====",
      "X",
      ">>>> REPLACE",
      "<<<< SEARCH",
      "d",
      "====",
      "Y",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "a", "X", "c", "Y", "e" }, result)
  end)

  it("applies a deletion", function()
    local original = { "a", "b", "c" }
    local response = table.concat({
      "<<<< SEARCH",
      "b",
      "====",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "a", "c" }, result)
  end)

  it("applies an insertion via context lines", function()
    local original = { "a", "c" }
    local response = table.concat({
      "<<<< SEARCH",
      "a",
      "c",
      "====",
      "a",
      "b",
      "c",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "a", "b", "c" }, result)
  end)

  it("reports unmatched blocks", function()
    local original = { "a", "b", "c" }
    local response = table.concat({
      "<<<< SEARCH",
      "zzz",
      "====",
      "yyy",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(1, unmatched)
    assert.are.same({ "a", "b", "c" }, result)
  end)

  it("falls back to full-file when no blocks found", function()
    local original = { "a", "b" }
    local response = "x\ny\nz"

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "x", "y", "z" }, result)
  end)

  it("handles multi-line search with context", function()
    local original = { "header", "  old1", "  old2", "footer" }
    local response = table.concat({
      "<<<< SEARCH",
      "header",
      "  old1",
      "  old2",
      "====",
      "header",
      "  new1",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "header", "  new1", "footer" }, result)
  end)

  it("preserves indentation exactly", function()
    local original = { "  if true then", "    print('hi')", "  end" }
    local response = table.concat({
      "<<<< SEARCH",
      "    print('hi')",
      "====",
      "    print('hello')",
      ">>>> REPLACE",
    }, "\n")

    local result, unmatched = patch.apply(original, response)
    assert.are.equal(0, unmatched)
    assert.are.same({ "  if true then", "    print('hello')", "  end" }, result)
  end)
end)
