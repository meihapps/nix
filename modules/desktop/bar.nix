{ ... }:
{
  xdg.configFile."ashell/config.toml".text = ''
    [modules]
    left = [ "Workspaces" ]
    center = [ "Tempo", "tasks" ]
    right = [ "Tray", "Privacy", "Settings" ]

    [tempo]
    format = "%Y-%m-%d %H:%M:%S"

    [[CustomModule]]
    name = "tasks"
    type = "Text"
    listen_cmd = "while true; do echo \"{\\\"text\\\": \\\"$(ssh happvps task due.before:now status:pending count 2>/dev/null)\\\", \\\"alt\\\": \\\"\\\"}\"; sleep 5; done"

    [settings]
    remove_airplane_btn = true

[workspaces]
    disable_special_workspaces = true

    # Catppuccin
    [appearance]
    font_name = "Fira Sans"
    success_color = "#a6e3a1"
    text_color = "#cdd6f4"
    workspace_colors = [ "#cba6f7" ]

    [appearance.primary_color]
    base = "#cba6f7"
    text = "#1e1e2e"

    [appearance.danger_color]
    base = "#f38ba8"
    weak = "#f9e2af"

    [appearance.background_color]
    base = "#1e1e2e"
    weak = "#313244"
    strong = "#45475a"

    [appearance.secondary_color]
    base = "#11111b"
    strong = "#1b1b25"
  '';

  xdg.configFile."ashell/tasks.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env fish

      set count (task due.before:now status:pending count 2>/dev/null)
      echo $count
    '';
  };
}
