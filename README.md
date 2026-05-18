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
| Keybind     | Action                                    |
| ----------- | ----------------------------------------- |
| `<leader>j` | Open prompt, type your change, hit `<CR>` |
| `]h` / `[h` | Next / previous hunk                      |
| `<leader>a` | Accept hunk                               |
| `<leader>x` | Reject hunk                               |
| `<leader>A` | Accept all hunks                          |
| `<leader>X` | Reject all hunks                          |
| `<leader>r` | Reprompt the hunk under cursor            |

## License

MIT
