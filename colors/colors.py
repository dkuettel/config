# coding=utf-8

# see http://misc.flogisoft.com/bash/tip_colors_and_formatting
# see http://ethanschoonover.com/solarized


import sys


def print256(out):
	def t(c):
		out.write('[0m')
		for a in range(16):
			for b in range(16):
				out.write('[%(c)d;5;%(i)dm%(i)#5d' % dict(c=c, i=a*16+b))
			out.write('[0m\n')
	out.write('[0m256 foreground:\n')
	t(38)
	out.write('[0m\n256 background:\n')
	t(48)


def print16(out):
	def print_table(default, normal, bold):
		out.write('default:' + ' '.join(map(default, range(16))) + '\n')
		out.write('normal :' + ' '.join(map(normal, range(16))) + '\n')
		out.write('bold   :' + ' '.join(map(bold, range(16))) + '\n')
	out.write('[0m16 colors (showing ^[[xm for number and caret, ^[[38;5;xm for caret)\n')
	out.write('[0m16 foreground:\n')
	print_table(
			default = lambda i: '[0;39m%(i)#2d██[0m' % dict(i=i),
			normal = lambda i: '[0;%(c)dm%(i)#2d█[0;38;5;%(i)dm█[0m' % dict(i=i, c=(30+i) if i<8 else (90+i-8) ),
			bold = lambda i: '[0;1;%(c)dm%(i)#2d█[0;1;38;5;%(i)dm█[0m' % dict(i=i, c=(30+i) if i<8 else (90+i-8) ),
		)
	out.write('[0m16 background:\n')
	print_table(
			default = lambda i: '[0;49m%(i)#2d  [0m' % dict(i=i),
			normal = lambda i: '[0;%(c)dm%(i)#2d [0;48;5;%(i)dm [0m' % dict(i=i, c=(40+i) if i<8 else (100+i-8) ),
			bold = lambda i: '[0;1;%(c)dm%(i)#2d [0;1;48;5;%(i)dm [0m' % dict(i=i, c=(40+i) if i<8 else (100+i-8) ),
		)


sol2hex = dict(
		base03  = 0x002b36,
		base02  = 0x073642,
		base01  = 0x586e75,
		base00  = 0x657b83,
		base0   = 0x839496,
		base1   = 0x93a1a1,
		base2   = 0xeee8d5,
		base3   = 0xfdf6e3,
		yellow  = 0xb58900,
		orange  = 0xcb4b16,
		red     = 0xdc322f,
		magenta = 0xd33682,
		violet  = 0x6c71c4,
		blue    = 0x268bd2,
		cyan    = 0x2aa198,
		green   = 0x859900,
	)

sol2idx = dict(
		base03  = 8,
		base02  = 0,
		base01  = 10,
		base00  = 11,
		base0   = 12,
		base1   = 14,
		base2   = 7,
		base3   = 15,
		yellow  = 3,
		orange  = 9,
		red     = 1,
		magenta = 5,
		violet  = 13,
		blue    = 4,
		cyan    = 6,
		green   = 2,
	)


def print_solarized16(out):
	# see http://ethanschoonover.com/solarized (bottom for dark vs light theme)
	def table(colors):
		col = max(max(map(len, colors)), 8)
		out.write('names     : ' + ' '.join(b.center(col) for b in colors) + '\n')
		out.write('hexes     : ' + ' '.join(format(sol2hex[i], '#08x') for i in colors) + '\n')
		out.write('[xm       : ' + ' '.join('[0;%dm%s[0m' % (30+sol2idx[i] if sol2idx[i]<8 else (90+sol2idx[i]-8), '█'*col) for i in colors) + '[0m\n')
		out.write(' +bold    : ' + ' '.join('[0;%s%dm%s[0m' % ('' if sol2idx[i]<8 else '1;',30+sol2idx[i] if sol2idx[i]<8 else (30+sol2idx[i]-8), '█'*col) for i in colors) + '[0m\n')
		out.write('[38;5;xm  : ' + ' '.join('[0;38;5;%dm%s[0m' % (sol2idx[i], '█'*col) for i in colors) + '[0m\n')
		red = lambda i: (sol2hex[i] & 0xff0000) >> 16
		green = lambda i: (sol2hex[i] & 0x00ff00) >> 8
		blue = lambda i: (sol2hex[i] & 0x0000ff) >> 0
		out.write('[38;2;rgb : ' + ' '.join('[38;2;%d;%d;%dm%s[0m' % (red(i), green(i), blue(i), '█'*col) for i in colors) + '[0m\n')
	out.write('solarized 16 bases\n')
	bases = ['base03', 'base02', 'base01', 'base00', 'base0', 'base1', 'base2', 'base3']
	table(bases)
	out.write('\n')
	out.write('solarized 16 accents\n')
	accents = ['yellow', 'orange', 'red', 'magenta', 'violet', 'blue', 'cyan', 'green']
	table(accents)
	out.write('\n')


print256(sys.stdout)
print
print16(sys.stdout)
print
print_solarized16(sys.stdout)

