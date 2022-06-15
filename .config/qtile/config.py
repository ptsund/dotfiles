from os import EX_TEMPFAIL
from typing import List  # noqa: F401

from libqtile import bar, extension, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import subprocess
import shlex

mod = 'mod4'
margin=14
bar_height=40
font='Ubuntu Nerd Font Bold'
font_size=16

def run_once(cmdline):
    cmd = shlex.split(cmdline)
    try:
        subprocess.check_call(['pgrep', cmd[0]])
    except:
        run(cmdline)

def run(cmdline):
    subprocess.Popen(shlex.split(cmdline))

@lazy.function
def suspend(qtile):
    run('systemctl suspend')

@lazy.function
def playpause(qtile):
    run('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause')

@lazy.function
def prev_track(qtile):
    run('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous')

@lazy.function
def next_track(qtile):
    run('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next')

@lazy.function
def lower_volume(qtile):
    run('pactl set-sink-volume @DEFAULT_SINK@ -2%')

@lazy.function
def raise_volume(qtile):
    run('pactl set-sink-volume @DEFAULT_SINK@ +2%')

@lazy.function
def mute_sink(qtile):
    run('pactl set-sink-mute @DEFAULT_SINK@ toggle')

@lazy.function
def mute_source(qtile):
    run('pactl set-source-mute @DEFAULT_SOURCE@ toggle')

color_fg         = '#bbc2cf'
color_bg         = '#111111'
color_bg_alt     = '#191919'
color_red        = '#ff6c6b'
color_orange     = '#ff8418'
color_green      = '#98be65'
color_teal       = '#4db5bd'
color_yellow     = '#ecbe7b'
color_blue       = '#51afef'
color_dark_blue  = '#2257a0'
color_magenta    = '#c678dd'
color_violet     = '#a9a1e1'
color_purple     = '#b93ae5'
color_cyan       = '#46d9ff'
color_dark_cyan  = '#5699af'
color_white      = '#efefef'

# https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.py
keys = [
    Key([mod], 'h', lazy.layout.left(), desc='Move focus to left'),
    Key([mod], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([mod], 'k', lazy.layout.up(), desc='Move focus up'),
    Key([mod], 'l', lazy.layout.right(), desc='Move focus to right'),

    Key([mod], 'a', lazy.spawn('thunderbird'), desc='Launch email app'),
    Key([mod], 'b', lazy.spawn('firefox'), desc='Launch browser'),
    Key([mod], 'c', lazy.spawn('teams'), desc='Launch chat app'),
    Key([mod], 'e', lazy.spawn('code'), desc='Launch editor'),
    Key([mod], 'f', lazy.spawn('alacritty -e bash -c "sleep 0.2; ranger"'), desc='Launch file explorer'),
    Key([mod], 'm', lazy.spawn('spotify'), desc='Launch music app'),
    Key([mod], 'v', lazy.spawn('virt-manager'), desc='Launch virtual machine'),

    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle between layouts'),
    Key([mod], 'comma', lazy.to_screen(1), desc='Move focus to first screen'),
    Key([mod], 'period', lazy.to_screen(0), desc='Move focus to second screen'),
    Key([mod], 'minus', lazy.to_screen(2), desc='Move focus to third screen'),
    Key([mod], 'Return', lazy.spawn('alacritty'), desc='Launch terminal'),

    # Key([mod], 'space', lazy.spawncmd(), desc='Spawn a command using a prompt widget'),
    Key([mod], 'space', lazy.run_extension(extension.DmenuRun(
        dmenu_prompt='>',
        font=font,
        fontsize=font_size,
        background=color_bg_alt,
        foreground=color_fg,
        dmenu_height=bar_height,
        selected_background=color_bg_alt,
        selected_foreground=color_blue
    )), desc='Spawn a command using a prompt widget'),

    Key([mod, 'shift'], 'h', lazy.layout.shuffle_left(), desc='Move window to the left'),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_down(), desc='Move window down'),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_up(), desc='Move window up'),
    Key([mod, 'shift'], 'l', lazy.layout.shuffle_right(), desc='Move window to the right'),
    Key([mod, 'shift'], 'q', lazy.window.kill(), desc='Kill focused window'),
    Key([mod, 'shift'], 'Return', lazy.layout.toggle_split(), desc='Toggle between split and unsplit sides of stack'),
    Key([mod, 'shift'], 'space', lazy.spawn('./scripts/dmwebsearch.sh'), desc='Show websearch prompt'),

    Key([mod, 'control'], 'c', lazy.spawn('alacritty -e bash -c "sleep 0.2; vim ~/.config/qtile/config.py"'), desc='Edit qtile config'),
    Key([mod, 'control'], 'h', lazy.layout.grow_left(), desc='Grow window to the left'),
    Key([mod, 'control'], 'j', lazy.layout.grow_down(), desc='Grow window down'),
    Key([mod, 'control'], 'k', lazy.layout.grow_up(), desc='Grow window up'),
    Key([mod, 'control'], 'l', lazy.layout.grow_right(), desc='Grow window to the right'),
    Key([mod, 'control'], 'n', lazy.layout.normalize(), desc='Reset all window sizes'),
    Key([mod, 'control'], 'q', lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod, 'control'], 'r', lazy.restart(), desc='Restart Qtile'),
    Key([mod, 'control'], 's', suspend, desc='Suspend the computer'),
    Key([mod, 'control'], 'space', lazy.spawn('i3lock -c 111111'), desc='Lock user session'),

    Key([mod, 'mod1'], 'i', mute_source, desc='Mute microphone'),
    Key([mod, 'mod1'], 'm', mute_sink, desc='Mute sound'),
    Key([mod, 'mod1'], 'n', next_track, desc='Next soundtrack'),
    Key([mod, 'mod1'], 'p', prev_track, desc='Previous soundtrack'),
    Key([mod, 'mod1'], 'space', playpause, desc='Play/pause music'),
    Key([mod, 'mod1'], 'KP_Subtract', lower_volume, desc='Lower volume'),
    Key([mod, 'mod1'], 'KP_Add', raise_volume, desc='Raise volume'),
] 

groups = [
    Group('', layout='monadtall', matches=[
        Match(wm_class='firefox')
    ]),
    Group('', layout='monadtall', matches=[
        Match(wm_class='Alacritty')
    ]),
    Group('', layout='monadwide', matches=[
        Match(wm_class='code'),
        Match(wm_class='emacs'),
        Match(wm_class='jetbrains-ridejetbrains-rider')
    ]),
    Group('', layout='monadtall', matches=[
        Match(title='spotify')
    ]),
    Group('', layout='monadtall', matches=[
        Match(wm_class='microsoft teams - preview')
    ]),
    Group('', layout='monadwide', matches=[
        Match(wm_class='Mail'),
        Match(wm_class='Thunderbird')
    ]),
    Group('', layout='max', matches=[
        Match(wm_class='virt-manager')
    ]),
    Group('', layout='max', matches=[
        Match(wm_class='Steam'),
        Match(wm_class='Lutris'),
        Match(wm_class='battle.net.exe'),
        Match(wm_class='wow.exe')
    ]),
    Group('', layout='monadtall')
]

from libqtile.dgroups import simple_key_binder
dgroups_key_binder = simple_key_binder(mod)

# "battery-missing",
# "battery-caution",
# "battery-low",
# "battery-good",
# "battery-full",
# "battery-caution-charging",
# "battery-low-charging",
# "battery-good-charging",
# "battery-full-charging",
# "battery-full-charged",

layouts = [
    layout.Max(),
    layout.MonadTall(
        border_focus=color_orange,
        border_normal='#555555',
        margin=margin
    ),
    layout.MonadWide(
        border_focus=color_orange,
        border_normal='#555555',
        margin=margin
    )
]

widget_defaults = dict(
    font=font,
    fontsize=font_size,
    padding=3,
)
extension_defaults = widget_defaults.copy()

sep = widget.Sep(
    foreground=color_fg,
    padding=24,
    size_percent=50
),

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(margin),
                widget.GroupBox(
                    active=color_purple,
                    block_highlight_text_color=color_orange,
                    borderwidth=0,
                    disable_drag=True,
                    font='Ubuntu Nerd Font',
                    fontsize=18,
                    spacing=20
                ),
                widget.Sep(
                    foreground=color_fg,
                    padding=24,
                    size_percent=50
                ),
                widget.Prompt(),
                widget.WindowName(
                    font='Ubuntu Bold',
                    for_current_screen=True,
                    foreground=color_orange
                ),
                widget.TextBox('',
                    foreground=color_orange,
                ),
                widget.Mpris2(
                    display_metadata=['xesam:artist', 'xesam:title'],
                    foreground=color_orange,
                    name='spotify',
                    objname='org.mpris.MediaPlayer2.spotify',
                    scroll_wait_intervals=-1,
                    mouse_callbacks={
                        'Button1': playpause
                    },
                    stop_pause_text='Not playing'
                ),
                widget.Sep(
                    foreground=color_fg,
                    padding=24,
                    size_percent=50
                ),
                *[widget.Wlan(
                    disconnected_message='睊',
                    foreground=color_green,
                    format='直 {essid}',
                    interface=i
                ) for i in ['wlp3s0', 'wlp9s0']],
                # widget.Sep(
                    # foreground=color_fg,
                    # padding=24,
                    # size_percent=50
                # ),
                # widget.Bluetooth(
                #     hci='/dev_04_5D_4B_29_8F_A7'
                # ),
                widget.Sep(
                    foreground=color_fg,
                    padding=24,
                    size_percent=50
                ),
                widget.CheckUpdates(
                    colour_have_updates='#ff6c6b',
                    colour_no_updates='#2257a0',
                    distro='Arch_Sup',
                    display_format=' {updates}',
                    no_update_string=' 0'
                ),
                widget.Sep(
                    foreground=color_fg,
                    padding=24,
                    size_percent=50
                ),
                widget.Battery(
                    foreground=color_cyan,
                    format='{char} {percent:2.0%}',
                    low_foreground=color_red,
                    notify_below=0.1,
                    charge_char='',
                    discharge_char='',
                    empty_char='',
                    full_char='',
                    unknown_char=''
                ),
                widget.Sep(
                    foreground=color_fg,
                    padding=24,
                    size_percent=50
                ),
                widget.TextBox('墳',
                    foreground=color_magenta
                ),
                widget.PulseVolume(
                    foreground=color_magenta,
                    mouse_callbacks={
                        'Button3': lazy.spawn('pavucontrol')
                    }
                ),
                widget.Sep(
                    foreground=color_fg,
                    padding=24,
                    size_percent=50
                ),
                widget.Systray(),
                widget.Clock(format='%a %d %b %H:%M'),
                widget.Spacer(margin)
            ],
            bar_height,
            background=color_bg_alt
        )
    )
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
cursor_warp = True
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

@hook.subscribe.startup
def startup():
    run_once('dunst')
    run_once('nitrogen --restore')
    run_once('picom')
    run_once('xss-lock -- i3lock -c 111111')
    run_once('nm-applet')
    run_once('bt-agent --capability=NoInputNoOutput')
