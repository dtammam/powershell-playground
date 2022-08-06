Screenshot Copying for DDR
=====================

I realized that I was getting very distracted when playing DDR/ITG at home and it was because I was taking photos from my phone. When I'd open it... I'd open another app sometimes and get distracted. So, how about just take a photo on the machine and have it land on my phone automatically?

Audience
-------------
- DDR/ITG players with a home setup
- Home setup is running Windows
- Mobile phone is an iPhone
- Moderate technical experience

Conceptual
-------------
- Install AutoHotKey and iCloud Photos on your Windows-based DDR/ITG machine
- Pick a button on the machine to take the screenshot
- Update the script with directories (root screenshot folder and destination, which is iCloud Uploads)
- Play the game, press the screenshot button... give it a few seconds and have it upload to your phone :)

Tactical
-------------
1. Download and install iCloud on your machine, login, only enable photos. Go to Options and only select 'iCloud Photo Library' and 'Upload new photos and videos from my PC', noting the path.
2. Download and update *ScreenshotCopy.ps1* lines 46 and 47 with your directories (46 being the screenshot folder, 47 being your iCloud upload directory you just saved). Save the file itself to 'C:\Games'
3. Download and update *PlusToPrintScreen.ahk* line 6 to map to your button of choice (reference what Auto HotKey can support). Save the file itself to 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp'
4. Double-click *PlusToPrintScreen.ahk* so that it launches as a running script (Note, this is a one-time thing. Since you put it in startup, it'll open when the machine starts)
5. In the game, press your screenshot button. After a few seconds, check your photo roll and enjoy your crispy, high-resolution, distraction-free scores :)

Resources
-------------
It's a fully functional project that can be downloaded, executed and tweaked as a proof-of-concept.

Below are **necessary files** if you want to leverage this solution:
1. [List of AutoHotkey keys](https://www.autohotkey.com/docs/KeyList.htm "AutoHotkey")
2. [Link for iCloud Windows download](https://support.apple.com/en-us/HT204283 "Download iCloud for Windows")

![I'm doing stuff and things!](https://i.ytimg.com/vi/tlV2ksKUPkc/maxresdefault.jpg)
