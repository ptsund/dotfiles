from os import EX_TEMPFAIL
from typing import List  # noqa: F401

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import subprocess
import shlex

mod = 'mod4'
margin=14

keys = [
    Key([mod], 'h', lazy.layout.left(), desc='Move focus to left'),
    Key([mod], 'l', lazy.layout.right(), desc='Move focus to right'),
    Key([mod], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([mod], 'k', lazy.layout.up(), desc='Move focus up'),
    # Key([mod], 'space', lazy.layout.next(), desc='Move window focus to other window'),

    Key([mod, 'shift'], 'h', lazy.layout.shuffle_left(), desc='Move window to the left'),
    Key([mod, 'shift'], 'l', lazy.layout.shuffle_right(), desc='Move window to the right'),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_down(), desc='Move window down'),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_up(), desc='Move window up'),

    Key([mod, 'control'], 'h', lazy.layout.grow_left(), desc='Grow window to the left'),
    Key([mod, 'control'], 'l', lazy.layout.grow_right(), desc='Grow window to the right'),
    Key([mod, 'control'], 'j', lazy.layout.grow_down(), desc='Grow window down'),
    Key([mod, 'control'], 'k', lazy.layout.grow_up(), desc='Grow window up'),
    Key([mod, 'control'], 'n', lazy.layout.normalize(), desc='Reset all window sizes'),
    Key([mod, 'shift'], 'q', lazy.window.kill(), desc='Kill focused window'),

    Key([mod, 'shift'], 'Return', lazy.layout.toggle_split(), desc='Toggle between split and unsplit sides of stack'),
    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle between layouts'),
    Key([mod, 'control'], 'q', lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod, 'control'], 'r', lazy.restart(), desc='Restart Qtile'),
    Key([mod], 'comma', lazy.prev_screen(), desc='Move focus to previous screen'),
    Key([mod], 'period', lazy.next_screen(), desc='Move focus to next screen'),

    Key([mod], 'space', lazy.spawncmd(), desc='Spawn a command using a prompt widget'),
    Key([mod], 'Return', lazy.spawn('alacritty'), desc='Launch terminal'),
    Key([mod], 'b', lazy.spawn('firefox'), desc='Launch browser'),
    Key([mod], 'e', lazy.spawn('code'), desc='Launch editor'),
    Key([mod], 'm', lazy.spawn('spotify'), desc='Launch music app')
]

groups = [
    Group('WWW', layout='monadtall', matches=[
        Match(wm_class='firefox')
    ]),
    Group('TERM', layout='monadtall', matches=[
        Match(wm_class='Alacritty')
    ]),
    Group('DEV', layout='monadtall', matches=[
        Match(wm_class='code')
    ]),
    Group('MUSIC', layout='monadtall', matches=[
        Match(title='Spotify')
    ])
]

from libqtile.dgroups import simple_key_binder
dgroups_key_binder = simple_key_binder(mod)

layouts = [
    # layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(
        border_focus='#51afef',
        border_normal='#555555',
        margin=margin
    ),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(margin),
                widget.GroupBox(
                    
                ),
                widget.Sep(),
                widget.Prompt(),
                widget.WindowTabs(),
                widget.Systray(),
                widget.PulseVolume(),
                widget.Clock(format='%Y-%m-%d %a %I:%M'),
                widget.Spacer(margin)
            ],
            40,
            background='#191919',
            border_color='#222222',
            border_width=[0, 0, 2, 0]
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front())
]

dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = 'smart'
reconfigure_screens = True

auto_minimize = True
wmname = 'LG3D'

def run_once(cmdline):
    cmd = shlex.split(cmdline)
    try:
        subprocess.check_call(['pgrep', cmd[0]])
    except:
        run(cmdline)

def run(cmdline):
    subprocess.Popen(shlex.split(cmdline))

@hook.subscribe.startup
def startup():
    run('xrandr' \
            ' --output DP-2 --mode 1920x1080 --rate 120.01' \
            ' --output DP-3 --primary --mode 2560x1440 --rate 143.96 --right-of DP-2' \
            ' --output HDMI-0 --mode 1920x1080 --rate 60 --right-of DP-3')
    run_once('nitrogen --restore &')
    run_once('pulse &')
