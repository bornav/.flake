# self: super: {
#   nvidiaPackages = super.nvidiaPackages.overrideScope' (final: prev: {
#     latest = prev.latest.overrideAttrs (oldAttrs: rec {
#       version = "555.42.02";
#       sha256_64bit = "0aavhxa4jy7jixq1v5km9ihkddr2v91358wf9wk9wap5j3fhidwk";
#       # If needed, update other sha256 values as well
#     #   sha256_aarch64 = "YOUR_SHA256_HASH_AARCH64";
#     #   openSha256 = "YOUR_OPEN_SHA256_HASH";
#     #   settingsSha256 = "YOUR_SETTINGS_SHA256_HASH";
#     #   persistencedSha256 = "YOUR_PERSISTENCED_SHA256_HASH";
      
#       src = super.fetchurl {
#         url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run";
#         sha256 = sha256_64bit;
#       };
#     });
#   });
# }
