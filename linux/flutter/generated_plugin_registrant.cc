//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <feda/feda_plugin.h>
#include <flash_api/flash_api_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) feda_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FedaPlugin");
  feda_plugin_register_with_registrar(feda_registrar);
  g_autoptr(FlPluginRegistrar) flash_api_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlashApiPlugin");
  flash_api_plugin_register_with_registrar(flash_api_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
