# EasyEffects presets

- `fw13pro.json`: original speaker preset for the Framework 13 Pro (EQ → loudness → compressor → limiter).
  Import it in EasyEffects, or copy it to `~/.local/share/easyeffects/output/`.
- `fw13pro-pipewire.conf`: that preset as a native PipeWire filter-chain, with the EQ retuned by ear and a Calf bass enhancer added, so the effects
  apply without EasyEffects running. It is **not** installed by the Ansible playbook.

## Installing the PipeWire version (manual, per machine)

1. Install the plugins (Arch: `sudo pacman -S lsp-plugins-lv2 calf`).
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

## Tuning status (2026-11-19)

Tuned by ear against an iPhone on the Framework 13 Pro speakers.

- **Mids to highs: good.** Vocal range (950 Hz–3.8 kHz) eased to -6 dB, 7.5 kHz kept at -6 dB to
  avoid sibilance, +3.5 dB high shelf at 10 kHz for clarity. Leave these alone.
- **Low end: still being worked on.** Measured with the built-in mic (test tones, 2026-11-19):
  the speakers stay clean (<6% THD) at full scale from ~100–200 Hz but break down below ~90 Hz
  (80 Hz at full scale: 51% THD and *lower* output). So:
  - 4th-order Butterworth high-pass at 90 Hz in the EQ, plus another at 95 Hz on the bass band
    *after* all gain stages (loudness/compressor/limiter otherwise push sub-bass back up).
  - Calf bass enhancer at +4 dB (harmonics carry the "felt" bass below 90 Hz).
  - +3 dB at 120 Hz for punch.
  - Bass-only compressor (<200 Hz, LR4 crossover): -6 dB threshold, 4:1, 15 ms attack so kick
    transients get through. Main compressor sidechain ignores <200 Hz.
