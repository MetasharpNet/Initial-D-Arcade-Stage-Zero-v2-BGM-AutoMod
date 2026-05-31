# Initial D Arcade Stage Zero v2 BGM AutoMod

> Mostly-automated custom soundtrack modding workflow for Initial D Arcade Stage Zero v2.

A Windows CMD-based toolchain for replacing the game's music with custom tracks, generating previews, rebuilding ACB/AWB archives, patching UI title graphics and packaging ready-to-use mod files.

Created by **Metasharp**.

---

## How to support?

1- Star this GitHub repository

2- Tip me on: https://ko-fi.com/metasharp

---

## Features

* Automatic game folder detection and saving
* Automatic backup and restore system
* Extraction of original game music archives
* Automatic WAV generation from FLAC, MP3, OGG or WAV sources
* Optional manual loudness normalization workflow
* Automatic HCA encoding using VGAudio
* Automatic preview generation (50 seconds)
* Automatic ACB/AWB rebuilding
* Optional custom music title graphics support
* Automatic mod packaging into `mod-output`
* Optional automatic installation into the game folder

---

## Supported Audio Formats

The tool accepts:

* WAV
* FLAC
* MP3
* OGG

Songs are placed inside:

```text
new-musics/
```

Previews are placed inside:

```text
new-musics-previews/
```

Music files use the game's song IDs:

```text
01 artist - title.flac
02 artist - title.mp3
03 artist - title.ogg
...
26 artist - title.wav
```

The script automatically maps these IDs to the proper internal game files.

---

## Optional Custom UI Graphics

Place custom PAC files in:

```text
new-musics-gfx/
```

Supported files:

```text
bgmtex.pac
config_extex.pac
configtex.pac
```

These files control the song title graphics displayed in-game.

Photoshop templates and texture editing tools are included.

---

## Folder Structure

```text
backup/

mod-output/

new-musics/
new-musics-previews/
new-musics-gfx/

tmp/
├── new-wav/
├── new-wav-prev/
├── hca/
├── hca-prev/
├── AVEX/
└── ADX_SELECT/

tools/
├── ffmpeg/
├── vgaudio/
├── SonicAudioTools/
└── ArcadeStageTextureTool/
```

---

## Workflow

```text
Backup game files
        ↓
Extract ADX_SELECT / AVEX
        ↓
Generate or prepare WAV files
        ↓
Convert songs to HCA
        ↓
Generate previews
        ↓
Convert previews to HCA
        ↓
Rebuild ACB/AWB archives
        ↓
Patch optional UI graphics
        ↓
Create mod-output package
        ↓
Optionally install directly into the game
```

---

## Files Modified

The tool rebuilds:

```text
data/SOUND/CRI_DATA/ADX_SONG/ADX_SELECT.acb
data/SOUND/CRI_DATA/ADX_SONG/ADX_SELECT.awb

data/SOUND/CRI_DATA/ADX_SONG/AVEX.acb
data/SOUND/CRI_DATA/ADX_SONG/AVEX.awb
```

Optional UI files:

```text
data/flash/data_jp/common/bgm/bgmtex.pac

data/flash/data_jp/menu/config/config_extex.pac
data/flash/data_jp/menu/config/configtex.pac
```

---

## Included Tools

| Tool                   | Role                            |
| ---------------------- | ------------------------------- |
| ffmpeg                 | Audio conversion                |
| VGAudio                | HCA encoding                    |
| SonicAudioTools        | ACB/AWB extraction & rebuilding |
| ArcadeStageTextureTool | PAC texture editing             |
| Photoshop Templates    | Song title graphics editing     |

---

## Final Output

The generated package is created in:

```text
mod-output/
```

Using the same folder structure as the game.

You can either:

* Copy the contents manually into the game folder
* Let the script publish the files automatically

---

## Documentation

A complete guide is included:

```text
Initial D Arcade Stage Zero v2 BGM AutoMod Guide.docx
```

It covers:

* Audio workflow
* Song ID mapping
* Preview generation
* PAC texture editing
* Photoshop workflow
* DDS export settings
* ArcadeStageTextureTool usage

---

## Credits

* Original Initial D Zero music replacement workflow by **PockyWitch**
* AutoMod workflow, automation, packaging and documentation by **Metasharp**

---

## License

MIT

---

# Suggested Tracklist for the game

* 01 fastway - go beat crazy.flac
* 02 ace - power of sound.flac
* 03 tommy k. - break the night.flac
* 04 max coveri - running in the 90's.flac
* 05 dave rodgers - space boy.flac
* 06 dr. love feat. d. essex - max power.flac
* 07 edo boys - no one sleep in tokyo.flac
* 08 m.o.v.e - dogfight.flac
* 09 niko - night of fire.flac
* 10 mega nrg man - back on the rocks.flac
* 11 ken blast - the top.flac
* 12 dave rodgers - deja vu.flac
* 13 mako & sayuki - wings of fire.flac
* 14 mega nrg man - burning desire.flac
* 15 leslie parrish - save me.flac
* 16 jager - i won't fall apart.flac
* 17 go 2 - looka bomba.flac
* 18 vicky vale - dancing.flac
* 19 sound holic feat nana takahashi - preserved vampire.flac
* 20 fastway - revolution.flac
* 21 manuel - gas gas gas.flac
* 22 dave mcloud - gimme the night.flac
* 23 digital planet - fly away.flac
* 24 sound holic vs eurobeat union feat nana takahashi - no life queen [dj command remix].flac
* 25 michiko neya & yumi kakazu - impact blue.flac
* 26 mickey b. - take my soul.flac
* 
---

## Statistics

GitHub Downloads stats:

https://grev.shehryar.ae/?owner=MetasharpNet&repo=Initial-D-Arcade-Stage-Zero-v2-BGM-AutoMod
