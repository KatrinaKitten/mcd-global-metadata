data modify storage global:meta loaded_packs."katrinakitten:example" set value true

data modify global:meta pack_info."katrinakitten:example".version.current set value 1
data modify global:meta pack_info."katrinakitten:example".version.breaking set value 1
data modify global:meta pack_info."katrinakitten:example".author set value "KatrinaKitten"
data modify global:meta pack_info."katrinakitten:example".url set value "https://github.com/KatrinaKitten/mcd-global-metadata"

schedule function example:check_deps 1t
