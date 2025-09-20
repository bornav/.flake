{
  home.file.".config/zed/keymap.json" = {
    text =
    ''
      [
        {
          "context": "Workspace",
          "bindings": {
            // "ctrl-shift-s": ["editor::Format", "workspace::Save"]
            "ctrl-shift-s": "editor::Format"
          }
        }
      ]
    '';
    force = true;
    mutable = true;
    };
}
