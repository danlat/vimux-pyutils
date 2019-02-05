if !has('python3')
  finish
endif

python3 << endpython
import re

def run_tmux_python_chunk():
  """
  Will copy/paste the currently selected block into the tmux split.
  The code is unindented so the first selected line has 0 indentation
  So you can select a statement from inside a function and it will run
  without python complaining about indentation.
  """
  r = vim.current.range
  #vim.command("echo 'Range : %i %i'" % (r.start, r.end))
  # Count indentation on first selected line
  firstline = vim.current.buffer[r.start]
  nindent = len(firstline) - len(firstline.lstrip(' '))
  # vim.command("echo '%i'" % nindent)

  # Shift the whole text by nindent spaces (so the first line has 0 indent)
  lines = vim.current.buffer[r.start:r.end+1]
  if nindent > 0:
    pat = '\s'*nindent
    lines = [re.sub('^%s'%pat, '', l) for l in lines]

  # Add empty newline at the end
  lines.append('\n')
  l = "\n".join(lines)
  l = l.replace('\\', '\\\\')
  l = l.replace('"', '\\"')

  vim.command(':call VimuxRunCommand("\e[200~{}\e[201~\n", 0)'.format(l))

  # Move cursor to the end of the selection
  vim.current.window.cursor=(r.end+1, 0)

endpython

vmap <silent> <C-c> :python3 run_tmux_python_chunk()<CR>


