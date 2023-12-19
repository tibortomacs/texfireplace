[Download]: https://github.com/tibortomacs/texfireplace/releases/download/latest/texfp-inst.exe

![](./images/texfireplace.png)

# An easy-to-install compact framework for using LaTeX on Windows

#### 〔 [What is LaTeX?](whatislatex.md) 〕〔 [TeXfireplace version history](changelog.md) 〕

### How to install

Download the [installer][Download] (about 8MB) and run it! An internet connection is required for the installation. When the process is finished (about 5-10 minutes) the TeXfireplace menu will open automatically. Click on the menu item TeXstudio and _“happy LaTeXing”_! 

[<img src="./images/download.png" width="200">][Download]

### TeXfireplace components

The _TeXfireplace_ installer downloads and installs the following programs: 

- **MiKTeX**
([https://miktex.org](https://miktex.org)) <br>
A TeX distribution, portable _“just enough”_ basic version with updated packages, extended by `cm-super` and `latexmk`. _“Just enough”_ means that users install only the TeX packages they need for their authoring tasks. This minimises installation time and disk space requirements. The missing necessary TeX packages are automatically installed from the Internet during the compilation of the tex file.
- **TLPerl** <br>
Minimal Perl installation of [TeX Live](https://www.tug.org/texlive) to run `latexmk` ([https://ctan.org/pkg/latexmk](https://ctan.org/pkg/latexmk)).
- **Pygments**
([https://pygments.org](https://pygments.org)) <br>
A Python library used by the `minted` ([https://ctan.org/pkg/minted](https://ctan.org/pkg/minted)) LaTeX package.
- **TeXstudio**
([http://www.texstudio.org](http://www.texstudio.org)) <br>
Fully featured LaTeX-specific editor with integrated PDF viewer. Portable version, modified default settings. By default, the `latexmk` automates the process of compiling the LaTeX documents.
- **TeXfireplace menu** <br>
  - Running TeXstudio, MiKTeX console, terminal, and `texdoc`.
  - Restoring (modified) default TeXstudio settings.
  - Updating all components.

### Copyright ©

TeXfireplace: Tibor Tómács <br>
MiKTeX: Christian Schenk <br>
TeXstudio: Benito van der Zander, Jan Sundermeyer, Daniel Braun, Tim Hoffmann <br>
Pygments: Georg Brandl, Matthäus Chajdas and contributors

<br>

> _The TeXfireplace icon is provided by Recognize (recognizeapp.com) as Creative Commons Attribution 4.0 International License._ <br>
> _The TeXfireplace installer and menu are freeware, closed source projects._
