#include "include/flutter_files_log/flutter_files_log_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_files_log_plugin.h"

void FlutterFilesLogPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_files_log::FlutterFilesLogPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
