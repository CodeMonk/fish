#completion for aptitude

function __fish_apt_no_subcommand  --description 'Test if aptitude has yet to be given the subcommand'
	for i in (commandline -opc)
		if contains -- $i autoclean clean forget-new keep-all update upgrade changelog dist-upgrade download forbid-version hold install keep markauto purge reinstall remove show unhold unmarkauto search help
			return 1
		end
	end
	return 0
end

function __fish_apt_use_package  --description 'Test if aptitude command should have packages as potential completion'
	for i in (commandline -opc)
		if contains -- $i changelog dist-upgrade download forbid-version hold install keep-all markauto purge reinstall remove show unhold unmarkauto
			return 0
		end
	end
	return 1
end

complete -c aptitude -n '__fish_apt_use_package' -a '(__fish_print_packages)'  --description 'Package'

complete -c aptitude -s h -l help  --description 'Display a brief help message. Identical to the help action'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'autoclean'  --description 'Remove any cached packages which can no longer be downloaded'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'clean'  --description 'Remove all downloaded .deb files from the package cache directory'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'forget-new'  --description 'Forget all internal information about what packages are \'new\''
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'keep-all'  --description 'Cancel all scheduled actions on all packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'update'  --description 'Update the list of available packages from the apt sources'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'upgrade'  --description 'Upgrade installed packages to their most recent version'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'changelog'  --description 'Download and displays the Debian changelog for the packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'dist-upgrade'  --description 'Upgrade, removing or installing packages as necessary'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'download'  --description 'Download the packages to the current directory'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'forbid-version'  --description 'Forbid the upgrade to a particular version'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'hold'  --description 'Ignore the packages by future upgrade commands'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'install'  --description 'Install the packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'keep'  --description 'Cancel any scheduled actions on the packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'markauto'  --description 'Mark packages as automatically installed'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'purge'  --description 'Remove and delete all associated configuration and data files'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'reinstall'  --description 'Reinstall the packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'remove'  --description 'Remove the packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'show'  --description 'Display detailed information about the packages'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'unhold'  --description 'Consider the packages by future upgrade commands'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'unmarkauto'  --description 'Mark packages as manually installed'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'search'  --description 'Search for packages matching one of the patterns'
complete -f -n '__fish_apt_no_subcommand' -c aptitude -a 'help'  --description 'Display brief summary of the available commands and options'

complete -c aptitude -s D -l show-deps  --description 'Show explanations of automatic installations and removals'
complete -c aptitude -s d -l download-only  --description 'Download Only'
complete -c aptitude -s f -l fix-broken  --description 'Correct broken dependencies'
complete -c aptitude -l purge-unused  --description 'Purge packages that are not required by any installed package'
complete -c aptitude -s P -l prompt  --description 'Always display a prompt'
complete -c aptitude -s R -l without-recommends  --description 'Do not treat recommendations as dependencies'
complete -c aptitude -s r -l with-recommends  --description 'Treat recommendations as dependencies'
complete -c aptitude -s s -l simulate  --description 'Don\'t perform the actions. Just show them'
complete -c aptitude -l schedule-only  --description 'Schedule operations to be performed in the future'
complete -c aptitude -s q -l quiet  --description 'Suppress incremental progress indicators'
complete -c aptitude -s V -l show-versions  --description 'Show which versions of packages will be installed'
complete -c aptitude -s v -l verbose  --description 'Display extra information'
complete -c aptitude -l version  --description 'Display the version of aptitude and compile information'
complete -c aptitude -l visual-preview  --description 'Start up the visual interface and display its preview screen'
complete -c aptitude -s y -l assume-yes  --description 'Assume the answer yes for all question prompts'
complete -c aptitude -s Z  --description 'Show how much disk space will be used or freed'
complete -r -c aptitude -s F -l display-format  --description 'Specify the format to be used by the search command'
complete -r -c aptitude -s t -l target-release  --description 'Set the release from which packages should be installed'
complete -r -c aptitude -s O -l sort  --description 'Specify the order for the output from the search command'
complete -r -c aptitude -s o  --description 'Set a configuration file option directly'
complete -r -c aptitude -s w -l width  --description 'Specify the display width for the output from the search command'

