{...}: {
  xdg.configFile = {
    "tms/config.toml" = {
      text = ''
        display_full_path = true
        session_sort_order = "LastAttached"
        [[search_dirs]]
        path = "~/Config"
        depth = 2
        [[search_dirs]]
        path = "~/Workspace"
        depth = 2
      '';
    };
  };
}
