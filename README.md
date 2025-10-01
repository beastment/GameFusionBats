BIG update!
The lack of this functionality was really starting annoy me. So, I've found a way to effectively add this functionality via a workaround. It sounds a little complicated to set up, but most of this you only have to do once. Trust me, it's very easy to map new games after the initial setup, and works fantastic once you've done it for your first game. This is using GameHub 5.1.0, on an S25Ultra.

INITIAL SET UP (ONLY NEED TO DO ONCE)
Grab a copy AntiMicroX (a rather good controller mapper) from here (You want the portable version): https://github.com/AntiMicroX/antimicrox/releases/tag/3.5.1
Now grab a copy of GUIPropView (this is used for switching to and from AntiMicroX) from here (32 bit): https://www.nirsoft.net/utils/gui_prop_view.html
Now grab of my files from here (just the zip file, and then extract the four files): https://github.com/beastment/GameFusionBats/releases/tag/Release

These should all go in the Download folder of your device. You should have folder structures like this:
Internal storage\Download\antimicrox-3.5.1-portablewindows-amd64\bin...
Internal storage\Download\guipropview\...
Internal Storage\Download\GameFusionBats\...

PER GAME SET UP (NEED TO DO FOR EACH GAME)
Alright, that's the main set up done. Now for each game that you want to map controls for:
 - Make sure you have the game up and working
 - Head into Gamehub and enter the container desktop (make sure "Disable Window Manager" is deactivated)
 - In the file explorer, head to your D drive, and then copy the four files under GameFusionBats to where your game.exe file is (usually the root folder of your X drive). You may find it easier to have two file explorer windows open.
 - Now run setup.bat from your X drive. A cmd window will open and it will iterate through any .exe files in the folder. You need to tell it which one is your game file (e.g. PlanetBase.exe).

FINAL SET UP (ONLY NEED TO DO ONCE):
Now, go back to your D drive, and launch: Internal storage\Download\antimicrox-3.5.1-portablewindows-amd64\bin\antimicrox.exe
Go to Options > Settings, and ensure the following:
Close to tray - Off
Minimize to taskbar - Off
Autoload last open profile - On
Launch in tray - off
Press OK (you may need to drag the window up to see the OK button)
Now in the main window, Load Profile, and select GH-Default Profile from your X drive. Save, and exit.

THAT'S IT! YOU'RE DONE!
Now, when you launch the game, antimicrox will be running in the background and applying your mappings. You press LEFT THUMBSTICK + LEFT SHOULDER to switch to antimicrox and make any changes you like to the mappings (make sure to save them), and then press LEFT THUMBSTICK + RIGHT SHOULDER to switch back to your game. It should even persist through a game data reset. The GH-Default Profile is my set up for PlanetBase, which should be enough to get you started, or let me know if you have a better one. You can even also add a virtual on screen controller as well if you want to. Enjoy!

And if you want an explanation of how I got here...

It occurred to me that since we have container access, I might be able to install some controller mapping software in the container and use this for each game. I tried A LOT of controller mapping software. AntiMicroX is the only one that would launch. Most others wouldn't even install, or crashed if they did. Fortunately, AntiMicroX is great, and even has a portable version so no need to install.
Set it to start with windows and away you go. Easy right? Well... Turns out that wine/proton containers don't seem to have any way of autostarting a program or service. At least not that I could find. I'm not sure how Gamehub and Winlator etc achieve this, but it seems to be something us end users don't have access to. So, I had to work with what we have, i.e. the main game exe. The bat files I created work like this:
setup.bat: This searches for your main game.exe (e.g. PlanetBase.exe), and once confirmed it renames it to game-real.exe. It then renames exebat.pre to game.exe (i.e. PlanetBase.exe to continue the example).
Now, when Gamehub opens PlanetBase.exe, it's actually opening exebat.pre (now renamed to PlanetBase.exe).
What does exebat.pre (or exebat.exe if you prefer) do? It's a simple batch file converted to an exe file. All it does is launch another batch file called helper.bat, and then exits.
So Planetbase.exe (exebat.exe) has now exited, and helper.bat is running. Helper.bat immediately renames Planetbase.exe to exebat.exe. It then renames PlanetBase-real.exe back to PlanetBase.exe (this is the original game file and name). It then launches AntiMicroX, waits a moment so that it doesn't steal the focus, and then launches PlanetBase.exe. Now it waits until you exit the game, and then reverses the process so that we're good to go for next time. Renames PlanetBase.exe to PlanetBase-real.exe, renames exebat.exe to PlanetBase.exe, and then kills AntiMicroX so that Gamehub can see that everything is finished and then sync cloud saves etc.
If the game crashes or doesn't exit properly, then it's possible you can get stuck with files not named correctly. Just run setup.bat again and it should fix it.
Now I discovered that it's a real pain in the neck to have to go in to the container to change your mappings. After a lot of failed solutions, I finally achieved success with GUIPropViewer. This awesome little program needs no installation, and gives you lots of ways to manipulated windows. It was still a pain and most methods didn't work, but I eventually found a way to have AntiMicroX call GUIPropViewer to switch to the mapper. Switching back to the game though was even harder, as there is no taskbar present. It now searches for any minimized windows (there should only be one at this stage, your main game.exe) and then maximizes them. Putting you nicely back in the game. 
