if status is-interactive
  # Commands to run in interactive sessions can go here
  cbonsai -l -t 0.001 -m "burn it down" -p
end

# aliases
alias ss='systemctl suspend'
alias vi='nvim'

# fzf
export FZF_DEFAULT_COMMAND='fd -H -t f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Set up fzf key bindings
fzf --fish | source

# yazi
function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


# init zoxide
zoxide init fish | source
