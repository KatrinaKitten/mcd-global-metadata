# Global Metadata Convention

## About 

While most datapacks are fairly self-contained, it's not uncommon to need to work with information about other loaded packs such as libraries. These conventions are designed to help assist with that issue, and provide purpose-built methods for cross-pack interactions between packs that implement them.

These conventions are primarily designed to help packs determine whether their dependencies are installed. They can also be used to store generalized information about a pack itself, such as versioning.

You can find an example implementation of this convention in this repository. *DO NOT* directly copy this implementation to your own packs! It is an example of how an implementation should work, not a ready-for-use implementation on its own.

## Pack ID

Throughout this convention, various things will refer to your pack ID (`pack_id`). This should take the form of a namespaced ID, where the namespace is your username or group name and the path is the primary namespace of your pack. This is the same as the recommended value of the `ctc.from` tag on custom items (see [Common Trait Convention](https://mc-datapacks.github.io/en/conventions/common_trait.html)), e.g. `katrinakitten:kats_lightsabers`.

## Loaded Packs

While only library / API packs are required to mark themselves as loaded, it's recommended for all packs to do so regardless of whether they're intended to be relied on by other packs. To mark your pack as loaded, add this command to your load function, or to a new function that runs on the `#minecraft:load` function tag:

```mcfunction
data modify storage global:meta loaded_packs."<pack_id>" set value true
```

Since the load order of datapacks cannot be tightly controlled, you'll need to wait a tick before testing for what packs are loaded. If you need to check this information, add the following to your load function:

```mcfunction
schedule function <namespace>:check_deps 1t
```

You can name the `check_deps` function whatever you want in practice. Inside it, you can access the dependency data as follows. Your `check_deps` function *must* end with the given `schedule` line, in order to ensure proper cleanup of the loaded pack list (alternatively, you can put it in your load function and schedule it for `2t` instead of `1t`).

```mcfunction
# To check if a single dependency exists
execute if data storage global:meta loaded_packs."<pack_id>" run ...

# To check if multiple dependencies exist
execute if data storage global:meta loaded_packs{"<pack_id>":true, "<pack_id>":true, ...} run ...

# To display a message when a required dependency is missing
execute unless data storage global:meta loaded_packs."<pack_id>" run tellraw @a "Missing dependency <pack_id>!"

schedule function global:clear_loaded_packs 1t
```

You *must* also include the `global:clear_loaded_packs` function, which should contain exactly the following:

```mcfunction
data remove storage global:meta loaded_packs
```

Since the loaded pack list only exists for a single tick, and is deleted in the next tick, you should do as much of your dependency-reliant setup within that single tick as possible. Feel free to cache dependency info in storage under your own namespace if you really need to. The global copy of this metadata is intentionally transient to ensure that improper uninstallation will not leave dependencies erroneously marked as loaded.

It's recommended that if you have dependencies which your pack cannot operate without, you both display a warning if they're missing and avoid using `#minecraft:tick`. Instead, you should call your tick function from `check_deps` if all your required dependencies are present (using the multiple dependency check shown above), and add the following to the end of your tick function to create a loop:

```mcfunction
schedule function <namespace>:tick 1t
```

## Pack Metadata

In addition to the loaded packs list, you can optionally store persistent metadata about your pack in the `global:meta` storage, under `pack_info."<pack_id>"`. This data should never be entirely wiped, though you can remove your own pack's data from it in your uninstall function if you prefer. You should not rely on a pack's metadata existing meaning that it's currently loaded; use or cache the loaded packs list as outlined above instead.

**Please don't store operational data about your pack in this area**; it is specifically reserved for meta information about the pack itself, such as version numbers or author information.

If your pack's meta compound is present, it should contain at least the following fields, along with any other metadata you want to include:

- `version.current` (int) The current version number of your pack.
- `version.breaking` (int) The most recent version number of your pack that introduced breaking changes. 
- `author` (string) Your name, username, or the name of your development team.
- `dependencies` (list of strings) The IDs of any packs your pack depends on, if applicable.
- `url` (string) The primary URL of the project, e.g. Github repo, Planet Minecraft page, etc., if applicable.

```mcfunction
# <namespace>:load
data modify global:meta pack_info."<pack_id>".version.current set value 12
data modify global:meta pack_info."<pack_id>".version.breaking set value 10
data modify global:meta pack_info."<pack_id>".author set value "<username>"
```

It's highly recommended that library / API packs supply this information, for example so that dependent packs can additionally check that the version of your pack matches their expected version when checking dependencies.
