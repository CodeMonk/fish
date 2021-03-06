# Initializations that should only be performed when entering
# interactive mode.

# This function is called by the __fish_on_interactive function, which
# is defined in config.fish.

function __fish_config_interactive -d "Initializations that should be performed when entering interactive mode"


	# Make sure this function is only run once
	if set -q __fish_config_interactive_done
		return
	end

	set -g __fish_config_interactive_done

	# Set the correct configuration directory
	set -l configdir ~/.config
	if set -q XDG_CONFIG_HOME
		set configdir $XDG_CONFIG_HOME
	end

	# Migrate old (pre 1.22.0) init scripts if they exist
	if not set -q __fish_init_1_22_0

		if test -f ~/.fish_history -o -f ~/.fish -o -d ~/.fish.d -a ! -d $configdir/fish

			# Perform upgrade of configuration file hierarchy

			if not test -d $configdir
				command mkdir $configdir >/dev/null
			end

			if test -d $configdir
				if command mkdir $configdir/fish 
	
					# These files are sometimes overwritten to by fish, so
					# we want backups of them in case something goes wrong

					cp ~/.fishd.(hostname)    $configdir/fish/fishd.(hostname).backup
					cp ~/.fish_history        $configdir/fish/fish_history.backup

					# Move the files

					mv ~/.fish_history        $configdir/fish/fish_history
					mv ~/.fish                $configdir/fish/config.fish
					mv ~/.fish_inputrc        $configdir/fish/fish_inputrc
					mv ~/.fish.d/functions    $configdir/fish/functions
					mv ~/.fish.d/completions  $configdir/fish/completions

					#
					# Move the fishd stuff from another shell to avoid concurrency problems
					#
	
					/bin/sh -c mv\ \~/.fishd.(hostname)\ $configdir/fish/fishd.(hostname)\;kill\ -9\ (echo %fishd)

					# Update paths to point to new configuration locations

					set fish_function_path (printf "%s\n" $fish_function_path|sed -e "s|/usr/local/etc/fish.d/|/usr/local/etc/fish/|")
					set fish_complete_path (printf "%s\n" $fish_complete_path|sed -e "s|/usr/local/etc/fish.d/|/usr/local/etc/fish/|")

					set fish_function_path (printf "%s\n" $fish_function_path|sed -e "s|$HOME/.fish.d/|$configdir/fish/|")
					set fish_complete_path (printf "%s\n" $fish_complete_path|sed -e "s|$HOME/.fish.d/|$configdir/fish/|")

					printf (_ "\nWARNING\n\nThe location for fish configuration files has changed to %s.\nYour old files have been moved to this location.\nYou can change to a different location by changing the value of the variable \$XDG_CONFIG_HOME.\n\n") $configdir

				end 2>/dev/null
			end
		end

		# Make sure this is only done once
		set -U __fish_init_1_22_0
   
	end

	#
	# If we are starting up for the first time, set various defaults
	# 

	if not set -q __fish_init_1_23_0
		if not set -q fish_greeting
			set -l line1 (printf (_ 'Welcome to fish, the friendly interactive shell') )
			set -l line2 (printf (_ 'Type %shelp%s for instructions on how to use fish') (set_color green) (set_color normal))
			set -U fish_greeting $line1\n$line2
		end
		set -U __fish_init_1_23_0

		#
		# Set various defaults using these throwaway functions
		#

		function set_default -d "Set a universal variable, unless it has already been set"
			if not set -q $argv[1]
				set -U -- $argv	
			end
		end

		# Regular syntax highlighting colors
		set_default fish_color_normal normal
		set_default fish_color_command green
		set_default fish_color_redirection normal
		set_default fish_color_comment red
		set_default fish_color_error red --bold
		set_default fish_color_escape cyan
		set_default fish_color_operator cyan
		set_default fish_color_quote brown
		set_default fish_color_valid_path --underline

		set_default fish_color_cwd green
		set_default fish_color_cwd_root red

		# Background color for matching quotes and parenthesis
		set_default fish_color_match cyan

		# Background color for search matches
		set_default fish_color_search_match purple

		# Pager colors
		set_default fish_pager_color_prefix cyan
		set_default fish_pager_color_completion normal
		set_default fish_pager_color_description normal
		set_default fish_pager_color_progress cyan

		#
		# Directory history colors
		#

		set_default fish_color_history_current cyan


		#
		# Setup the CDPATH variable
		#

		set_default CDPATH . ~

		#
		# Remove temporary functions for setting default variable values
		#

		functions -e set_default
	
	end

	#
	# Print a greeting 
	#

	if functions -q fish_greeting
		fish_greeting
	else
		if set -q fish_greeting
			switch $fish_greeting
				case ''
				# If variable is empty, don't print anything, saves us a fork
		
				case '*'
				echo $fish_greeting
			end
		end
	end

	#
	# Set exit message
	#

	function fish_on_exit --description "Commands to execute when fish exits" --on-process %self
		printf (_ "Goodbye\n")
	end

	#
	# This event handler makes sure the prompt is repainted when
	# fish_color_cwd changes value. Like all event handlers, it can't be
	# autoloaded.
	#

	function __fish_repaint --on-variable fish_color_cwd --description "Event handler, repaints the prompt when fish_color_cwd changes"
		if status --is-interactive
			set -e __fish_prompt_cwd
			commandline -f repaint 2>/dev/null
		end
	end

	function __fish_repaint_root --on-variable fish_color_cwd_root --description "Event handler, repaints the prompt when fish_color_cwd_root changes"
		if status --is-interactive
			set -e __fish_prompt_cwd
			commandline -f repaint 2>/dev/null
		end
	end

	#
	# Completions for SysV startup scripts. These aren't bound to any 
	# specific command, so they can't be autoloaded.
	#

	complete -x -p "/etc/init.d/*" -a start --description 'Start service'
	complete -x -p "/etc/init.d/*" -a stop --description 'Stop service'
	complete -x -p "/etc/init.d/*" -a status --description 'Print service status'
	complete -x -p "/etc/init.d/*" -a restart --description 'Stop and then start service'
	complete -x -p "/etc/init.d/*" -a reload --description 'Reload service configuration'

	# Make sure some key bindings are set
	if not set -q fish_key_bindings
		set -U fish_key_bindings fish_default_key_bindings
	end
	
	# Reload keybindings when binding variable change
	function __fish_reload_key_bindings -d "Reload keybindings when binding variable change" --on-variable fish_key_bindings
		eval $fish_key_bindings 2>/dev/null
	end 

	# Load keybindings
	__fish_reload_key_bindings

	# Repaint screen when window changes size
	function __fish_winch_handler --on-signal winch
		commandline -f repaint
	end

	# If the ubuntu command-not-found package can be found, add a handler for it

	# First check in /usr/lib, this is where modern Ubuntus place this command
	if test -f /usr/lib/command-not-found 
		function fish_command_not_found_handler --on-event fish_command_not_found
			/usr/lib/command-not-found $argv
		end
	else 
		# Ubuntu Feisty places this command in the regular path instead
		if type -p command-not-found >/dev/null
			function fish_command_not_found_handler --on-event fish_command_not_found
				command-not-found $argv
			end
		end
	end

end

