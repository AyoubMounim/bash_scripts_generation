# Bash Scripts Generation

Simple shell script for quick generation for new shell scripts. The generation
happens via duplication of some predefined templates stored in some
configuration directory. The default location is
`/usr/local/share/bash_scripts_generation/templates/`. This can be changed
when installing via the `install.sh` script or when executing the script using
the `--templates <templates_dir_path>` command-line option.

For now only one template is supported and must be named
`new_script_template.sh`. More templates may be added in the future.

## Installation

Just run the `install.sh` script inside the repo's root directory.
Use `./install.sh --help` to see install options.

