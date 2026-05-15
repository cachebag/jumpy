if exists('g:loaded_jumpy')
  finish
endif
let g:loaded_jumpy = 1

lua require('jumpy').auto_setup()
