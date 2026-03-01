export def main [] { help nu-plugin-image }

# Build nu_plugin_image from source and register it with Nushell.
#
# Provides `to png` and `from png` commands for converting
# between ANSI text and PNG images.
# Requires Rust (use `toolkit install rust` first).
# Safe to re-run — skips if already installed.
export def install []: nothing -> nothing {
    let cargo_bin = $nu.home-dir | path join .cargo bin

    # Ensure cargo is available
    if (which cargo | is-empty) {
        $env.PATH = ($env.PATH | prepend $cargo_bin)
        if (which cargo | is-empty) {
            error make { msg: "cargo not found — run `toolkit install rust` first" }
        }
    }

    let plugin_path = $cargo_bin | path join nu_plugin_image
    if ($plugin_path | path exists) {
        print $"  (ansi green)nu_plugin_image(ansi reset): already installed"
    } else {
        print "  Installing nu_plugin_image (this may take a few minutes)..."
        ^cargo install --git https://github.com/fmotalleb/nu_plugin_image.git
        print $"  (ansi green)nu_plugin_image(ansi reset): installed"
    }

    print "  Registering plugin..."
    plugin add $plugin_path
    print $"  (ansi green)image plugin(ansi reset): registered — restart Nushell or run: plugin use image"
}
