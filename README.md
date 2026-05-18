# jumpy

Inspired by [99](https://github.com/ThePrimeagen/99.git), I, like Prime, wanted a tool to allow for _me_ to still be in the driver seat if I am going to spawn an AI to edit my code.

The main difference between jumpy and other tools, like 99, are:

| | jumpy | other tools |
|---|---|---|
| Diff rendering | Extmark-based inline hunks (add/remove highlights) | None — raw replacement or quickfix |
| Hunk navigation | `]h` / `[h`, per-hunk accept/reject | N/A |
| Per-hunk reprompt | Yes | N/A |
| Search/replace format | Yes (this is for output efficiency) | No — full file via temp file |
| LLM transport | Direct HTTP via curl | Wraps external CLIs (claude, opencode, etc.) |
| Focus | Surgical control over every proposed line | Broader agentic workflows (search, vibe, tutorial) |

Some of these are to be fleshed out, but the sole purpose is to know exactly what I am letting the LLM write into my code. I have no interest in letting it change everything, and only _then_ can I go back and review every change.

That being said, I don't know wtf I'm doing, and right now, this really doesn't work very well. 

But hopefully it will soon :P 

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
