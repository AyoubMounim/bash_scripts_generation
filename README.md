# Scripts Generation

Simple shell script for quick generation of simple scripts. The generation
happens via duplication of some predefined templates stored in some
configuration directory. The default location is
`/usr/local/share/scripts_generator/templates/`. This can be changed
when installing via the `install.sh` script or when executing the script using
the `--templates <templates_dir_path>` command-line option.

In the current version the program generates bash scripts only. These are
generated from a template named `bash_script_template.sh`.
More templates for different scripting languages may be added in the future.

## Installation

Just run the `install.sh` script inside the repo's root directory.
Use `./install.sh --help` to see install options.

## Usage

Use the `--help` flag to show a comprehensive description of the program usage.

