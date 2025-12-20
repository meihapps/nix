{ ... }:

{
  home.file.".config/karabiner/karabiner.json" = {
    text = builtins.toJSON {
      profiles = [
        {
          complex_modifications = {
            rules = [
              {
                description = "Change caps_lock to Command if pressed with other keys, to escape if pressed alone.";
                manipulators = [
                  {
                    from = {
                      key_code = "caps_lock";
                      modifiers = { optional = ["any"]; };
                    };
                    to = [{ key_code = "left_command"; }];
                    to_if_alone = [{ key_code = "escape"; }];
                    type = "basic";
                  }
                ];
              }
            ];
          };
          name = "Default profile";
          selected = true;
          virtual_hid_keyboard = { keyboard_type_v2 = "ansi"; };
        }
      ];
    };
  };

}
