# jumpy

Inspired by [99](https://github.com/ThePrimeagen/99.git), I, like Prime, wanted a tool to allow for _me_ to still be in the driver seat if I am going to spawn an AI to edit my code.

<img width="1799" height="1029" alt="image" src="https://github.com/user-attachments/assets/dcdd4b2a-49a6-47ed-93e0-618b3b07b324" />

<img width="1798" height="1031" alt="image" src="https://github.com/user-attachments/assets/70913693-98c1-464f-a256-3c7d8b3980e7" />




The main difference between jumpy and other tools, like 99, are:

| feature | jumpy | avante / sidekick | codecompanion inline | claude code / aider |
|---|---|---|---|---|
| Interaction model | Inline prompt → hunks in buffer | Sidebar chat → apply | Inline edit → accept/reject | CLI agent → full file writes |
| Review granularity | Per-hunk accept/reject | Per-file or per-suggestion | Per-change | Post-hoc (git diff) |
| Context switch | None: you stay in buffer | Sidebar opens | Minimal | Leave editor or split terminal |
| LLM output format | Search/replace blocks | Full file / patch | Full file | Full file via temp |
| Token efficiency | High (only changed lines sent back) | Lower (full context) | Lower | Lower |
| Scope | Single targeted edit | Multi-file refactors, chat | Single edit or chat | Whole-project agentic tasks |

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
