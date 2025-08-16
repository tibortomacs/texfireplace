[Download]: https://tibortomacs.github.io/texfireplace/texfireplace.exe
[Webpage]: https://tibortomacs.github.io/texfireplace/

[<img src="texfireplace.svg" height="75"/>][Webpage]
[<img src="download.svg" height="75" align="right"/>][Download]

# An easy-to-install compact framework for using LaTeX on Windows

## What is LaTeX?

LaTeX (pronounced either “lah-tech” or “lay-tech”) is a document preparation system designed to produce high-quality typeset output.
Unlike common word processors such as Microsoft Word or LibreOffice Writer, LaTeX does not provide WYSIWYG (“What You See Is What You Get”). 
With LaTeX one takes plain text and enriches it with markup. 
This markup tells LaTeX about the logical meaning of certain elements of the text, similar to the way HTML does.

Using LaTeX requires a TeX distribution. 
It is a collections of packages and programs (compilers, fonts, and macro packages) that can turn the LaTeX source code into a printable output format (usually PDF).

LaTeX source codes are simply plain text, so they can be edited with any text editor (e.g. Notepad). 
However, it’s most convenient to have an editor that is designed to work with LaTeX, as they provide features like one-click compilation of your files, built-in PDF viewers, and syntax highlighting.

## What is TeXfireplace?

The _TeXfireplace_ is an easy-to-install compact framework for using LaTeX on Windows.
The installer downloads and installs the following programs: 

- **MiKTeX**
([https://miktex.org](https://miktex.org)) <br>
A TeX distribution, portable _“just enough”_ basic version with updated packages, extended by `cm-super` and `latexmk`.
_“Just enough”_ means that the users install just the TeX packages they need for their authoring tasks.
This minimizes the installation time and the required disk space.
The missing necessary TeX packages will be installed automatically from the Internet while the tex file is compiling.

- **TeXstudio**
([https://www.texstudio.org](https://www.texstudio.org)) <br>
Fully featured LaTeX-specific editor with integrated PDF viewer.
Portable version, modified default settings.
By default, the `latexmk` automates the process of compiling the LaTeX documents.

- **TLPerl**
(minimal Perl installation of [TeX Live](https://www.tug.org/texlive))
or
**Strawberry Perl**
([https://strawberryperl.com](https://strawberryperl.com)) <br>
for running Perl scripts such as `latexmk` ([https://ctan.org/pkg/latexmk](https://ctan.org/pkg/latexmk)).

- **Python**
([https://www.python.org](https://www.python.org)),
**Pygments**
([https://pygments.org](https://pygments.org))
and
**latexminted**<br>
for `minted` ([https://ctan.org/pkg/minted](https://ctan.org/pkg/minted)) LaTeX package.

## Installing TeXfireplace

Download the **[TeXfireplace installer][download]** (about 4MB) and run it! Internet connection is required for installation.
After finishing the process (about 5-10 minutes) click the TeXstudio icon on the desktop (or in the start menu) and happy LaTeXing!

[<img src="download2.svg" height="30"/>][Download]

- **SHA-256:** `d7bd443dbb7fe89c4f28bbc7bfb4fb0587402f83e865ed944f4e4f250300ddf3`

- TeXfireplace will be installed for the current user, no admin privileges are required.

- You can set which Perl system you want to use (TLPerl or Strawberry Perl).

- The installation of Python/latexminted is optional.

- There are three options where to specify the PATHs to use TeXfireplace:

     - **TeXstudio Setup file (texstudio.ini)** <br>
     The texstudio.ini file contains the settings for TeXstudio.
     If you choose this, the PATHs are made available using TeXstudio and are placed at the end of the `%PATH%` environment variable.
     However, in the terminal started from TeXstudio, the PATHs are placed at the beginning of the `%PATH%` environment variable.
     When using an external terminal, the `%PATH%` environment variable will not contain the PATHs to TeXfireplace.

     - **TeXstudio Startup file (texstudio.vbs)** <br>
     The texstudio.vbs is a startup file for TeXstudio which will put the PATHs at the beginning of the `%PATH%` environment variable before running.
     Therefore, the PATHs are made available using TeXstudio.
     When using an external terminal, the `%PATH%` environment variable will not contain the PATHs to TeXfireplace.

     - **Registry for the current user** <br>
     If you choose this, the PATHs will be written in the registry (HKCU) at the beginning of the `%PATH%` environment variable.

## Updating older versions

Support for versions 4.3 and older has been discontinued.
To upgrade from these versions, first uninstall them and then reinstall the current version.

## Give feedback

Feature requests, bug reports, and questions can be placed in the **[issue tracker](https://github.com/tibortomacs/texfireplace/issues)**. 

## License

The TeXfireplace is licensed to you under the terms of the GNU General Public License Version 2 as published by the Free Software Foundation.

The TeXfireplace icon is provided by Recognize (recognizeapp.com) as Creative Commons Attribution 4.0 International License.

---

*The TeXfireplace installer is a batch script that can be run from a graphical user interface. The GUI is written in Free Pascal using Lazarus.
It is a free and open source program maintained by Tibor Tómács.*

---

<p align="center"><img src="texfireplace-puzzle.svg" height="60"/></p>