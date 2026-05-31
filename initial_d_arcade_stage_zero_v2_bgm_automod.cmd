```bat
@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Initial D Arcade Stage Zero V2 - BGM AutoMod

cls
echo ===========================================================
echo 🚗 Initial D Arcade Stage Zero V2 BGM AutoMod 🎵
echo ===========================================================
echo.

:SET_VARIABLES
set "FILENAME_ADXSELECTACB=ADX_SELECT.acb"
set "FILENAME_ADXSELECTAWB=ADX_SELECT.awb"
set "FILENAME_AVEXACB=AVEX.acb"
set "FILENAME_AVEXAWB=AVEX.awb"
set "FILENAME_BGMTEX=bgmtex.pac"
set "FILENAME_CONFIGEXTEX=config_extex.pac"
set "FILENAME_CONFIGTEX=configtex.pac"

set "DIR=%~dp0"
cd /d "%DIR%"

set "RELDIR_GAME_BGM=data\SOUND\CRI_DATA\ADX_SONG"
set "RELDIR_GAME_BGMGFX=data\flash\data_jp\common\bgm"
set "RELFILE_GAME_BGMGFX=%RELDIR_GAME_BGMGFX%\%FILENAME_BGMTEX%"
set "RELDIR_GAME_MENUCONFIG=data\flash\data_jp\menu\config"
set "RELFILE_GAME_CONFIGEXTEX=%RELDIR_GAME_MENUCONFIG%\%FILENAME_CONFIGEXTEX%"
set "RELFILE_GAME_CONFIGTEX=%RELDIR_GAME_MENUCONFIG%\%FILENAME_CONFIGTEX%"

set "DIR_BACKUP=%DIR%backup"
set "DIR_MOD_OUTPUT=%DIR%mod-output"
set "DIR_NEW_MUSICS=%DIR%new-musics"
set "DIR_NEW_MUSICS_GFX=%DIR%new-musics-gfx"
set "DIR_NEW_MUSICS_PREVIEWS=%DIR%new-musics-previews"
set "DIR_TMP=%DIR%tmp"
set "DIR_TOOLS=%DIR%tools"

set "DIR_TMP_HCA=%DIR_TMP%\hca"
set "DIR_TMP_HCAPREV=%DIR_TMP%\hca-prev"
set "DIR_TMP_AVEX=%DIR_TMP%\AVEX"
set "DIR_TMP_ADXSELECT=%DIR_TMP%\ADX_SELECT"
set "DIR_TMP_NEWWAV=%DIR_TMP%\new-wav"
set "DIR_TMP_NEWWAVPREV=%DIR_TMP%\new-wav-prev"

set "DIR_TOOLS_FFMPEG=%DIR_TOOLS%\ffmpeg"
set "DIR_TOOLS_VGAUDIO=%DIR_TOOLS%\vgaudio"
set "DIR_TOOLS_SONICAUDIOTOOLS=%DIR_TOOLS%\SonicAudioTools"

set "ACBEDITOR=%DIR_TOOLS_SONICAUDIOTOOLS%\AcbEditor.exe"
set "FFMPEG=%DIR_TOOLS_FFMPEG%\ffmpeg.exe"
set "FFPROBE=%DIR_TOOLS_FFMPEG%\ffprobe.exe"
set "SETTINGS=%DIR%initial_d_arcade_stage_zero_v2_bgm_automod.txt"
set "VGAUDIO=%DIR_TOOLS_VGAUDIO%\VGAudioCli.exe"

if exist "%SETTINGS%" (
    set /p LAST_DIR_GAME=<"%SETTINGS%"
) else (
    set "LAST_DIR_GAME="
)

:ASK_DIR_GAME
echo 📁 Select your game directory.
if defined LAST_DIR_GAME (
    set /p DIR_GAME=Game directory [%LAST_DIR_GAME%]: 
    if "!DIR_GAME!"=="" set "DIR_GAME=!LAST_DIR_GAME!"
) else (
    set /p DIR_GAME=Game directory: 
)

if not exist "!DIR_GAME!\!RELDIR_GAME_BGM!" (
    echo.
    echo ❌ Invalid game directory.
    echo Could not find:
    echo !DIR_GAME!\!RELDIR_GAME_BGM!
    echo.
    goto ASK_DIR_GAME
)

echo !DIR_GAME!>"%SETTINGS%"

echo.
echo ✅ Game directory saved.
echo.

mkdir "!DIR_NEW_MUSICS!" 2>nul
mkdir "!DIR_NEW_MUSICS_PREVIEWS!" 2>nul
mkdir "!DIR_NEW_MUSICS_GFX!" 2>nul
mkdir "!DIR_BACKUP!" 2>nul
mkdir "!DIR_TMP!" 2>nul
mkdir "!DIR_TMP_NEWWAV!" 2>nul
mkdir "!DIR_TMP_NEWWAVPREV!" 2>nul

echo 🎵 Put your source songs audio files into: .\new-musics\
echo Accepted names template: [01-26] artist - title.[flac^|wav^|ogg^|mp3]
echo ex: "01 my artist - my title.flac"
echo.
echo Put your optional custom preview audio files (wav,flac,mp3,ogg) in: .\new-musics-previews\
echo ex: "01 my artist - my title.flac"
echo.
echo Put your optional custom UI song sprites files in: .\new-musics-gfx\
echo Music selection artwork: !FILENAME_BGMTEX!
echo Configuration menu artwork: !FILENAME_CONFIGEXTEX! and !FILENAME_CONFIGTEX!
echo.
dir /b "!DIR_NEW_MUSICS!\*.*" >nul 2>nul
if errorlevel 1 (
    echo.
    echo Press any key once you have prepared replacement files, or CTRL+C to quit.
    pause
echo.
)

set "BACKUP_OK=1"
set "BACKUP_HAS_SOMETHING=0"

dir /b /s "!DIR_BACKUP!\*" >nul 2>nul && set "BACKUP_HAS_SOMETHING=1"

if not exist "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELFILE_GAME_CONFIGEXTEX!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELFILE_GAME_CONFIGTEX!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" set "BACKUP_OK=0"

echo.
echo ============================================================
echo 💾 Backup Game Files
echo ============================================================
echo.

if "!BACKUP_HAS_SOMETHING!"=="0" (
    echo ⚠️ Backup directory is empty.
    set /p DO_BACKUP=Create backup now? [yN]: 
    if /i "!DO_BACKUP!"=="y" goto DO_BACKUP
    if /i "!DO_BACKUP!"=="yes" goto DO_BACKUP
    echo ❌ Cannot continue without backup files.
    pause
    exit /b 1
)

if "!BACKUP_OK!"=="1" (
    echo ✅ Backup is complete.
) else (
    echo ⚠️ Backup directory contains files, but backup is incomplete.
)

echo.
echo [1] Create / update full backup
echo [2] Backup only missing files
echo [3] Restore backup and quit
echo [4] Skip and continue
echo.

:ASK_BACKUP_MODE
set /p BACKUP_MODE=Choose an option [1-4]: 

if "!BACKUP_MODE!"=="1" goto DO_BACKUP
if "!BACKUP_MODE!"=="2" goto DO_BACKUP_MISSING
if "!BACKUP_MODE!"=="3" goto RESTORE_BACKUP
if "!BACKUP_MODE!"=="4" goto COPY_BACKUP_TO_TMP

echo ❌ Invalid option.
goto ASK_BACKUP_MODE


:DO_BACKUP
echo.
echo 💾 Creating full backup...

call :COPY_FILE "!DIR_GAME!\!RELFILE_GAME_BGMGFX!" "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!"
call :COPY_FILE "!DIR_GAME!\!RELFILE_GAME_CONFIGEXTEX!" "!DIR_BACKUP!\!RELFILE_GAME_CONFIGEXTEX!"
call :COPY_FILE "!DIR_GAME!\!RELFILE_GAME_CONFIGTEX!" "!DIR_BACKUP!\!RELFILE_GAME_CONFIGTEX!"
call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!"
call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!"
call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!"
call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!"

echo ✅ Full backup completed.
goto COPY_BACKUP_TO_TMP


:DO_BACKUP_MISSING
echo.
echo 🧩 Backing up missing files only...

if not exist "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!" (
    call :COPY_FILE "!DIR_GAME!\!RELFILE_GAME_BGMGFX!" "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!"
call :COPY_FILE "!DIR_GAME!\!RELFILE_GAME_CONFIGEXTEX!" "!DIR_BACKUP!\!RELFILE_GAME_CONFIGEXTEX!"
call :COPY_FILE "!DIR_GAME!\!RELFILE_GAME_CONFIGTEX!" "!DIR_BACKUP!\!RELFILE_GAME_CONFIGTEX!"
)

if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" (
    call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!"
)

if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" (
    call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!"
)

if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" (
    call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!"
)

if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" (
    call :COPY_FILE "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!"
)

echo ✅ Missing backup files added.
goto COPY_BACKUP_TO_TMP


:RESTORE_BACKUP
echo.
echo ♻️ Restoring backup...

if "!BACKUP_OK!"=="0" (
    echo ❌ Cannot restore because backup is incomplete.
    pause
    exit /b 1
)

copy /y "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!" "!DIR_GAME!\!RELFILE_GAME_BGMGFX!" >nul
copy /y "!DIR_BACKUP!\!RELFILE_GAME_CONFIGEXTEX!" "!DIR_GAME!\!RELFILE_GAME_CONFIGEXTEX!" >nul
copy /y "!DIR_BACKUP!\!RELFILE_GAME_CONFIGTEX!" "!DIR_GAME!\!RELFILE_GAME_CONFIGTEX!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" >nul

echo ✅ Backup restored successfully.
pause
exit /b 0


:COPY_BACKUP_TO_TMP
set "BACKUP_OK=1"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" set "BACKUP_OK=0"
if not exist "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" set "BACKUP_OK=0"

if "!BACKUP_OK!"=="0" (
    echo.
    echo ❌ Cannot continue: backup is missing required ACB/AWB files.
    pause
    exit /b 1
)

echo.
echo 📦 Copying backup files to tmp...

copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" "!DIR_TMP!\!FILENAME_ADXSELECTACB!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" "!DIR_TMP!\!FILENAME_ADXSELECTAWB!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" "!DIR_TMP!\!FILENAME_AVEXACB!" >nul
copy /y "!DIR_BACKUP!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" "!DIR_TMP!\!FILENAME_AVEXAWB!" >nul

echo ✅ Temporary files ready.

echo.
echo 🔓 Extracting ACB files...

pushd "!DIR_TMP!"
"!ACBEDITOR!" !FILENAME_ADXSELECTACB!
"!ACBEDITOR!" !FILENAME_AVEXACB!
popd

echo Cleaning tmp/New-Wav directory...
del /q "!DIR_TMP_NEWWAV!\*.*" >nul 2>nul

echo.
echo ============================================================
echo 🎚️ Manual Audio Processing Step
echo ============================================================
echo.
echo Option A - automatic:
echo Press ENTER now and the tool will generate WAV files from:
echo !DIR_NEW_MUSICS!
echo.
echo Option B - manual:
echo Before pressing ENTER, use Adobe Audition, Audacity, or another editor.
echo Normalize / loudness-fix your tracks, then export WAV files to:
echo !DIR_TMP_NEWWAV!
echo.
echo Recommended loudness target for manual work:
echo -6 LUFS / -0.1 dBTP
echo.
echo Filenames must begin with the in-game ID 01 to 26.
echo Example:
echo 01_my_song.wav
echo 02_another_song.wav
echo.
pause
echo.
echo Cleaning Adobe Audition cache files...
del /q "!DIR_TMP_NEWWAV!\*.pkf" >nul 2>nul

:CHECK_WAV
dir /b "!DIR_TMP_NEWWAV!\*.wav" >nul 2>nul
if errorlevel 1 goto AUTO_GENERATE_WAV
goto WAV_READY

:AUTO_GENERATE_WAV
echo.
echo ℹ️ No WAV files found in !DIR_TMP_NEWWAV!.
echo 🔄 Auto-generating WAV files from !DIR_NEW_MUSICS!...

dir /b "!DIR_NEW_MUSICS!\*" >nul 2>nul
if errorlevel 1 (
    echo ❌ !DIR_NEW_MUSICS! is empty.
    echo Add source music files there, then press any key to retry.
    pause
    goto CHECK_WAV
)

for %%F in ("!DIR_NEW_MUSICS!\*.*") do (
    if exist "%%~fF" (
        echo 🎵 %%~nxF → %%~nF.wav
        "!FFMPEG!" -y -i "%%~fF" "!DIR_TMP_NEWWAV!\%%~nF.wav" >nul 2>nul
    )
)

dir /b "!DIR_TMP_NEWWAV!\*.wav" >nul 2>nul
if errorlevel 1 (
    echo ❌ Automatic WAV generation failed.
    echo You can manually export WAV files to !DIR_TMP_NEWWAV!, then press any key to retry.
    pause
    goto CHECK_WAV
)

:WAV_READY

echo.
echo 🔄 Converting full songs WAV files to looped HCA...
echo Mapping source IDs 01-26 to extracted HCA filenames from songs.xlsx.

if not exist "!FFPROBE!" (
    echo ❌ ffprobe.exe not found:
    echo !FFPROBE!
    pause
    exit /b 1
)

if not exist "!VGAUDIO!" (
    echo ❌ VGAudioCli.exe not found:
    echo !VGAUDIO!
    pause
    exit /b 1
)

if exist "!DIR_TMP_HCA!" rmdir /s /q "!DIR_TMP_HCA!"
mkdir "!DIR_TMP_HCA!"

pushd "!DIR_TOOLS_FFMPEG!"


echo.
for %%F in ("!DIR_TMP_NEWWAV!\*.wav") do (
    set "name=%%~nF"
    set "songid=!name:~0,2!"
    set "hcafile="

    if "!songid!"=="01" set "hcafile=00000_streaming.hca"
    if "!songid!"=="02" set "hcafile=00001_streaming.hca"
    if "!songid!"=="03" set "hcafile=00002_streaming.hca"
    if "!songid!"=="04" set "hcafile=00003_streaming.hca"
    if "!songid!"=="05" set "hcafile=00004_streaming.hca"
    if "!songid!"=="06" set "hcafile=00005_streaming.hca"
    if "!songid!"=="07" set "hcafile=00006_streaming.hca"
    if "!songid!"=="08" set "hcafile=00007_streaming.hca"
    if "!songid!"=="09" set "hcafile=00008_streaming.hca"
    if "!songid!"=="10" set "hcafile=00009_streaming.hca"
    if "!songid!"=="11" set "hcafile=00010_streaming.hca"
    if "!songid!"=="12" set "hcafile=00011_streaming.hca"
    if "!songid!"=="13" set "hcafile=00012_streaming.hca"
    if "!songid!"=="14" set "hcafile=00013_streaming.hca"
    if "!songid!"=="15" set "hcafile=00015_streaming.hca"
    if "!songid!"=="16" set "hcafile=00014_streaming.hca"
    if "!songid!"=="17" set "hcafile=00016_streaming.hca"
    if "!songid!"=="18" set "hcafile=00025_streaming.hca"
    if "!songid!"=="19" set "hcafile=00024_streaming.hca"
    if "!songid!"=="20" set "hcafile=00017_streaming.hca"
    if "!songid!"=="21" set "hcafile=00020_streaming.hca"
    if "!songid!"=="22" set "hcafile=00021_streaming.hca"
    if "!songid!"=="23" set "hcafile=00022_streaming.hca"
    if "!songid!"=="24" set "hcafile=00023_streaming.hca"
    if "!songid!"=="25" set "hcafile=00019_streaming.hca"
    if "!songid!"=="26" set "hcafile=00018_streaming.hca"

    if not defined hcafile (
        echo ⚠️ Skipping file with invalid in-game ID: %%~nxF
    ) else (
        echo 🎵 %%~nxF → !hcafile!

        set "DURATION_TS="
        set "FILE_TMP_DURATION=%DIR_TMP%\duration_ts.txt"

        "!FFPROBE!" -v error -select_streams a:0 -show_entries stream^=duration_ts -of default^=noprint_wrappers^=1:nokey^=1 "%%~fF" > "!FILE_TMP_DURATION!" 2>nul
        if exist "!FILE_TMP_DURATION!" set /p DURATION_TS=<"!FILE_TMP_DURATION!"
        del /q "!FILE_TMP_DURATION!" >nul 2>nul

        if not defined DURATION_TS (
            echo ⚠️ Could not read duration for %%~nxF - skipping.
        ) else (
            "!VGAUDIO!" -i "%%~fF" -o "!DIR_TMP_HCA!\!hcafile!" --out-format hca --hcaquality highest -l 0-!DURATION_TS!
        )
    )
)

popd

echo.
echo 🔎 Checking preview source directory...

set "PREVIEW_SOURCE=!DIR_TMP_NEWWAV!"
dir /b "!DIR_NEW_MUSICS_PREVIEWS!\*.wav" >nul 2>nul
if not errorlevel 1 (
    set "PREVIEW_SOURCE=!DIR_NEW_MUSICS_PREVIEWS!"
    echo ✅ Using custom preview WAV files from !DIR_NEW_MUSICS_PREVIEWS!
) else (
    echo ℹ️ !DIR_NEW_MUSICS_PREVIEWS! is empty.
    echo ℹ️ Generating previews from !DIR_TMP_NEWWAV! song files.

if exist "!DIR_TMP_NEWWAVPREV!\*" del /q "!DIR_TMP_NEWWAVPREV!\*" >nul 2>nul

for %%F in ("!DIR_TMP_NEWWAV!\*.wav") do (
    echo 🎧 Generating 50s preview: %%~nxF
    "!FFMPEG!" -y -i "%%~fF" -t 50 "!DIR_TMP_NEWWAVPREV!\%%~nxF" >nul 2>nul
)

set "PREVIEW_SOURCE=!DIR_TMP_NEWWAVPREV!"
echo ✅ Generated previews in !DIR_TMP_NEWWAVPREV!.

)

echo.
echo 🔄 Converting preview WAV files to non-looped HCA...

if exist "!DIR_TMP_HCAPREV!" rmdir /s /q "!DIR_TMP_HCAPREV!"
mkdir "!DIR_TMP_HCAPREV!"

pushd "!DIR_TOOLS_FFMPEG!"

for %%F in ("!PREVIEW_SOURCE!\*.wav") do (
    set "name=%%~nF"
    set "songid=!name:~0,2!"
    set "previewhca="

    if "!songid!"=="01" set "previewhca=00007_streaming.hca"
    if "!songid!"=="02" set "previewhca=00008_streaming.hca"
    if "!songid!"=="03" set "previewhca=00009_streaming.hca"
    if "!songid!"=="04" set "previewhca=00010_streaming.hca"
    if "!songid!"=="05" set "previewhca=00011_streaming.hca"
    if "!songid!"=="06" set "previewhca=00012_streaming.hca"
    if "!songid!"=="07" set "previewhca=00013_streaming.hca"
    if "!songid!"=="08" set "previewhca=00014_streaming.hca"
    if "!songid!"=="09" set "previewhca=00015_streaming.hca"
    if "!songid!"=="10" set "previewhca=00016_streaming.hca"
    if "!songid!"=="11" set "previewhca=00017_streaming.hca"
    if "!songid!"=="12" set "previewhca=00018_streaming.hca"
    if "!songid!"=="13" set "previewhca=00019_streaming.hca"
    if "!songid!"=="14" set "previewhca=00020_streaming.hca"
    if "!songid!"=="15" set "previewhca=00022_streaming.hca"
    if "!songid!"=="16" set "previewhca=00021_streaming.hca"
    if "!songid!"=="17" set "previewhca=00023_streaming.hca"
    if "!songid!"=="18" set "previewhca=00025_streaming.hca"
    if "!songid!"=="19" set "previewhca=00024_streaming.hca"
    if "!songid!"=="20" set "previewhca=00000_streaming.hca"
    if "!songid!"=="21" set "previewhca=00003_streaming.hca"
    if "!songid!"=="22" set "previewhca=00004_streaming.hca"
    if "!songid!"=="23" set "previewhca=00005_streaming.hca"
    if "!songid!"=="24" set "previewhca=00006_streaming.hca"
    if "!songid!"=="25" set "previewhca=00002_streaming.hca"
    if "!songid!"=="26" set "previewhca=00001_streaming.hca"

    if defined previewhca (
        echo 🎧 Preview: song !songid! → !previewhca!
        "!VGAUDIO!" -i "%%~fF" -o "!DIR_TMP_HCAPREV!\!previewhca!" --out-format hca --hcaquality highest
    ) else (
        echo ⚠️ Skipping preview file with invalid in-game ID: %%~nxF
    )
)

popd

echo.
echo 📥 Copying full song HCA files into !DIR_TMP_AVEX!...

if exist "!DIR_TMP_AVEX!" goto DIR_TMP_AVEX_OK
echo ❌ !DIR_TMP_AVEX! was not created by AcbEditor.
echo Cannot continue.
goto END_WITH_ERROR

:DIR_TMP_AVEX_OK

copy /y "!DIR_TMP_HCA!\*.hca" "!DIR_TMP_AVEX!\" >nul
echo ✅ Full song HCA files copied.

echo.
echo 📥 Copying preview HCA files into !DIR_TMP_ADXSELECT!...

if exist "!DIR_TMP_ADXSELECT!" goto DIR_TMP_ADXSELECT_OK
echo ❌ !DIR_TMP_ADXSELECT! was not created by AcbEditor.
echo Cannot continue.
goto END_WITH_ERROR

:DIR_TMP_ADXSELECT_OK

copy /y "!DIR_TMP_HCAPREV!\*.hca" "!DIR_TMP_ADXSELECT!\" >nul
echo ✅ Preview HCA files copied.

echo.
echo 🛠️ Rebuilding AVEX ACB/AWB...
pushd "!DIR_TOOLS_SONICAUDIOTOOLS!"
"!ACBEDITOR!" "%DIR_TMP_AVEX%"
popd

echo.
echo 🛠️ Rebuilding ADX_SELECT ACB/AWB...
pushd "!DIR_TOOLS_SONICAUDIOTOOLS!"
"!ACBEDITOR!" "%DIR_TMP_ADXSELECT%"
popd

echo.
echo ============================================================
echo 🎨 Optional title graphics step
echo ============================================================
echo.
echo If you want custom music title graphics:
echo Put your custom !FILENAME_BGMTEX!, !FILENAME_CONFIGEXTEX! and/or !FILENAME_CONFIGTEX! files in:
echo !DIR_NEW_MUSICS_GFX!
echo.
echo You can edit the graphics in Photoshop before continuing.
echo.
pause

echo.
echo 🚀 Publishing modded music files to game directory...

copy /y "!DIR_TMP!\!FILENAME_ADXSELECTACB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!" >nul
copy /y "!DIR_TMP!\!FILENAME_ADXSELECTAWB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!" >nul
copy /y "!DIR_TMP!\!FILENAME_AVEXACB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!" >nul
copy /y "!DIR_TMP!\!FILENAME_AVEXAWB!" "!DIR_GAME!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!" >nul

if exist "!DIR_NEW_MUSICS_GFX!\!FILENAME_BGMTEX!" goto PUBLISH_CUSTOM_BGMTEX
goto AFTER_PUBLISH_BGMTEX

:PUBLISH_CUSTOM_BGMTEX
copy /y "!DIR_NEW_MUSICS_GFX!\!FILENAME_BGMTEX!" "!DIR_GAME!\!RELFILE_GAME_BGMGFX!" >nul
echo ✅ Custom !FILENAME_BGMTEX! published.

:AFTER_PUBLISH_BGMTEX

if exist "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGEXTEX!" goto PUBLISH_CUSTOM_CONFIGEXTEX
goto AFTER_PUBLISH_CONFIGEXTEX

:PUBLISH_CUSTOM_CONFIGEXTEX
copy /y "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGEXTEX!" "!DIR_GAME!\!RELFILE_GAME_CONFIGEXTEX!" >nul
echo ✅ Custom !FILENAME_CONFIGEXTEX! published.

:AFTER_PUBLISH_CONFIGEXTEX
if exist "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGTEX!" goto PUBLISH_CUSTOM_CONFIGTEX
goto AFTER_PUBLISH_CONFIGTEX

:PUBLISH_CUSTOM_CONFIGTEX
copy /y "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGTEX!" "!DIR_GAME!\!RELFILE_GAME_CONFIGTEX!" >nul
echo ✅ Custom !FILENAME_CONFIGTEX! published.

:AFTER_PUBLISH_CONFIGTEX


echo.
echo 📦 Building mod-output directory...
echo(!DIR_MOD_OUTPUT!

if exist "!DIR_MOD_OUTPUT!" rmdir /s /q "!DIR_MOD_OUTPUT!"

call :COPY_FILE "!DIR_TMP!\!FILENAME_ADXSELECTACB!" "!DIR_MOD_OUTPUT!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTACB!"
call :COPY_FILE "!DIR_TMP!\!FILENAME_ADXSELECTAWB!" "!DIR_MOD_OUTPUT!\!RELDIR_GAME_BGM!\!FILENAME_ADXSELECTAWB!"
call :COPY_FILE "!DIR_TMP!\!FILENAME_AVEXACB!" "!DIR_MOD_OUTPUT!\!RELDIR_GAME_BGM!\!FILENAME_AVEXACB!"
call :COPY_FILE "!DIR_TMP!\!FILENAME_AVEXAWB!" "!DIR_MOD_OUTPUT!\!RELDIR_GAME_BGM!\!FILENAME_AVEXAWB!"

if exist "!DIR_NEW_MUSICS_GFX!\!FILENAME_BGMTEX!" goto MOD_OUTPUT_CUSTOM_BGMTEX
if exist "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!" goto MOD_OUTPUT_BACKUP_BGMTEX
goto AFTER_MOD_OUTPUT_BGMTEX

:MOD_OUTPUT_CUSTOM_BGMTEX
call :COPY_FILE "!DIR_NEW_MUSICS_GFX!\!FILENAME_BGMTEX!" "!DIR_MOD_OUTPUT!\!RELFILE_GAME_BGMGFX!"
goto AFTER_MOD_OUTPUT_BGMTEX

:MOD_OUTPUT_BACKUP_BGMTEX
call :COPY_FILE "!DIR_BACKUP!\!RELFILE_GAME_BGMGFX!" "!DIR_MOD_OUTPUT!\!RELFILE_GAME_BGMGFX!"

:AFTER_MOD_OUTPUT_BGMTEX

if exist "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGEXTEX!" goto MOD_OUTPUT_CUSTOM_CONFIGEXTEX
if exist "!DIR_BACKUP!\!RELFILE_GAME_CONFIGEXTEX!" goto MOD_OUTPUT_BACKUP_CONFIGEXTEX
goto AFTER_MOD_OUTPUT_CONFIGEXTEX

:MOD_OUTPUT_CUSTOM_CONFIGEXTEX
call :COPY_FILE "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGEXTEX!" "!DIR_MOD_OUTPUT!\!RELFILE_GAME_CONFIGEXTEX!"
goto AFTER_MOD_OUTPUT_CONFIGEXTEX

:MOD_OUTPUT_BACKUP_CONFIGEXTEX
call :COPY_FILE "!DIR_BACKUP!\!RELFILE_GAME_CONFIGEXTEX!" "!DIR_MOD_OUTPUT!\!RELFILE_GAME_CONFIGEXTEX!"

:AFTER_MOD_OUTPUT_CONFIGEXTEX
if exist "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGTEX!" goto MOD_OUTPUT_CUSTOM_CONFIGTEX
if exist "!DIR_BACKUP!\!RELFILE_GAME_CONFIGTEX!" goto MOD_OUTPUT_BACKUP_CONFIGTEX
goto AFTER_MOD_OUTPUT_CONFIGTEX

:MOD_OUTPUT_CUSTOM_CONFIGTEX
call :COPY_FILE "!DIR_NEW_MUSICS_GFX!\!FILENAME_CONFIGTEX!" "!DIR_MOD_OUTPUT!\!RELFILE_GAME_CONFIGTEX!"
goto AFTER_MOD_OUTPUT_CONFIGTEX

:MOD_OUTPUT_BACKUP_CONFIGTEX
call :COPY_FILE "!DIR_BACKUP!\!RELFILE_GAME_CONFIGTEX!" "!DIR_MOD_OUTPUT!\!RELFILE_GAME_CONFIGTEX!"

:AFTER_MOD_OUTPUT_CONFIGTEX


echo ✅ mod-output directory created.
echo(!DIR_MOD_OUTPUT!

echo.
echo ============================================================
echo ✅ Update was successfully completed.
echo ============================================================
exit /b 0

:COPY_FILE
set "SRC=%~1"
set "DST=%~2"

if exist "%SRC%" goto COPY_FILE_SOURCE_OK
echo ❌ Missing source file:
echo(%SRC%
goto END_WITH_ERROR

:COPY_FILE_SOURCE_OK

for %%D in ("%DST%") do mkdir "%%~dpD" 2>nul
copy /y "%SRC%" "%DST%" >nul
exit /b 0


:END_WITH_ERROR
echo.
echo ❌ Script aborted due to an error.
echo.
pause
exit /b 1
