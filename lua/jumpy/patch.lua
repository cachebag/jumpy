local M = {}

local function split_lines(text)
  local lines = {}
  local start = 1
  while true do
    local pos = text:find("\n", start, true)
    if pos then
      table.insert(lines, text:sub(start, pos - 1))
      start = pos + 1
    else
      table.insert(lines, text:sub(start))
      break
    end
  end
  return lines
end

local function find_lines(haystack, needle)
  if #needle == 0 then
    return nil
  end
  for i = 1, #haystack - #needle + 1 do
    local match = true
    for j = 1, #needle do
      if haystack[i + j - 1] ~= needle[j] then
        match = false
        break
      end
    end
    if match then
      return i
    end
  end
  return nil
end

function M.parse(text)
  local blocks = {}
  local lines = split_lines(text)
  local i = 1

  while i <= #lines do
    if lines[i]:match("^<<<< SEARCH%s*$") then
      local search_lines = {}
      local replace_lines = {}
      i = i + 1

      while i <= #lines and not lines[i]:match("^====%s*$") do
        table.insert(search_lines, lines[i])
        i = i + 1
      end

      i = i + 1 -- skip ====

      while i <= #lines and not lines[i]:match("^>>>> REPLACE%s*$") do
        table.insert(replace_lines, lines[i])
        i = i + 1
      end

      table.insert(blocks, {
        search = search_lines,
        replace = replace_lines,
      })
    end
    i = i + 1
  end

  return blocks
end

function M.apply(original_lines, response_text)
  local blocks = M.parse(response_text)

  if #blocks == 0 then
    return split_lines(response_text), 0
  end

  local lines = {}
  for _, l in ipairs(original_lines) do
    table.insert(lines, l)
  end

  local unmatched = 0

  for _, block in ipairs(blocks) do
    local pos = find_lines(lines, block.search)
    if pos then
      local new = {}
      for i = 1, pos - 1 do
        table.insert(new, lines[i])
      end
      for _, l in ipairs(block.replace) do
        table.insert(new, l)
      end
      for i = pos + #block.search, #lines do
        table.insert(new, lines[i])
      end
      lines = new
    else
      unmatched = unmatched + 1
    end
  end

  return lines, unmatched
end

return M
