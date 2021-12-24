@echo off

goto :start
File: SubAdd.cmd
Description: Add subtitles to movie files
Syntax: Execute the .cmd without any parameters for online help.
Version: 1.0.2021.12.24.1314
Date: 2021-12-24
Time: 1314
Author: Ken Teague
Email: kteague at pobox dot com
License: Creative Commons Zero v1.0 Universal

Changelog:
  2021-12-24 @ 1215
    * Initial release

  2021-12-24 @ 1314
    * Added changelog
    * Moved original files under .\originals subdirectory.
    * Start Explorer in CWD for the user to analyze the work that was done.
    * Added more verbosity to output when moving and renaming files.


:start
:: Adjust these variables to point to the where the binaries live on your computer.
set _mkvmerge="C:\Program Files\MKVToolNix\mkvmerge.exe"
set _ffmpeg="C:\Program Files\ffmpeg\bin\ffmpeg.exe"
:: DO NOT EDIT ANYTHING BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU'RE DOING!


if not exist %_mkvmerge% goto %nomkvmerge
if not exist %_ffmpeg% goto %noffmpeg
if [%1]==[] goto :help
if [%2]==[] goto :help
if  %~x1 == .mkv goto :subtitle
echo Movie input file is not in MKV format!  Converting...
%_ffmpeg% -i %1 -vcodec copy -acodec copy "%~n1.mkv"
echo.
:subtitle
echo Adding subtitles...
%_mkvmerge% -o "%~n1-sub.mkv" "%~n1.mkv" --language 0:eng --track-name 0:English "%~n2.srt"
echo Making new directory to store original files: "%~p1\original" ...
md "%~p1\original"
echo Moving "%~n1.mkv" to "%~p1\original" ...
move "%~n1.mkv" "%~p1\original"
echo Moving "%~n1.srt" to "%~p1\original" ...
move "%~n1.srt" "%~p1\original"
echo Renaming "%~n1-sub.mkv" to "%~n1.mkv" ...
move "%~n1-sub.mkv" "%~n1.mkv"
echo.
echo DONE adding subtitles!
echo Open "%~n1.mkv" and test the subtitles to ensur they're there and in sync.
echo Check "%~p1" for any files that need to be cleaned up...
echo.
%SystemRoot%\Explorer.exe "%~p1"
goto:eof


:help
echo.
echo Add subtitles to MKV file
echo Usage:
echo %0 ^"Movie File.mkv^" ^"Subtitle File.srt^"
echo.
echo Requirements: 
echo   * Movie file must be in MKV format
echo   * Subtitle file must be in SRT format
echo The movie will be converted to MKV format if it's not found to be an MKV file.
echo.
echo It is assumed that the language of the subtitle is English.
echo.
goto:eof


:nomkvmerge
echo.
echo Missing: mkvmerge.exe
echo.
echo MKVToolNix is required to add subtitles and can be obtained from:
echo    https://www.fosshub.com/MKVToolNix.html
echo.
echo If you have MKVToolNix installed, did you edit %0 and set the 
echo _mkvmerge variable accordingly?
echo.
echo Aborting!!
echo.
goto:eof


:noffmpeg
echo.
echo Missing: ffmpeg.exe
echo.
echo FFMPEG is required to convert movie to MKV format and can be obtained from:
echo     https://www.gyan.dev/ffmpeg/builds/
echo     https://github.com/BtbN/FFmpeg-Builds/releases
echo.
echo If you have FFMPEG installed, did you edit %0 and set the 
echo _ffmpeg variable accordingly?
echo.
echo Aborting!!
echo.
goto:eof
