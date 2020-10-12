data modify storage global:meta loaded_packs."katrinakitten:example" set value true

data modify global:meta pack_info."katrinakitten:example".version.current set value 1
data modify global:meta pack_info."katrinakitten:example".version.breaking set value 1
data modify global:meta pack_info."katrinakitten:example".author set value "KatrinaKitten"
data modify global:meta pack_info."katrinakitten:example".url set value "https://github.com/KatrinaKitten/mcd-global-metadata"
data modify global:meta pack_info."katrinakitten:example".dependencies set value ["katrinakitten:example_dep"]

# Stop our tick function and schedule a dependency check, which will restart it if all dependencies are present
schedule clear example:tick
schedule function example:check_deps 1t
