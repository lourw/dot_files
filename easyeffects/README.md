# EasyEffects presets

- `fw13pro.json`: speaker preset for the Framework 13 Pro (EQ → loudness → compressor → limiter).
  Import it in EasyEffects, or copy it to `~/.local/share/easyeffects/output/`.
- `fw13pro-pipewire.conf`: the same preset as a native PipeWire filter-chain, so the effects
  apply without EasyEffects running. It is **not** installed by the Ansible playbook.

## Installing the PipeWire version (manual, per machine)

1. Install the LSP plugins (Arch: `sudo pacman -S lsp-plugins-lv2`).
2. Link the config into PipeWire's drop-in folder:
   ```sh
   mkdir -p ~/.config/pipewire/pipewire.conf.d
   ln -s ~/.config/dot_files/easyeffects/fw13pro-pipewire.conf \
         ~/.config/pipewire/pipewire.conf.d/99-fw13pro.conf
   ```
3. Stop EasyEffects so the effects don't stack: `pkill easyeffects`, and disable its
   autostart entry (`~/.config/autostart/com.github.wwmm.easyeffects.desktop`).
4. Restart PipeWire: `systemctl --user restart pipewire pipewire-pulse wireplumber`
5. Make it the default output: `pactl set-default-sink effect_input.fw13pro`
6. Reload any app that went silent (browsers and Electron apps don't reconnect on their own).

The config targets the laptop's built-in speakers
(`alsa_output.pci-0000_00_1f.3.analog-stereo`). On other hardware, change `target.object`
to your output (`pactl list sinks short`).

To change settings, edit the `.conf` and restart PipeWire (step 4).

## Uninstalling

```sh
rm ~/.config/pipewire/pipewire.conf.d/99-fw13pro.conf
systemctl --user restart pipewire pipewire-pulse wireplumber
```
