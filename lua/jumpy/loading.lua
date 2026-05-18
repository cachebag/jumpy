local M = {}

local FRAMES = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local timer
local dismiss_timer
local active = false
local frame_idx = 1
local start_time = 0
local win
local buf

local function close_ui()
  if win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_close, win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end
  win, buf = nil, nil
end

local function cancel_dismiss()
  if dismiss_timer then
    dismiss_timer:stop()
    dismiss_timer:close()
    dismiss_timer = nil
  end
end

local function open_float(text)
  close_ui()

  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"

  local w = math.min(vim.api.nvim_strwidth(text) + 4, vim.o.columns - 4)
  w = math.max(w, 20)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })

  win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = w,
    height = 1,
    row = math.max(0, vim.o.lines - vim.o.cmdheight - 4),
    col = math.max(0, math.floor((vim.o.columns - w) / 2)),
    style = "minimal",
    border = "rounded",
    zindex = 300,
    focusable = false,
    title = " jumpy ",
    title_pos = "center",
  })
  vim.wo[win].wrap = false
end

local function update_text(text)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local w = math.min(vim.api.nvim_strwidth(text) + 4, vim.o.columns - 4)
  w = math.max(w, 20)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_width(win, w)
  end
end

local function format_elapsed()
  local secs = math.floor((vim.loop.now() - start_time) / 1000)
  if secs < 1 then
    return ""
  end
  return string.format(" %ds", secs)
end

function M.start()
  M.stop()
  active = true
  frame_idx = 1
  start_time = vim.loop.now()

  local text = string.format("  %s  waiting for model…  ", FRAMES[1])
  open_float(text)

  timer = vim.loop.new_timer()
  timer:start(80, 80, vim.schedule_wrap(function()
    if not active then
      return
    end
    frame_idx = frame_idx % #FRAMES + 1
    local line = string.format("  %s  waiting for model…%s  ", FRAMES[frame_idx], format_elapsed())
    update_text(line)
  end))
end

function M.stop()
  active = false
  cancel_dismiss()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
  close_ui()
end

function M.error(msg)
  M.stop()

  local text = string.format("  ✗ %s  ", msg)
  open_float(text)

  dismiss_timer = vim.loop.new_timer()
  dismiss_timer:start(4000, 0, vim.schedule_wrap(function()
    cancel_dismiss()
    close_ui()
  end))
end

return M
