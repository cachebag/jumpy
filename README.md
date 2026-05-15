# jumpy

honestly just fucking around idk what im doing

this really doesn't work very well 

## Install

```lua
-- lazy.nvim
{
  "cachebag/jumpy",
  config = function()
    require("jumpy").setup({
      provider = "anthropic", -- or "openai", "openrouter"
    })
  end,
}
```

set your API key: `export ANTHROPIC_API_KEY="sk-ant-..."` (or `OPENAI_API_KEY`, `JUMPY_API_KEY` for openrouter).

## Use

`<leader>j` — open prompt, type your change, hit `<CR>`

`]h` / `[h` — next / prev hunk

`<leader>a` — accept hunk · `<leader>x` — reject hunk

`<leader>A` — accept all · `<leader>X` — reject all

`<leader>r` — reprompt the hunk under cursor

## License

MIT
