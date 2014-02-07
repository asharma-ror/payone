Deface::Override.new(
  :virtual_path  => "spree/admin/shared/_configuration_menu",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
  :partial       => "spree/admin/shared/configuration_menu_payone_extension",
  :name          => "configuration_menu_payone_extension");
