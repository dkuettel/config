"""
I assume that the dark version is default
and light is inverted
that means temrinal applications must use colors according to
the dark scheme, and the rest is handled by inverting the base colors
"""

import os
import colors


def dconf(key, value):
	if '"' in value:
		raise ValueError('we dont handle escaping "')
	r = os.system('dconf write %s "%s"' % (key, value))
	if r!=0:
		raise Exception('dconf failed for key %s' % key)


def configure():
	def make(uuid, name, sol2hex):
		conf = lambda key,value: dconf('/org/gnome/terminal/legacy/profiles:/%s/%s' % (uuid, key), value)
		confs = lambda key,value: conf(key, "'%s'" % value)
		confc = lambda key,value: confs(key, '#%s' % format(sol2hex[value], '06x'))
		confs('visible-name', name)
		confc('foreground-color', 'base0')
		confc('bold-color', 'base0')
		confc('background-color', 'base03')
		conf('bold-color-same-as-fg', 'true')
		confc('bold-color', 'base0') # todo base1 might also make sense, but for now bold is set to have no separate color anyway for fg
		conf('use-theme-colors', 'false')
		conf('boldcolor-same-as-fg', 'true') # todo difficult, depends on how well my terminal apps are configured
		confs('cursor-shape', 'block')
		conf('use-system-font', 'false')
		confs('font', 'Ubuntu Mono derivative Powerline 14') # todo robust?
		conf('use-theme-transparency', 'false')
		conf('allow-bold', 'true') # todo same as before, 8+8 or 16 color problem
		conf('palette', '[' + ', '.join("'#%s'" % format(sol2hex[i], '06x') for i in colors.idx2sol) + ']')
	dark_uuid = ':c036e42b-7eed-4429-8bd7-f4655a174e2e'
	light_uuid = ':65b00b9a-02c8-4fab-8ec1-81078f507260'
	make(dark_uuid, 'solarized dark', colors.sol2hex)
	make(light_uuid, 'solarized light', colors.sol2hex_inverted)
	dconf('/org/gnome/terminal/legacy/menu-accelerator-enabled', 'false')
	dconf('/org/gnome/terminal/legacy/default-show-menubar', 'false')
	dconf('/org/gnome/terminal/legacy/keybindings/help', "'disabled'")
	# todo could set .../profiles:/default to "'b1dc...'" for default
	print 'todo: themes are there, but probably not added to the list yet
	# todo strangely, also need to add the two themes to /org/gnome/terminal/legacy/profiles:/list, but not twice if already there, really?
	# todo easiest would be just to list it and regenerate the list instead of parse, adapt, and write (I guess?)


if __name__ == '__main__':
	configure()
