execute unless data storage global:meta loaded_packs."katrinakitten:example_dep" run tellraw @a "Missing dependency katrinakitten:example_dep!"
execute if data storage global:meta loaded_packs."katrinakitten:example_dep" run function example:tick

schedule function global:clear_loaded_packs 1t
