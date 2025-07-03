{
  configDir,
  workspaceDir,
  ...
}: {
  xdg.configFile."tms/config.toml".text = ''
    display_full_path = true
    session_sort_order = "LastAttached"
    [[search_dirs]]
    path = "${configDir}"
    depth = 5
    [[search_dirs]]
    path = "${workspaceDir}"
    depth = 5
  '';
}
