# TeXfireplace version history

### TeXfireplace 3.0 (2023/10/09)

- First release on GitHub.
- Updating download links.

### TeXfireplace 2.3 (2023/08/21)

- Optimizing the updating method

### TeXfireplace 2.2 (2023/08/17)

- Better updating methods of MiKTeX and TLPerl

### TeXfireplace 2.1 (2023/07/30)

- New default texstudio.ini

### TeXfireplace 2.0 (2023/04/20)

- Added Pygments for the minted LaTeX package.

### TeXfireplace 1.9 (2022/11/27)

- Alternate download address for TLPerl (in texfpinst.bat and update.bat).
- Changing 'http' to 'https' in default TLPerl address (in texfpinst.bat and update.bat).

### TeXfireplace 1.8 (2022/11/19)

- Automatic icon theme setting in TeXstudio.

### TeXfireplace 1.7 (2022/10/18)

- If the MiKTeX installer does not create pdflatex.exe, latexmk.exe, etc., then the TeXfireplace does it.

### TeXfireplace 1.6 (2022/05/24)

- New shortcut icons in the Start menu
- Default dvi viewer is yap.exe
- Fixed a minor bug of uninstall.exe
- Fixed a minor bug of texfpinstall.exe
- restore.exe instead of restore.bat
- update.bat has been built into texfireplace.exe
- Fixed an installing bug of TeXstudio portable 4.2.3
- Added TeXfireplace and pdflatex paths to the About form

### TeXfireplace 1.5 (2022/05/10)

- Position of the dialog box is bottom of the form
- Added question and warning icons to the dialog box
- Added sliding to the dialog box
- Removing readme_en.txt and readme_hu.txt
- Added readme.txt
- Added text of readme.txt to hu.lang
- Changing loading procedure of readme.txt into the About form
- Backup during system upgrade (TLPerl, TeXstudio, TeXfireplace menu)
- Removing repair.bat
- Added restore.bat
- Removing version.bat
- New method to check that the TeXfireplace menu is running in one instance (instead of texfireplace-lockfile)
- Using --no-check-certificate option of wget

### TeXfireplace 1.4 (2022/04/28)

- Fixed TLPerl up-to-date checking
- Using miktex.exe instead of mpm.exe in installer and menu
- Using mthelp.exe instead of texdoc.exe in menu
- Removing progress bar from updating panel
- Added repair.bat
- Added version.bat
- Added version numbers of MiKTeX, TLPerl, and TeXstudio to about dialog
- Fixed a minor bug of update.bat
- Added a new message: 'The TeXfireplace will restart!'

### TeXfireplace 1.3 (2022/03/25)

- New color scheme loading method
- Available color schemes: black, blue, default, lightgray, red
- The tex files are not associated with tfptexstudio.exe after installation, if they are associated with other application
- Fixed uninstalling minor bug
- Colored title in the 'About TeXfireplace' window
- Small change in language selection
- Smaller program logo
- New close icon
- New error message: 'Could not find file readme_en.txt'

### TeXfireplace 1.2 (2022/02/25)

- The tex files are associated with tfptexstudio.exe after installation
- Texfireplace folder is removed after installation error
- If TeXstudio Qt6 does not exist, install the Qt5 version
- Other way to detect TeXfireplace directory

### TeXfireplace 1.1 (2022/02/09)

- Fixed file association in case accented filename
- Menu selection is not just with icon
- Fixed the TeXfireplace menu's minor bug

### TeXfireplace 1.0 (2022/01/04)

- First published release
