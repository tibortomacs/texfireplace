[Download]: https://github.com/tibortomacs/texfireplace/releases/download/latest/texfpinstaller.exe

![](./images/texfireplace.png)

# An easy-to-install compact framework for using LaTeX on Windows

#### 〔 [What is LaTeX?](whatislatex.md) 〕〔 [TeXfireplace version history](changelog.md) 〕

### Installing

Download the [installer][Download] (about 4MB) and run it! Internet connection is required for installation. After finishing the process (about 5-10 minutes) the TeXfireplace menu opens automatically. Click the TeXstudio menu item and happy LaTeXing! 

[<img src="./images/download.png" width="200">][Download]

Another option is to open a text editor, copy the following lines, save them in a file with a `.bat` extension, and then run the file.

    set url=https://github.com/tibortomacs/texfireplace/releases/download/latest/
    set file=texfp-inst.zip
    set dir=%temp%\texfp%random%
    md "%dir%"
    cd /d "%dir%"
    curl -L -o %file% %url%%file%
    unzip %file%
    start /min texfpinstall

### TeXfireplace components

The _TeXfireplace_ installer downloads and installs the following programs: 

- **MiKTeX**
([https://miktex.org](https://miktex.org)) <br>
A TeX distribution, portable _“just enough”_ basic version with updated packages, extended by `cm-super` and `latexmk`. _“Just enough”_ means that the users install just the TeX packages they need for their authoring tasks. This minimizes the installation time and the required disk space. The missing necessary TeX packages will be installed automatically from the Internet while the tex file is compiling.
- **TLPerl** <br>
Minimal Perl installation of [TeX Live](https://www.tug.org/texlive) for running `latexmk` ([https://ctan.org/pkg/latexmk](https://ctan.org/pkg/latexmk)).
- **Pygments**
([https://pygments.org](https://pygments.org)) <br>
A Python library used by `minted` ([https://ctan.org/pkg/minted](https://ctan.org/pkg/minted)) LaTeX package.
- **TeXstudio**
([http://www.texstudio.org](http://www.texstudio.org)) <br>
Fully featured LaTeX-specific editor with integrated PDF viewer. Portable version, modified default settings. By default, the `latexmk` automates the process of compiling the LaTeX documents.
- **TeXfireplace menu** <br>
  - Running TeXstudio, MiKTeX console, terminal, and `texdoc`.
  - Restoring (modified) default TeXstudio settings.
  - Updating all components.
  - Supported languages: English, French, German, Hungarian, Russian.

### Copyright ©

TeXfireplace: Tibor Tómács <br>
MiKTeX: Christian Schenk <br>
TeXstudio: Benito van der Zander, Jan Sundermeyer, Daniel Braun, Tim Hoffmann <br>
Pygments: Georg Brandl, Matthäus Chajdas and contributors

<br>

> _The TeXfireplace icon is provided by Recognize (recognizeapp.com) as Creative Commons Attribution 4.0 International License._ <br>
> _The TeXfireplace installer and menu are freeware, closed source projects._
