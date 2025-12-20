{ ... }:

{
  homebrew.brews = [
    # Python language and runtime
    "pypy3.10"
    "python@3.13"

    # Python package management and development
    "poetry"

    # Python linting and formatting
    "basedpyright"
    "ruff"
  ];
}
