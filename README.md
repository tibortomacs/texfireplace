[Download]: https://github.com/tibortomacs/texfireplace/releases/download/latest/texfpinstaller.exe

![](./images/texfireplace.png)

# An easy-to-install compact framework for using LaTeX on Windows

#### 〔 [What is LaTeX?](whatislatex.md) 〕〔 [TeXfireplace version history](changelog.md) 〕

### Installing

Download the [installer][Download] (about 4MB) and run it! Internet connection is required for installation. After finishing the process (about 5-10 minutes) the TeXfireplace menu opens automatically. Click the TeXstudio menu item and happy LaTeXing! 

[<img src="./images/download.png" width="200">][Download]

Another way is to open a text editor, copy the following lines, save them in a file with the extension `.bat`, and then run it.

    set url=https://github.com/tibortomacs/texfireplace/releases/download/latest
    set file=texfp-inst.zip
    set tempdir=%temp%\texfp%random%
    md "%tempdir%"
    cd /d "%tempdir%"
    curl -L -o %file% %url%/%file%
    tar -xf %file%
    start /min texfpinstall

### TeXfireplace components

The _TeXfireplace_ installer downloads and installs the following programs: 

- **MiKTeX**
([https://miktex.org](https://miktex.org)) <br>
A TeX distribution, portable _“just enough”_ basic version with updated packages, extended by `cm-super` and `latexmk`. _“Just enough”_ means that the users install just the TeX packages they need for their authoring tasks. This minimizes the installation time and the required disk space. The missing necessary TeX packages will be installed automatically from the Internet while the tex file is compiling.
- **Strawberry Perl**
([https://strawberryperl.com](https://strawberryperl.com)) <br>
It is for running Perl scripts such as `latexmk` ([https://ctan.org/pkg/latexmk](https://ctan.org/pkg/latexmk)).
- **Pygments**
([https://pygments.org](https://pygments.org)) <br>
A Python library used by `minted` ([https://ctan.org/pkg/minted](https://ctan.org/pkg/minted)) LaTeX package.
- **TeXstudio**
([https://www.texstudio.org/](https://www.texstudio.org/)) <br>
Fully featured LaTeX-specific editor with integrated PDF viewer. Portable version, modified default settings. By default, the `latexmk` automates the process of compiling the LaTeX documents.
- **TeXfireplace menu** <br>
  - Running TeXstudio, MiKTeX console, terminal, and `texdoc`.
  - Restoring (modified) default TeXstudio settings.
  - Updating all components.
  - Supported languages: English, French, German, Hungarian, Russian.

### License

The TeXfireplace installer and menu are free but closed-source programs.

TeXfireplace © 2022-2024 by Tibor Tómács is licensed under CC BY-NC-ND 4.0. To view a copy of this license, visit [https://creativecommons.org/licenses/by-nc-nd/4.0](https://creativecommons.org/licenses/by-nc-nd/4.0)

The TeXfireplace icon is provided by Recognize (recognizeapp.com) as Creative Commons Attribution 4.0 International License.