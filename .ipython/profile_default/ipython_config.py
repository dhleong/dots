# type: ignore
# flake8: noqa: F821
# Configuration file for ipython.

# ------------------------------------------------------------------------------
# InteractiveShellApp(Configurable) configuration
# ------------------------------------------------------------------------------
# # A Mixin for applications that start InteractiveShell instances.
#
#  Provides configurables for loading extensions and executing files as part of
#  configuring a Shell environment.
#
#  The following methods should be called by the :meth:`initialize` method of the
#  subclass:
#
#    - :meth:`init_path`
#    - :meth:`init_shell` (to be implemented by the subclass)
#    - :meth:`init_gui_pylab`
#    - :meth:`init_extensions`
#    - :meth:`init_code`

# # A list of dotted module names of IPython extensions to load.
#  Default: []
# c.InteractiveShellApp.extensions = []

# # dotted module name of an IPython extension to load.
#  Default: ''
# c.InteractiveShellApp.extra_extension = ''

# # Should variables loaded at startup (by startup files, exec_lines, etc.) be
#  hidden from tools like %who?
#  Default: True
# c.InteractiveShellApp.hide_initial_ns = True

# # Configure matplotlib for interactive use with the default matplotlib backend.
#  Choices: any of ['auto', 'agg', 'gtk', 'gtk3', 'inline', 'ipympl',
#   'nbagg', 'notebook', 'osx', 'pdf', 'ps', 'qt', 'qt4', 'qt5', 'svg', 'tk', 'widget', 'wx'] (case-insensitive) or None
#  Default: None
# c.InteractiveShellApp.matplotlib = None

# # Pre-load matplotlib and numpy for interactive use, selecting a particular
#  matplotlib backend and loop integration.
#  Choices: any of ['auto', 'agg', 'gtk', 'gtk3', 'inline', 'ipympl',
#   'nbagg', 'notebook', 'osx', 'pdf', 'ps', 'qt', 'qt4', 'qt5', 'svg', 'tk', 'widget', 'wx'] (case-insensitive) or None
#  Default: None
# c.InteractiveShellApp.pylab = None

# # If true, IPython will populate the user namespace with numpy, pylab, etc. and
#  an ``import *`` is done from numpy and pylab, when using pylab mode.
#
#  When False, pylab mode should not import any names into the user namespace.
#  Default: True
# c.InteractiveShellApp.pylab_import_all = True

# # Reraise exceptions encountered loading IPython extensions?
#  Default: False
# c.InteractiveShellApp.reraise_ipython_extension_failures = False

# ------------------------------------------------------------------------------
# Application(SingletonConfigurable) configuration
# ------------------------------------------------------------------------------
# # This is an application.

# # The date format used by logging formatters for %(asctime)s
#  Default: '%Y-%m-%d %H:%M:%S'
# c.Application.log_datefmt = '%Y-%m-%d %H:%M:%S'

# # The Logging format template
#  Default: '[%(name)s]%(highlevel)s %(message)s'
# c.Application.log_format = '[%(name)s]%(highlevel)s %(message)s'

# # Set the log level by value or name.
#  Choices: any of [0, 10, 20, 30, 40, 50, 'DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL']
#  Default: 30
# c.Application.log_level = 30

# # Instead of starting the Application, dump configuration to stdout
#  Default: False
# c.Application.show_config = False

# # Instead of starting the Application, dump configuration to stdout (as JSON)
#  Default: False
# c.Application.show_config_json = False

# ------------------------------------------------------------------------------
# TerminalIPythonApp(BaseIPythonApplication, InteractiveShellApp) configuration
# ------------------------------------------------------------------------------

# # A list of dotted module names of IPython extensions to load.
#  See also: InteractiveShellApp.extensions
# c.TerminalIPythonApp.extensions = []

# # Path to an extra config file to load.
#  See also: BaseIPythonApplication.extra_config_file
# c.TerminalIPythonApp.extra_config_file = ''

# # dotted module name of an IPython extension to load.
#  See also: InteractiveShellApp.extra_extension
# c.TerminalIPythonApp.extra_extension = ''

# # If a command or file is given via the command-line, e.g. 'ipython foo.py',
#  start an interactive shell after executing the file or command.
#  Default: False
# c.TerminalIPythonApp.force_interact = False

# # Should variables loaded at startup (by startup files, exec_lines, etc.)
#  See also: InteractiveShellApp.hide_initial_ns
# c.TerminalIPythonApp.hide_initial_ns = True

# # Class to use to instantiate the TerminalInteractiveShell object. Useful for
#  custom Frontends
#  Default: 'IPython.terminal.interactiveshell.TerminalInteractiveShell'
# c.TerminalIPythonApp.interactive_shell_class = 'IPython.terminal.interactiveshell.TerminalInteractiveShell'

# # Configure matplotlib for interactive use with
#  See also: InteractiveShellApp.matplotlib
# c.TerminalIPythonApp.matplotlib = None

# # Run the module as a script.
#  See also: InteractiveShellApp.module_to_run
# c.TerminalIPythonApp.module_to_run = ''

# # Whether to overwrite existing config files when copying
#  See also: BaseIPythonApplication.overwrite
# c.TerminalIPythonApp.overwrite = False

# # The IPython profile to use.
#  See also: BaseIPythonApplication.profile
# c.TerminalIPythonApp.profile = 'default'

# # Pre-load matplotlib and numpy for interactive use,
#  See also: InteractiveShellApp.pylab
# c.TerminalIPythonApp.pylab = None

# # If true, IPython will populate the user namespace with numpy, pylab, etc.
#  See also: InteractiveShellApp.pylab_import_all
# c.TerminalIPythonApp.pylab_import_all = True

# # Start IPython quickly by skipping the loading of config files.
#  Default: False
# c.TerminalIPythonApp.quick = False

# # Reraise exceptions encountered loading IPython extensions?
#  See also: InteractiveShellApp.reraise_ipython_extension_failures
# c.TerminalIPythonApp.reraise_ipython_extension_failures = False

# # Instead of starting the Application, dump configuration to stdout
#  See also: Application.show_config
# c.TerminalIPythonApp.show_config = False

# # Instead of starting the Application, dump configuration to stdout (as JSON)
#  See also: Application.show_config_json
# c.TerminalIPythonApp.show_config_json = False

# # Create a massive crash report when IPython encounters what may be an
#  See also: BaseIPythonApplication.verbose_crash
# c.TerminalIPythonApp.verbose_crash = False

# ------------------------------------------------------------------------------
# InteractiveShell(SingletonConfigurable) configuration
# ------------------------------------------------------------------------------
# # An enhanced, interactive shell for Python.

# # 'all', 'last', 'last_expr' or 'none', 'last_expr_or_assign' specifying which
#  nodes should be run interactively (displaying output from expressions).
#  Choices: any of ['all', 'last', 'last_expr', 'none', 'last_expr_or_assign']
#  Default: 'last_expr'
# c.InteractiveShell.ast_node_interactivity = 'last_expr'

# # A list of ast.NodeTransformer subclass instances, which will be applied to
#  user input before code is run.
#  Default: []
# c.InteractiveShell.ast_transformers = []

# # Automatically run await statement in the top level repl.
#  Default: True
# c.InteractiveShell.autoawait = True

# # Make IPython automatically call any callable object even if you didn't type
#  explicit parentheses. For example, 'str 43' becomes 'str(43)' automatically.
#  The value can be '0' to disable the feature, '1' for 'smart' autocall, where
#  it is not applied if there are no more arguments on the line, and '2' for
#  'full' autocall, where all callable objects are automatically called (even if
#  no arguments are present).
#  Choices: any of [0, 1, 2]
#  Default: 0
# c.InteractiveShell.autocall = 0

# # Autoindent IPython code entered interactively.
#  Default: True
# c.InteractiveShell.autoindent = True

# # Enable magic commands to be called without the leading %.
#  Default: True
# c.InteractiveShell.automagic = True

# # Set the size of the output cache.  The default is 1000, you can change it
#  permanently in your config file.  Setting it to 0 completely disables the
#  caching system, and the minimum value accepted is 3 (if you provide a value
#  less than 3, it is reset to 0 and a warning is issued).  This limit is defined
#  because otherwise you'll spend more time re-flushing a too small cache than
#  working
#  Default: 1000
# c.InteractiveShell.cache_size = 1000

# # Use colors for displaying information about objects. Because this information
#  is passed through a pager (like 'less'), and some pagers get confused with
#  color codes, this capability can be turned off.
#  Default: True
# c.InteractiveShell.color_info = True

# # Set the color scheme (NoColor, Neutral, Linux, or LightBG).
#  Choices: any of ['Neutral', 'NoColor', 'LightBG', 'Linux'] (case-insensitive)
#  Default: 'Neutral'
# c.InteractiveShell.colors = 'Neutral'

#  Default: False
# c.InteractiveShell.debug = False

# # Don't call post-execute functions that have failed in the past.
#  Default: False
# c.InteractiveShell.disable_failing_post_execute = False

# # If True, anything that would be passed to the pager will be displayed as
#  regular output instead.
#  Default: False
# c.InteractiveShell.display_page = False

# # (Provisional API) enables html representation in mime bundles sent to pagers.
#  Default: False
# c.InteractiveShell.enable_html_pager = False

# # Total length of command history
#  Default: 10000
# c.InteractiveShell.history_length = 10000

# # The number of saved history entries to be loaded into the history buffer at
#  startup.
#  Default: 1000
# c.InteractiveShell.history_load_length = 1000

# # Select the loop runner that will be used to execute top-level asynchronous
#  code
#  Default: 'IPython.core.interactiveshell._asyncio_runner'
# c.InteractiveShell.loop_runner = 'IPython.core.interactiveshell._asyncio_runner'

#  Choices: any of [0, 1, 2]
#  Default: 0
# c.InteractiveShell.object_info_string_level = 0

# # Automatically call the pdb debugger after every exception.
#  Default: False
# c.InteractiveShell.pdb = False

# # Show rewritten input, e.g. for autocall.
#  Default: True
# c.InteractiveShell.show_rewritten_input = True

# # Enables rich html representation of docstrings. (This requires the docrepr
#  module).
#  Default: False
# c.InteractiveShell.sphinxify_docstring = False

#  Default: True
# c.InteractiveShell.wildcards_case_sensitive = True

# # Switch modes for the IPython exception handlers.
#  Choices: any of ['Context', 'Plain', 'Verbose', 'Minimal'] (case-insensitive)
#  Default: 'Context'
# c.InteractiveShell.xmode = 'Context'

# ------------------------------------------------------------------------------
# TerminalInteractiveShell(InteractiveShell) configuration
# ------------------------------------------------------------------------------
# #
#  See also: InteractiveShell.ast_node_interactivity
# c.TerminalInteractiveShell.ast_node_interactivity = 'last_expr'

# #
#  See also: InteractiveShell.ast_transformers
# c.TerminalInteractiveShell.ast_transformers = []

# #
#  See also: InteractiveShell.autoawait
# c.TerminalInteractiveShell.autoawait = True

# #
#  See also: InteractiveShell.autocall
# c.TerminalInteractiveShell.autocall = 0

# #
#  See also: InteractiveShell.autoindent
# c.TerminalInteractiveShell.autoindent = True

# #
#  See also: InteractiveShell.automagic
# c.TerminalInteractiveShell.automagic = True

# # The part of the banner to be printed after the profile
#  See also: InteractiveShell.banner2
# c.TerminalInteractiveShell.banner2 = ''

# #
#  See also: InteractiveShell.cache_size
# c.TerminalInteractiveShell.cache_size = 1000

# #
#  See also: InteractiveShell.color_info
# c.TerminalInteractiveShell.color_info = True

# # Set the color scheme (NoColor, Neutral, Linux, or LightBG).
#  See also: InteractiveShell.colors
# c.TerminalInteractiveShell.colors = 'Neutral'

# # Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
#  Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
#  direct exit without any confirmation.
#  Default: True
c.TerminalInteractiveShell.confirm_exit = False

# # Don't call post-execute functions that have failed in the past.
#  See also: InteractiveShell.disable_failing_post_execute
# c.TerminalInteractiveShell.disable_failing_post_execute = False

# # Options for displaying tab completions, 'column', 'multicolumn', and
#  'readlinelike'. These options are for `prompt_toolkit`, see `prompt_toolkit`
#  documentation for more information.
#  Choices: any of ['column', 'multicolumn', 'readlinelike']
#  Default: 'multicolumn'
# c.TerminalInteractiveShell.display_completions = 'multicolumn'

# # If True, anything that would be passed to the pager
#  See also: InteractiveShell.display_page
# c.TerminalInteractiveShell.display_page = False

# # Shortcut style to use at the prompt. 'vi' or 'emacs'.
#  Default: 'emacs'
c.TerminalInteractiveShell.editing_mode = 'vi'

# # Set the editor used by IPython (default to $EDITOR/vi/notepad).
#  Default: '/Applications/MacVim.app/Contents/MacOS/Vim'
# c.TerminalInteractiveShell.editor = '/Applications/MacVim.app/Contents/MacOS/Vim'

# #
#  See also: InteractiveShell.enable_html_pager
# c.TerminalInteractiveShell.enable_html_pager = False

# # Enable vi (v) or Emacs (C-X C-E) shortcuts to open an external editor. This is
#  in addition to the F2 binding, which is always enabled.
#  Default: False
c.TerminalInteractiveShell.extra_open_editor_shortcuts = True

# # Highlight matching brackets.
#  Default: True
# c.TerminalInteractiveShell.highlight_matching_brackets = True

# # The name or class of a Pygments style to use for syntax highlighting. To see
#  available styles, run `pygmentize -L styles`.
#  Default: traitlets.Undefined
# c.TerminalInteractiveShell.highlighting_style = traitlets.Undefined

# # Override highlighting format for specific tokens
#  Default: {}
# c.TerminalInteractiveShell.highlighting_style_overrides = {}

# # Total length of command history
#  See also: InteractiveShell.history_length
# c.TerminalInteractiveShell.history_length = 10000

# #
#  See also: InteractiveShell.history_load_length
# c.TerminalInteractiveShell.history_load_length = 1000

# # Select the loop runner that will be used to execute top-level asynchronous
#  code
#  See also: InteractiveShell.loop_runner
# c.TerminalInteractiveShell.loop_runner = 'IPython.core.interactiveshell._asyncio_runner'

#  See also: InteractiveShell.object_info_string_level
# c.TerminalInteractiveShell.object_info_string_level = 0

# #
#  See also: InteractiveShell.pdb
# c.TerminalInteractiveShell.pdb = False

# # Class used to generate Prompt token for prompt_toolkit
#  Default: 'IPython.terminal.prompts.Prompts'
# c.TerminalInteractiveShell.prompts_class = 'IPython.terminal.prompts.Prompts'

# # Number of line at the bottom of the screen to reserve for the completion menu
#  Default: 6
c.TerminalInteractiveShell.space_for_menu = 12

# #
#  See also: InteractiveShell.sphinxify_docstring
# c.TerminalInteractiveShell.sphinxify_docstring = False

# # Automatically set the terminal title
#  Default: True
# c.TerminalInteractiveShell.term_title = True

# # Customize the terminal title format.  This is a python format string.
#  Available substitutions are: {cwd}.
#  Default: 'IPython: {cwd}'
# c.TerminalInteractiveShell.term_title_format = 'IPython: {cwd}'

# # Use 24bit colors instead of 256 colors in prompt highlighting. If your
#  terminal supports true color, the following command should print 'TRUECOLOR'
#  in orange: printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
#  Default: False
# c.TerminalInteractiveShell.true_color = False

#  See also: InteractiveShell.wildcards_case_sensitive
# c.TerminalInteractiveShell.wildcards_case_sensitive = True

# # Switch modes for the IPython exception handlers.
#  See also: InteractiveShell.xmode
# c.TerminalInteractiveShell.xmode = 'Context'

# ------------------------------------------------------------------------------
# Completer(Configurable) configuration
# ------------------------------------------------------------------------------
# # Experimental: restrict time (in milliseconds) during which Jedi can compute
#  types. Set to 0 to stop computing types. Non-zero value lower than 100ms may
#  hurt performance by preventing jedi to build its cache.
#  Default: 400
# c.Completer.jedi_compute_type_timeout = 400

# # Experimental: Use Jedi to generate autocompletions. Default to True if jedi is
#  installed.
#  Default: True
# c.Completer.use_jedi = True

# ------------------------------------------------------------------------------
# IPCompleter(Completer) configuration
# ------------------------------------------------------------------------------
# # Extension of the completer class with IPython-specific features

# # Enable unicode completions, e.g. \alpha<tab> . Includes completion of latex
#  commands, unicode names, and expanding unicode characters back to latex
#  commands.
#  See also: Completer.backslash_combining_completions
# c.IPCompleter.backslash_combining_completions = True

# # Enable debug for the Completer. Mostly print extra information for
#  experimental jedi integration.
#  See also: Completer.debug
# c.IPCompleter.debug = False

# # Activate greedy completion
#  See also: Completer.greedy
# c.IPCompleter.greedy = False

# # Experimental: restrict time (in milliseconds) during which Jedi can compute
#  types.
#  See also: Completer.jedi_compute_type_timeout
# c.IPCompleter.jedi_compute_type_timeout = 400

# # Whether to merge completion results into a single list
#
#  If False, only the completion results from the first non-empty completer will
#  be returned.
#  Default: True
# c.IPCompleter.merge_completions = True

# # Instruct the completer to omit private method names
#
#  Specifically, when completing on ``object.<tab>``.
#
#  When 2 [default]: all names that start with '_' will be excluded.
#
#  When 1: all 'magic' names (``__foo__``) will be excluded.
#
#  When 0: nothing will be excluded.
#  Choices: any of [0, 1, 2]
#  Default: 2
# c.IPCompleter.omit__names = 2

# # Experimental: Use Jedi to generate autocompletions. Default to True if jedi is
#  installed.
#  See also: Completer.use_jedi
# c.IPCompleter.use_jedi = True

# ------------------------------------------------------------------------------
# ScriptMagics(Magics) configuration
# ------------------------------------------------------------------------------
# # Magics for talking to scripts
#
#  This defines a base `%%script` cell magic for running a cell with a program in
#  a subprocess, and registers a few top-level magics that call %%script with
#  common interpreters.

# # Extra script cell magics to define
#
#  This generates simple wrappers of `%%script foo` as `%%foo`.
#
#  If you want to add script magics that aren't on your path, specify them in
#  script_paths
#  Default: []
# c.ScriptMagics.script_magics = []

# # Dict mapping short 'ruby' names to full paths, such as '/opt/secret/bin/ruby'
#
#  Only necessary for items in script_magics where the default path will not find
#  the right interpreter.
#  Default: {}
# c.ScriptMagics.script_paths = {}

# ------------------------------------------------------------------------------
# LoggingMagics(Magics) configuration
# ------------------------------------------------------------------------------
# # Magics related to all logging machinery.

# # Suppress output of log state when logging is enabled
#  Default: False
# c.LoggingMagics.quiet = False

# ------------------------------------------------------------------------------
# StoreMagics(Magics) configuration
# ------------------------------------------------------------------------------
# # Lightweight persistence for python variables.
#
#  Provides the %store magic.

# # If True, any %store-d variables will be automatically restored when IPython
#  starts.
#  Default: False
# c.StoreMagics.autorestore = False
