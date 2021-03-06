from pathlib import Path
from typing import Union

import click
import numpy as np
import skimage
from tabulate import tabulate

# see https://terminalguide.namepad.de/
# see http://www.easyrgb.com/en/math.php
# http://www.brucelindbloom.com/index.html?ColorCalculator.html
# see http://misc.flogisoft.com/bash/tip_colors_and_formatting
# see https://github.com/altercation/solarized


@click.group()
def cli():
    pass


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


def reflow(text: str, columns: int = 50) -> str:
    def words():
        c = 0
        for word in text.split():
            if c < columns:
                yield word
                c += len(word)
            else:
                yield "\n" + word
                c = len(word)

    return " ".join(words())


def print_reflowed(text: str, columns: int = 50):
    print(reflow(text, columns))


@cli.command()
def show_attributes():
    print_reflowed(
        """
        Note that attributes are not always the same inside and outside of tmux.
        Tmux does its own translations to accomodate for different client terminal emulators.
        Here are some attributes:
        """
    )

    def p(code: Union[int, str], desc: str):
        print(f"[0m{code:>4}: [{code}mtest[0m - {desc}")

    p(0, "reset to defaults")
    p(1, "bold, sometimes bright from a 8+8=16 color palette")
    p(2, "faint/dim (most terminals use 1/3 or 2/3 of the original color intensities)")
    p(21, "double underline (by some standard, but 4:2 in alacritty)")
    p(3, "italic")
    p(4, "underline")
    # NOTE for modern codes, colon is needed, those are subcodes
    # semicolons is just legacy from a wide misunderstanding of the standard
    # see https://github.com/terminalguide/terminalguide/issues/9
    p("4:1", "alias for underline")
    p("4:2", "alias for double underline")
    p("4:3", "curly underline")
    p("4:4", "dotted underline")
    p("4:5", "dashed underline")
    # TODO how about different colors for underlines compared to main text color?
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


def hex_to_rgb(hex):
    r = (hex & 0xFF0000) >> 16
    g = (hex & 0x00FF00) >> 8
    b = (hex & 0x0000FF) >> 0
    return (r, g, b)


def hex_from_rgb(rgb):
    return hex_from_rgb_byte((rgb * 255).round().astype(int))


def hex_from_rgb_byte(rgb):
    r, g, b = rgb
    return (r << 16) + (g << 8) + (b << 0)


def hex_to_sgr(hex):
    r, g, b = hex_to_rgb(hex)
    return f"{r};{g};{b}"


def validate_solarized(
    named_colors=solarized_light_named_colors,
    named_indices=solarized_light_named_indices,
):
    print()
    print("validate solarized theme")

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


def hex_to_lab(hex):
    rgb = (
        np.array([(hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8, (hex & 0x0000FF) >> 0])
        / 255.0
    )
    lab = skimage.color.rgb2lab(rgb, illuminant="D65", observer="2")
    return lab


def lab_to_rgb(lab):
    lab = np.array(lab).astype(float)  # row vector
    xyz = skimage.color.lab2xyz(lab, illuminant="D50", observer="2")
    # http://www.brucelindbloom.com/index.html?Eqn_ChromAdapt.html
    # surprisingly, this is not there in skimage
    von_kries_D50_to_D65 = np.array(
        [
            [0.9845002, -0.0546158, 0.0676324],
            [-0.0059992, 1.0047864, 0.0012095],
            [0.0, 0.0, 1.3194581],
        ]
    )
    xyz = xyz @ von_kries_D50_to_D65.T
    rgb = skimage.color.xyz2rgb(xyz)
    return rgb


# TODO why not all like this?
rgb_from_lab = lab_to_rgb


solarized_dark_named_labs = dict(
    base03=(15, -12, -12),
    base02=(20, -12, -12),
    base01=(45, -7, -7),
    base00=(50, -7, -7),
    base0=(60, -6, -3),
    base1=(65, -5, -2),
    base2=(92, -0, 10),
    base3=(97, 0, 10),
    yellow=(60, 10, 65),
    orange=(50, 50, 55),
    red=(50, 65, 45),
    magenta=(50, 65, -5),
    violet=(50, 15, -45),
    blue=(55, -10, -45),
    cyan=(60, -35, -5),
    green=(60, -20, 65),
)
solarized_light_named_labs = dict(solarized_dark_named_labs)
for i in range(4):
    solarized_light_named_labs[f"base{i}"] = solarized_dark_named_labs[f"base0{i}"]
    solarized_light_named_labs[f"base0{i}"] = solarized_dark_named_labs[f"base{i}"]


def sgr_from_lab(lab):
    r, g, b = (lab_to_rgb(lab) * 255).round().astype(int)
    return f"{r};{g};{b}"


def derive_solarized(
    named_colors=solarized_dark_named_colors, named_labs=solarized_dark_named_labs
):

    # TODO https://github.com/altercation/solarized#the-values
    # says white D65 and reference D50, not totally clear to me what is what
    # I think D50 is for CIELAB, the original values
    # and D65 is then for sRGB, that means you need to apply chromatic adaptation
    # von kries gives almost the same results os in his table, but not fully
    # blue is quite a bit off in numbers, but maybe overall it's close enough

    # TODO maybe an opportunity for me to change the colors that are difficult, orange<>red and violet<>blue ?
    # make a matrix to let me see each combination and if they are visible

    print()
    print("test solarized derivation")

    print()
    bases = ["base03", "base02", "base01", "base00", "base0", "base1", "base2", "base3"]
    opposites = dict(zip(bases[:4], bases[4:])) | dict(zip(bases[4:], bases[:4]))
    print(
        "    given bases: "
        + " ".join(
            f"[0;38;2;{hex_to_sgr(named_colors[opposites[base]])};48;2;{hex_to_sgr(named_colors[base])}m{base:8}[0m"
            for base in bases
        )
    )
    print(
        "  derived bases: "
        + " ".join(
            f"[0;38;2;{sgr_from_lab(named_labs[opposites[base]])};48;2;{sgr_from_lab(named_labs[base])}m{base:8}[0m"
            for base in bases
        )
    )

    print()
    accents = ["yellow", "orange", "red", "magenta", "violet", "blue", "cyan", "green"]
    print(
        "  given accents: "
        + " ".join(
            f"[0;38;2;{hex_to_sgr(named_colors['base03'])};48;2;{hex_to_sgr(named_colors[acc])}m{acc:8}[0m"
            for acc in accents
        )
    )
    print(
        "derived accents: "
        + " ".join(
            f"[0;38;2;{sgr_from_lab(named_labs['base03'])};48;2;{sgr_from_lab(named_labs[acc])}m{acc:8}[0m"
            for acc in accents
        )
    )


def get_randomized_solarized_dark():
    # TODO not sure if anywhere I rely on the order of the keys
    theme = dict(
        # base03=(15, -12, -12),
        # base02=(20, -12, -12),
        # base01=(45, -7, -7),
        # base00=(50, -7, -7),
        # base0=(60, -6, -3),
        # base1=(65, -5, -2),
        # base2=(92, -0, 10),
        # base3=(97, 0, 10),
        yellow=(60, 10, 65),
        orange=(50, 50, 55),
        red=(50, 65, 45),
        magenta=(50, 65, -5),
        violet=(50, 15, -45),
        blue=(55, -10, -45),
        cyan=(60, -35, -5),
        green=(60, -20, 65),
    )

    # TODO first considering only dark, so it doesnt have to overlap to make 5+5=8 with light
    start_l = np.random.randint(0, 30)  # 15
    end_l = np.random.randint(50, 80)  # 65
    contrasts = (1, 6, 9, 10)
    assert contrasts[-1] == max(contrasts)
    step = (end_l - start_l) / contrasts[-1]

    theme["base03"] = (start_l, -12, -12)
    theme["base02"] = (start_l + round(contrasts[0] * step), -12, -12)
    theme["base01"] = (start_l + round(contrasts[1] * step), -7, -7)
    theme["base0"] = (start_l + round(contrasts[2] * step), -6, -3)
    theme["base1"] = (start_l + round(contrasts[3] * step), -5, -2)

    theme["base00"] = solarized_dark_named_labs["base3"]
    theme["base2"] = solarized_dark_named_labs["base3"]
    theme["base3"] = solarized_dark_named_labs["base3"]

    # TODO another way to generically dim or light is to just use the origin lab values and scale or shift?
    # especially dim works well, we have -15 space, light is difficult, only 3 left there, if we want to keep the highest

    return theme


def dim_theme(named_labs):
    space = min(l for l, _, _ in named_labs.values())
    assert space > 14, space
    dimmed = {name: (l - space, a, b) for name, (l, a, b) in named_labs.items()}
    return dimmed


def make_tmux_source(
    file=Path("./tmux-theme"),
    named_labs=solarized_dark_named_labs,
    named_indices=solarized_dark_named_indices,
):
    with file.open("wt") as f:
        for name, lab in named_labs.items():
            index = named_indices[name]
            rgb = rgb_from_lab(lab)
            f.write(f"set -p -t .2 'pane-colors[{index}]' '#{hex_from_rgb(rgb):06x}'\n")


# TODO also see if we can reproduce the colors using CIELAB as described?
# from there, can we produce variations, or dimmed versions, for focus in tmux?
# or for randomization
# NOTE it seems like in solarized the basecolors are invertible yes, but you always use only 5 out of 8 there, wasteful?
# then check base16 if that convention there works, to have access to more themes easily

# TODO use tabulate for easier layouts? does it work with escape codes?
# TODO does asciicinema respect 24bit colors? then there are no theme problems anymore for demos, possibly need to run tmux after for that?

if __name__ == "__main__":
    cli()
    # TODO use click to make it easier?
    # show_256_colors()
    # show_16_colors()
    # show_24bit_colors()
    # validate_solarized()
    # derive_solarized()
    # derive_solarized(named_labs=get_randomized_solarized_dark())
    # derive_solarized(named_labs=dim_theme(solarized_dark_named_labs))
    # make_tmux_source(named_labs=dim_theme(solarized_light_named_labs))

# TODO hmm https://iterm2.com/documentation-one-page.html#documentation-escape-codes.html
# lists setting the color palette, so we could have it set by the server? would it remove some config?
# not sure if other support it, but needed? would just minimize config for me maybe
# would allow switching, but then again, we're probably not gonna do that
# alacritty seems better overall, so maybe go with that for ios as well? -> feature parity (even windows?)
# also in the code we can check what's supported, maybe suck it out automated? or watch git log on that file?
