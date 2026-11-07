# synergy

Keyboard/mouse sharing between the CachyOS desktop (server) and the MacBook Pro 2019,
which dual-boots macOS and Windows (Boot Camp). Synergy 3.9.1 from Symless (`synergy`
pacman package, installs to `/opt/Synergy`).

## Layout

The desktop is the server. Both MacBook OSes are clients on the desktop's left edge:
top 43% of the edge goes to Boot Camp (Windows), the rest to macOS. Boot Camp sits above
macOS. Only one of them is ever up, since they're the same machine.

| Screen name | Machine |
|---|---|
| `cachydesktop-6212ada0` | this desktop (server) |
| `bootcamp-c222e8e6` | MacBook, Windows via Boot Camp |
| `macbookpro-dba28767` | MacBook, macOS |

Ctrl+L toggles locking the cursor to the current screen.

## Files

| Repo file | Installs to | What |
|---|---|---|
| `synergy.conf` | `~/.config/Synergy/synergy.conf` | screens, links, options (external server config) |
| `synergy-core.conf` | `~/.config/Synergy/synergy-core.conf` | core settings: server mode, port 24800, TLS on, fingerprint check |
| `synergy-tools.desktop` | `~/.config/autostart/synergy-tools.desktop` | autostarts `~/.local/bin/synergy-tools` ("audio and files to your other PC") |

Not in the repo, on purpose: `~/.config/Synergy/synergyCert.pem` (TLS private key),
`~/.config/Synergy/local.json` (license/serial), `~/.config/Synergy/tls/` and
`SSL/Fingerprints/` (trusted peers), `~/.config/synergy-tools/partners` (pairing key for
the Boot Camp side), and the `~/.config/synergy/` Electron cache. Synergy regenerates the
cert and asks to re-trust peers on a fresh install.

## How it runs

`synergy-3.service` (systemd user unit from the package, bound to
`graphical-session.target`) runs `/opt/Synergy/synergy-service -d`, which spawns the
tray and `synergy-core server --settings ~/.config/Synergy/synergy-core.conf`.
`~/.config/openbox/autostart` starts the GUI with `/opt/Synergy/synergy &`. Use the full
path: since 3.9.1 the package puts nothing on PATH, so a bare `synergy &` silently fails.
`synergy-tools` starts from the XDG autostart entry above. Its binary came from the
`synergy-tools-linux-x86_64` download (copy in `~/Downloads`), installed as
`~/.local/bin/synergy-tools`.

## Restore

```sh
sudo pacman -S synergy        # or the Symless package
cp synergy.conf synergy-core.conf ~/.config/Synergy/
cp synergy-tools.desktop ~/.config/autostart/
systemctl --user restart synergy-3.service
```

`synergy-core.conf` has absolute `/home/zpt/...` paths; edit them for another user.
