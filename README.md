# Pulpit Clock

This is a tool in Delphi (with sources), that displays an analog clock on your Windows pulpit, records time your computer was turned on and allows you to synchronise your computer time more efficiently than core Windows tools allows.

For Delphi developer this piece of source code may be useful to learn how to display Flash animation in Delphi program or how to implement support for SNTP protocol for syncing time, from any time server, with a great level of precision. Note, that for this purpose an `adSNTP` library is used, which is included in this project, but **it is not translated and remains in Polish** (because I'm not its author and have no legal right for making such translation). Rest of this program should be in English (excluding comments -- see below). Alternatively, this project can be an example of using system API `GetTickCount()` method to measure time independently from system clock and thus to make it not sensible to any clock or calendar modifications made by end user.

**This project ABANDONED! There is no wiki, issues and no support. There will be no future updates. Unfortunately, you're on your own.**

### Status

Last time `.dpr` file saved in Delphi: **22 June 2008**. Last time `.exe` file built: **14 February 2009**.

**You're only getting project's source code and nothing else! You need to find all missing Delphi components by yourself.**

I don't have access to either most of my components used in this or any other of my Delphi projects, nor to Delphi itself. Even translation of this project to English was done by text-editing all `.dfm` and `.pas` files and therefore it may be cracked. It was made in hope to be useful to anyone and for the same reason I'm releasing its source code, but you're using this project or source code at your own responsibility.

Keep in mind, that both comments and names (variables, object) are in Polish. I didn't find enough time and determination to translated them as well. I only translated strings.

**This project ABANDONED! There is no wiki, issues and no support. There will be no future updates. Unfortunately, you're on your own.**

### More detailed description

This program allows to measure time your computer was turned on. However, due to limits of 32-bit platform (program was written in Delphi 7 for Windows XP) maximum time measured this way equals to _49 days, 17 hours, 2 minutes and 48 seconds_ (2^32 milliseconds). After that all counters will be reset.

Main window of this program is `WS_EX_TOOLWINDOW & !WS_EX_APPWINDOW` type, which means, that it does not appear on task bar. It is also not minimized, when you press `Win+M` to minimize all open programs. You can, however, minimize it to status bar (an icon next to system clock) using proper option in context menu. You can also drag window to any place you like, even though it does not have title bar. Program should remember current position on main window and restart in the very same place, next time you run it.

If you see white area instead of an analog clock, then it most likely means, that you don't have an `ActiveX Macromedia Flash Player 6` control installed in your system or running this control failed. You should see analog clock, when `Flash6.ocx` file is in the same folder as `pulpit_clock.exe`, but there were some reports, that moving `Flash6.ocx` to `C:\WINDOWS\system32\Macromed\Flash` helped. If everything else failes, you can delete `clock.dat` file from program's home folder and enjoy using it with simple digital clock instead.

This project is using `GetTickCount()` method to measure time independently from system clock and thus it shouldn't be sensible to any clock or calendar modifications made by you. This also includes putting your computer into hibernation or sleep, which should not stop clock from counting. After waking up or de-hibernating your computer you should see correct time elapse (as your computer would work normally during sleep or hibernation). Using this method measures real time, that passed since system startup. This means, that running Pulpit Clock in `Autostart` menu may show time passed since startup a little bit advanced (time period required to actually start your system and all its stuff -- `GetTickCount()` method starts "counting" time as one of first things in entire system startup process). This also means, that you can run Pulpit Clock at any time, not necessarily during system startup, and still get actual, real time that passed since computer startup.

Most things insider program are checked with 11 seconds interval (to not overload system) and thus you may expect some slight delays in updates of certain values (like records) or in program's logs drops. Mentioned system log isn't finished, I got really scrambled in code, that runs it, so expect some things to work incorrectly or not work at all in this area.

Program reads and writes its files quite often and thus running it from CD or DVD isn't the best idea (will crash most likely). And running it from some slow device may result in really poor performance.

I have never used more than one screen / monitor and thus I don't know, how this program will behave in multi-screen environment. Sorry!

Program's icon is a water drop to underline, that time flows... all the time! Like water! :)

### History of changes

**Version 1.30 (June 22, 2008)**:

- a stupid error message displayed sometimes during program close was fixed,
- showing to user and writing to logs date of Windows installation,
- when user enables option to sync time during system startup, actual sync is performed about 2-3 minutes after Windows starts, not immediately,
- many other, small changes,
- you can run only one copy of program right now,
- all time syncing operations are now saved in main log, not in sync log,
- user no longer can specify timeout for time syncing operation; it is now set to default, unchangeable value of 2500 milliseconds,
- adding option to sync time each time from different (random) time server.

**Version  1.20 (June 13, 2008)**:

- adding simple configuration window,
- implementing time syncing features,
- saving basic settings to configration file and re-reading it during each program start,
- handing auto-start issues, if user want to start Pulpit Clock with system startup,
- adding keyboard shortcuts to context menu,
- adding `About` screen,
- saving date, first time program was run, to program's log,
- adding Windows XP-like style,
- many small changes.

**Version  1.10 (June 7, 2008)**:

- replacing digital clock with Flash-like analog one,
- slight changes in source code,
- implementing _minimize to system tray_ option,
- adding context menu,
- program history (this text) added to program itself (in info window),
- program no longer can be closed by double click in main window.

**Version  1.00 (June 3, 2008)**:

- initial release.