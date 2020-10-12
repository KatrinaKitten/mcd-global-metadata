data modify storage global:meta loaded_packs."katrinakitten:example_dep" set value true

data modify global:meta pack_info."katrinakitten:example_dep".version.current set value 1
data modify global:meta pack_info."katrinakitten:example_dep".version.breaking set value 1
data modify global:meta pack_info."katrinakitten:example_dep".author set value "KatrinaKitten"
data modify global:meta pack_info."katrinakitten:example_dep".url set value "https://github.com/KatrinaKitten/mcd-global-metadata"

# We don't need to check dependencies for this pack, so we'll just schedule the cleanup from load
schedule function global:clear_loaded_packs 2t
