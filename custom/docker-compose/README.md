all compose files must be with .yml file extention

to create the docker-compose.nix file you run ```compose2nix -runtime docker -project=myproject```

after change top of the compose to this 
```{ lib, config, pkgs, pkgs-unstable, inputs, vars, ... }:
with lib;```

and wrap the content inside od {} with the conditional example if ```docker-name.enabled == true```

```config = mkIf (config.docker-name.enable) { ```