import numpy as np
import skimage

# see https://terminalguide.namepad.de/
# see http://misc.flogisoft.com/bash/tip_colors_and_formatting
# see http://ethanschoonover.com/solarized


def show_256_colors():
    print()
    print("256 colors using ESC[38;5;#m and ESC[48;5;#m; only using background")
    print(
        "[mstandard colors: "
        + "".join(f"[0;48;5;{i}m{i:3} " for i in range(8))
        + "[m"
    )
    print(
        "[m'bright' colors: "
        + "".join(f"[0;48;5;{i}m{i:3} " for i in range(8, 16))
        + "[m"
    )
    print("[mmain 6x6x6 color cube = 216 colors:[m")
    for a in range(16, 232, 36):
        print(
            "[m"
            + "".join(
                f"{' ' if (i-a)%6==0 else ''}[0;48;5;{i}m{i:4}[m"
                for i in range(a, a + 35)
            )
            + "[m"
        )
    print(
        "[mgrayscales: "
        + "".join(f"[0;48;5;{i}m{i:4}[m" for i in range(232, 256))
        + "[m"
    )


def show_16_colors():
    print()
    print(
        "16 colors using ESC[#m with #=30-37,90-97 and 40-47,100-107; only using background"
    )
    print(
        "[m          256: "
        + "".join(f"[0;48;5;{i}m{i:3} " for i in range(16))
        + "[m"
    )
    print(
        "[m       normal: "
        + "".join(f"[0;{40+i if i<8 else 100+i-8}m{i:3} " for i in range(16))
        + "[m"
    )
    print(
        "[m  bold/bright: "
        + "".join(f"[0;1;{40+i if i<8 else 100+i-8}m{i:3} " for i in range(16))
        + "[m"
    )
    print(
        "[m    faint/dim: "
        + "".join(f"[0;2;{40+i if i<8 else 100+i-8}m{i:3} " for i in range(16))
        + "[m"
    )


def show_24bit_colors():
    print()
    print("24 bit colors ESC[38;2;r;g;bm and ESC[48;2;r;g;bm; only using background")
    print(
        "[mgrayscales: "
        + "".join(f"[48;2;{i};{i};{i}m " for i in range(0, 256, 2))
        + "[m"
    )
    hsvs = np.linspace([0.0, 0.8, 0.8], [1.0, 0.8, 0.8], 360 // 3)
    rgbs = (skimage.color.hsv2rgb(hsvs) * 255).astype(int)
    print(
        "[m      hues: " + "".join(f"[48;2;{r};{g};{b}m " for r, g, b in rgbs) + "[m"
    )


def show_attributes():
    print()
    print("different attributes:")
    print(
        "(things are often not the same inside and outside tmux, because tmux does its own translations to accomodate for the client terminal emulator)"
    )

    def p(code, label, desc=None):
        print(f"[0m{code:>4}: [{code}m{label}[0m", end="")
        if desc:
            print(f"-> {desc}", end="")
        print()

    p(0, "default")
    p(
        1,
        "bold/bright",
        "usually bold font, sometimes also forces named colors into the bright variant of 8+8=16 color palette",
    )
    p(2, "faint/dim", "most terminals use 1/3 or 2/3 of the original color intensities")
    p(
        21,
        "double underline",
        "tmux does a fallback if the client terminal doesnt support it",
    )
    p(3, "italic")
    p(4, "underline")
    # TODO : vs ; ? I thought it's the same, but it doesnt give the same result, 4;3 is +italic, as it should be
    p("4:3", "curly underline", "using 4:3, not sure from documentation")
    p("4;3", "curly underline", "using 4;3, not sure from documentation")
    p(5, "blink")
    p(6, "fast blink")
    p(7, "inverse")
    p(8, "invisible")
    p(9, "strikethrough")


# see http://ethanschoonover.com/solarized
solarized_dark_named_colors = dict(
    base03=0x002B36,
    base02=0x073642,
    base01=0x586E75,
    base00=0x657B83,
    base0=0x839496,
    base1=0x93A1A1,
    base2=0xEEE8D5,
    base3=0xFDF6E3,
    yellow=0xB58900,
    orange=0xCB4B16,
    red=0xDC322F,
    magenta=0xD33682,
    violet=0x6C71C4,
    blue=0x268BD2,
    cyan=0x2AA198,
    green=0x859900,
)
solarized_dark_named_indices = dict(
    base03=8,
    base02=0,
    base01=10,
    base00=11,
    base0=12,
    base1=14,
    base2=7,
    base3=15,
    yellow=3,
    orange=9,
    red=1,
    magenta=5,
    violet=13,
    blue=4,
    cyan=6,
    green=2,
)

solarized_light_named_colors = dict(solarized_dark_named_colors)
solarized_light_named_indices = dict(solarized_dark_named_indices)
for i in range(4):
    solarized_light_named_colors[f"base{i}"] = solarized_dark_named_colors[f"base0{i}"]
    solarized_light_named_colors[f"base0{i}"] = solarized_dark_named_colors[f"base{i}"]
    # TODO assuming 16c is in "dark reference mode" so indices dont change
    # solarized_light_named_indices[f"base{i}"] = solarized_dark_named_indices[
    #     f"base0{i}"
    # ]
    # solarized_light_named_indices[f"base0{i}"] = solarized_dark_named_indices[
    #     f"base{i}"
    # ]


def hex_to_sgr(hex):
    r = (hex & 0xFF0000) >> 16
    g = (hex & 0x00FF00) >> 8
    b = (hex & 0x0000FF) >> 0
    return f"{r};{g};{b}"


def validate_solarized(
    named_colors=solarized_light_named_colors,
    named_indices=solarized_light_named_indices,
):
    bases = ["base03", "base02", "base01", "base00", "base0", "base1", "base2", "base3"]
    opposites = dict(zip(bases[:4], bases[4:])) | dict(zip(bases[4:], bases[:4]))
    print(
        "  RGB bases: "
        + " ".join(
            f"[0;38;2;{hex_to_sgr(named_colors[opposites[base]])};48;2;{hex_to_sgr(named_colors[base])}m{base:8}[0m"
            for base in bases
        )
    )
    print(
        "  16c bases: "
        + " ".join(
            f"[0;38;5;{named_indices[opposites[base]]};48;5;{named_indices[base]}m{base:8}[0m"
            for base in bases
        )
    )

    accents = ["yellow", "orange", "red", "magenta", "violet", "blue", "cyan", "green"]
    print(
        "RGB accents: "
        + " ".join(
            f"[0;38;2;{hex_to_sgr(named_colors['base03'])};48;2;{hex_to_sgr(named_colors[acc])}m{acc:8}[0m"
            for acc in accents
        )
    )
    print(
        "16c accents: "
        + " ".join(
            f"[0;38;5;{named_indices['base03']};48;5;{named_indices[acc]}m{acc:8}[0m"
            for acc in accents
        )
    )

    # TODO
    # show 16 basecolors once using direct once using indexed
    # this way you can check if you terminal is configured correctly
    # which convention to use? could be parametrized though, default as I did, as solarized I think wanted it
    # also, if using direct, does asciinema respect that? would make it easier
    # could use tmux for making those videos


# TODO also see if we can reproduce the colors using CIELAB as described?
# from there, can we produce variations, or dimmed versions, for focus in tmux?
# or for randomization
# then check base16 if that convention there works, to have access to more themes easily


if __name__ == "__main__":
    # TODO use click to make it easier?
    # show_256_colors()
    # show_16_colors()
    # show_24bit_colors()
    # show_attributes()
    validate_solarized()
