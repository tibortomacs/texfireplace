[Download]: https://tibortomacs.github.io/texfireplace/texfpinstaller.exe
[Webpage]: https://tibortomacs.github.io/texfireplace/

[<img src="texfireplace.svg" height="75">][Webpage]
[<img src="download.svg" height="75" align="right">][Download]

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
([https://miktex.org](https://miktex.org))
A TeX distribution, portable _“just enough”_ basic version with updated packages, extended by `cm-super` and `latexmk`.
_“Just enough”_ means that the users install just the TeX packages they need for their authoring tasks.
This minimizes the installation time and the required disk space.
The missing necessary TeX packages will be installed automatically from the Internet while the tex file is compiling.

- **Strawberry Perl**
([https://strawberryperl.com](https://strawberryperl.com))
It is for running Perl scripts such as `latexmk` ([https://ctan.org/pkg/latexmk](https://ctan.org/pkg/latexmk)).

- **Pygments**
([https://pygments.org](https://pygments.org))
A Python library used by `minted` ([https://ctan.org/pkg/minted](https://ctan.org/pkg/minted)) LaTeX package.

- **TeXstudio**
([https://www.texstudio.org/](https://www.texstudio.org/))
Fully featured LaTeX-specific editor with integrated PDF viewer.
Portable version, modified default settings.
By default, the `latexmk` automates the process of compiling the LaTeX documents.

- **TeXfireplace menu**
Running TeXstudio, MiKTeX console, terminal, and `texdoc`.
Restoring (modified) default TeXstudio settings.
Updating all components.
Supported languages: English, French, German, Hungarian, Russian.

_The TeXfireplace installer and menu are free but closed-source programs maintained by [Tibor Tómács](https://mailhide.io/e/xjXsYH6m)._

**[TeXfireplace version history](changelog.md)**

## Installing

Download the **[TeXfireplace installer][Download]** (about 4MB) and run it! Internet connection is required for installation. After finishing the process (about 5-10 minutes) the TeXfireplace menu opens automatically. Click the TeXstudio menu item and happy LaTeXing! 

Another way is to open a text editor, copy the following lines, save them in a file with `.bat` extension, and then run it.

    set url=https://tibortomacs.github.io/texfireplace
    set file=texfp-inst.zip
    set tempdir=%temp%\texfp%random%
    md "%tempdir%"
    cd /d "%tempdir%"
    curl -L -o %file% %url%/%file%
    tar -xf %file%
    start /min texfpinstall

## License

TeXfireplace © 2022-2024 by Tibor Tómács is licensed under CC BY-NC-ND 4.0. To view a copy of this license, visit [https://creativecommons.org/licenses/by-nc-nd/4.0](https://creativecommons.org/licenses/by-nc-nd/4.0)

The TeXfireplace icon is provided by Recognize (recognizeapp.com) as Creative Commons Attribution 4.0 International License.