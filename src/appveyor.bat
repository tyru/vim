@echo off
:: Batch file for building/testing Vim on AppVeyor

setlocal ENABLEDELAYEDEXPANSION
cd %APPVEYOR_BUILD_FOLDER%

cd src
rem echo "Building MinGW 32bit console version"
rem set PATH=c:\msys64\mingw32\bin;%PATH%
rem mingw32-make.exe -f Make_ming.mak GUI=no OPTIMIZE=speed IME=yes MBYTE=yes ICONV=yes DEBUG=no FEATURES=%FEATURE% || exit 1
rem :: Save vim.exe before Make clean, moved back below.
rem copy vim.exe testdir
rem mingw32-make.exe -f Make_ming.mak clean
rem 
rem :: Build Mingw huge version with python and channel support, or
rem :: with specified features without python.
rem echo "Building MinGW 32bit GUI version"
rem if "%FEATURE%" == "HUGE" (
rem     mingw32-make.exe -f Make_ming.mak OPTIMIZE=speed CHANNEL=yes GUI=yes IME=yes MBYTE=yes ICONV=yes DEBUG=no PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON=C:\Python27 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes PYTHON3=C:\Python35 FEATURES=%FEATURE% || exit 1
rem ) ELSE (
rem     mingw32-make.exe -f Make_ming.mak OPTIMIZE=speed GUI=yes IME=yes MBYTE=yes ICONV=yes DEBUG=no FEATURES=%FEATURE% || exit 1
rem )
rem .\gvim -u NONE -c "redir @a | ver |0put a | wq" ver_ming.txt
rem
rem echo "Building MSVC 64bit console Version"
sed -e "s/\$(LINKARGS2)/\$(LINKARGS2) | sed -e 's#.*\\\\r.*##'/" Make_mvc.mak > Make_mvc2.mak
rem nmake -f Make_mvc2.mak CPU=AMD64 OLE=no GUI=no IME=yes MBYTE=yes ICONV=yes DEBUG=no FEATURES=%FEATURE% || exit 1
rem nmake -f Make_mvc2.mak clean

:: build MSVC huge version with python and channel support
:: GUI needs to be last, so that testing works
echo "Building MSVC 64bit GUI Version"
if "%FEATURE%" == "HUGE" (
    nmake -f Make_mvc2.mak DIRECTX=yes CPU=AMD64 CHANNEL=yes OLE=no GUI=yes IME=yes MBYTE=yes ICONV=yes DEBUG=no PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON=C:\Python27-x64 PYTHON3_VER=35 DYNAMIC_PYTHON3=yes PYTHON3=C:\Python35-x64 FEATURES=%FEATURE% || exit 1
) ELSE (
    nmake -f Make_mvc2.mak CPU=AMD64 OLE=no GUI=yes IME=yes MBYTE=yes ICONV=yes DEBUG=no FEATURES=%FEATURE% || exit 1
)
.\gvim -u NONE -c "redir @a | ver |0put a | wq" ver_msvc.txt

:: Restore vim.exe, tests will run with this.
rem move /Y testdir\vim.exe .
rem echo "version output MinGW"
rem type ver_ming.txt
echo "version output MVC"
type ver_msvc.txt
cd ..

