% cms-contest
%
% Copyright (c) 2013 Gabriele Farina (gabr.farina@gmail.com)
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% Based on the work at
%  - https://github.com/GassaFM/olymp.sty/
%  - https://github.com/boi-2014/tasks/


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cms-contest}
\LoadClass[11pt,a4paper]{article}

\RequirePackage{enumitem}
\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{color} % for colored text
\RequirePackage{import} % for changing current dir
\RequirePackage{epigraph}
\RequirePackage{daytime} % for displaying version number and date
\RequirePackage{wrapfig} % for having text alongside pictures
\RequirePackage{verbatim}
\RequirePackage{tikz}
\RequirePackage{booktabs}
\RequirePackage{eurosym}
\RequirePackage{fancyhdr}
\RequirePackage{calc}
\RequirePackage{float}
\RequirePackage{lastpage}
\RequirePackage{listings}
\RequirePackage{lmodern}
\RequirePackage{multirow}
\RequirePackage{placeins}
\RequirePackage[compact]{titlesec}
\RequirePackage{ifthen}
\RequirePackage{tabularx}

\pagestyle{fancy}

\newif\if@showproblemletter
\newif\if@showproblemnumber
\newif\if@intentionallyblankpages

\newif\if@showlogo\@showlogofalse
\newif\if@english\@englishtrue
\newif\if@italian

\DeclareOption{problemletters}{\@showproblemlettertrue}
\DeclareOption{problemnumbers}{\@showproblemnumbertrue}
\DeclareOption{intentionallyblankpages}{\@intentionallyblankpagestrue}

% Language support
\gdef\@languagecode{EN}
\DeclareOption{english}{}
\DeclareOption{italian}{\@englishfalse\@italiantrue\gdef\@languagecode{IT}}

\ProcessOptions\relax

%*********************************************************************
%                        Import language file                        *
%*********************************************************************

\if@italian  \input{locale/italian}\fi
\if@english  \input{locale/english}\fi

%*********************************************************************
%                          Sizes and margins                         *
%*********************************************************************

\newlength{\thelinewidth}
\newlength{\exmpwidinf}
\newlength{\exmpwidouf}
\newlength{\exmpwidewid}
\newlength{\exmpthreewidinf}
\newlength{\exmpthreewidouf}
\newlength{\exmpthreewidnote}
\newlength{\afterproblemhead}
\newlength{\afterconstraints}
\newlength{\logolength}
\newlength{\logomargin}

\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\headheight=20mm
\headsep=8mm
\parindent=0mm
\parskip=6pt
\hoffset=-24mm
\voffset=-20mm
\textheight=233mm
\textwidth=175mm

\exmpwidinf=0.475\textwidth
\exmpwidouf=0.475\textwidth
\exmpwidewid=0.9\textwidth
\exmpthreewidinf=0.28\textwidth
\exmpthreewidouf=0.28\textwidth
\exmpthreewidnote=0.30\textwidth
\afterproblemhead=3mm
\afterconstraints=2mm
\logolength=23mm
\logomargin=3mm

%*********************************************************************
%                           Internal variables                       *
%*********************************************************************
\gdef\this@contestname{Contest name}
\gdef\this@contestlocation{Contest location}
\gdef\this@contestdate{Contest date}
\gdef\this@contestday{}
\gdef\this@contestlogo{logo.png}

\gdef\this@problemtitle{Problem Title}
\gdef\last@problemtitle{}
\gdef\this@problemshorttitle{Problem Short Title}
\gdef\last@problemshorttitle{}
\gdef\this@problemauthor{}
\gdef\last@problemauthor{}
\gdef\this@inputfilename{}
\gdef\this@outputfilename{}
\gdef\this@problemrevnumber{}

%*********************************************************************
%                           Internal macros                          *
%*********************************************************************

% Define the header structure
\lhead{}\rhead{}
\chead{%
	\if@showlogo\else\setlength{\logolength}{0mm}\setlength{\logomargin}{0mm}\fi
    \begin{tabular}{@{}p{\logolength+\logomargin}@{}p{\textwidth-\logolength-\logomargin}@{}}%
        \begin{minipage}[b]{\logolength}%
            \if@showlogo\includegraphics[width=\logolength]{\this@contestlogo}\fi
        \end{minipage} &%
           \begin{minipage}[b]{\textwidth-\logolength-\logomargin}%
            {\sffamily\Large
                \this@contestname%
                \ifthenelse{\equal{\this@contestday}{}} %
                {}{%
                	\hfill\makebox[0pt][r]{\kw@Day~\this@contestday}%
                }%
            }
            \vskip 2.5mm \hrule\vskip 2.5mm%
            {\sffamily\makebox[0pt][l]{%
                \this@contestlocation\unskip\ifthenelse{\equal{\this@contestdate}{}}{}{, \this@contestdate}}%
            \hfill\ttfamily\bfseries\makebox[0pt][r]{\this@problemshorttitle\enskip$\bullet$\enskip\@languagecode\ifthenelse{\equal{\this@problemrevnumber}{}}{}{\enskip$\bullet$\enskip\kw@revision \this@problemrevnumber%
            }}}
        \end{minipage}%
    \end{tabular}%
}
\lfoot{}\rfoot{}
\cfoot{\small 
    \ifthenelse{\equal{\last@problemauthor}{}}%
    {%
        \gdef\footercontent{%
            \if@showproblemletter\kw@Problem~\Alph{@problemcounter}.\ \fi%
            \if@showproblemnumber\kw@Problem~\arabic{@problemcounter}.\ \fi%
            ~\texttt{\this@problemshorttitle\ifthenelse{\equal{\this@problemrevnumber}{}}{}{\enskip\textemdash\enskip\kw@revision \this@problemrevnumber}}%
            {\hfill}%
            \kw@Page\ \thepage\ \kw@of\ \pageref{LastPage}\hfill%
        }%
    }%    
    {%
        \gdef\footercontent{%
            \if@showproblemletter\kw@Problem~\Alph{@problemcounter}.\ \fi%
            \if@showproblemnumber\kw@Problem~\arabic{@problemcounter}.\ \fi%
            ~\texttt{\this@problemshorttitle\ifthenelse{\equal{\this@problemrevnumber}{}}{}{\enskip$\bullet$\enskip\kw@revision \this@problemrevnumber}}%
            {\hfill}%
            {\kw@ProblemAuthor~\last@problemauthor}%
            {\hfill}%
            {\kw@Page\ \thepage\ \kw@of\ \pageref{LastPage}}%
            \quad~%
        }%
    }%
	%
    \parbox{\textwidth}{ %
        \hrule %
        \vspace{6pt} %
        \sffamily %
        \footercontent %
    } %
}

% References to "lastpage"
\def\lastpage@putlabel{\addtocounter{page}{-1}%
   \immediate\write\@auxout{\string\newlabel{LastPage}{{}{\thepage}}}%
   \addtocounter{page}{1}}
\AtEndDocument{\clearpage\lastpage@putlabel}%


% Delete space after verbatiminput 
\addto@hook{\every@verbatim}{\topsep=0pt\relax}

%*********************************************************************
%                           Internal values                          *
%*********************************************************************

% @problemcounter
%
% knows the number of the current problem
\newcounter{@problemcounter}

% @problemtaskcounter
%
% knows the number of the current subtask (relative to the current problem)
\newcounter{@subtaskcounter}[@problemcounter]


%*********************************************************************
%                         Internal commands                          *
%*********************************************************************

% @newsection
%
% This acts like a decorator, and registers a section command such as
% the "Specifications", "Constraints", "Subtask 1" sections
%
% Arguments: 1) new command name     e.g. \Examples
%            2) displayed title      e.g. Sample Cases
\def\@newsection#1#2{
    \DeclareRobustCommand{#1}{
        {
            \beforeproblemsectioncaption
            \noindent\bf\problemsectionfont\textsf{#2}
        }
        \nopagebreak
        \par\afterproblemsectioncaption
    }
}

% @newsectionwithdescr
%
% This acts like a decorator, and registers a section command such as
% the "Specifications", "Constraints", "Subtask 1" sections
%
% Arguments: 1) new command name     e.g. \Examples
%            2) displayed title      e.g. Sample Cases
%
% The resulting command will accept one argument, which will be appended
% to the title.
\def\@newsectionwithdescr#1#2{
    \DeclareRobustCommand{#1}[1]{
        {
            \beforeproblemsectioncaption
            \noindent\bf\problemsectionfont\textsf{#2~##1}
        }
        \nopagebreak
        \par\afterproblemsectioncaption
    }
}


% @problemend
%
% this is run as the final action in the problem environment and must
% account for the intentionally blank pages when the option is set
\newcommand{\@problemend}{%
    \clearpage%
    \if@intentionallyblankpages%
        \ifodd\value{page}%
        \else%
            \vspace*{\fill}%
            \begin{center}%
                \problemheadfont%
                \begin{tikzpicture}%
                    \draw (0,0) node[rectangle, draw=black!40, line width=1.5mm, inner sep = 1cm]%
                        {\textcolor{black!60}{\bfseries \kw@IntentionallyBlankPage}};%
                \end{tikzpicture}%
            \end{center}%
            \vspace*{\fill}%
            \clearpage%
        \fi%
    \fi% 
}

%*********************************************************************
%                           Public commands                          *
%*********************************************************************

% problemheadfont, problemsectionfont, problemtextfont
%
% define standard fonts for differen parts of the problem env.
\newcommand{\problemheadfont}{\LARGE}
\newcommand{\problemsectionfont}{\Large}
\newcommand{\problemtextfont}{\normalsize}

% beforeproblemsectioncaption, afterproblemsectioncaption
\newcommand{\beforeproblemsectioncaption}{\smallbreak\bigskip}
\newcommand{\afterproblemsectioncaption}{\smallskip}

% Expose the newsection* decorators
\newcommand{\createsection}{\@newsection}
\newcommand{\createsectionwithdescr}{\@newsectionwithdescr}

% Define standard sections
\createsection{\Specification}{\kw@Specification}
\createsection{\InputFile}{\kw@Input}
\createsection{\OutputFile}{\kw@Output}
\createsection{\Example}{\kw@Example}
\createsection{\Examples}{\kw@Examples}
\createsection{\Explanation}{\kw@Explanation}
\createsection{\Explanations}{\kw@Explanations}
\createsection{\Illustration}{\kw@Illustration}
\createsection{\Implementation}{\kw@Implementation}
\createsection{\Scoring}{\kw@Scoring}
\createsection{\Note}{\kw@Note}
\createsection{\Notes}{\kw@Notes}
\createsection{\Constraints}{\kw@Constraints}
\createsection{\SubtaskOne}{\kw@SubtaskOne}
\createsection{\SubtaskTwo}{\kw@SubtaskTwo}
\createsection{\SubtaskThree}{\kw@SubtaskThree}
\createsection{\SubtaskFour}{\kw@SubtaskFour}
\createsection{\SubtaskFive}{\kw@SubtaskFive}
\createsection{\SubtaskSix}{\kw@SubtaskSix}
\createsectionwithdescr{\Subtask}{\kw@Subtask}

% SubtaskWithScore
%
% creates the section title for a subtask, specifying the number
% of points. This automatically increments the subtask counter.
%
% Arguments: 1) score for the current subtask   e.g. 20

\newcommand{\SubtaskWithScore}[1]{
    {
        \addtocounter{@subtaskcounter}{1}
        \beforeproblemsectioncaption

        \noindent\problemsectionfont\textsf{\textbf{%
            \kw@Subtask~\arabic{@subtaskcounter}%
        }}%
        \textsf{~(\kw@points:~#1)}

        \nopagebreak
        \par\afterproblemsectioncaption
    }
}

\newcommand{\setContestDay}[1]{
	\gdef\this@contestday{#1}
}

\newcommand{\setProblemAuthor}[1]{
	\gdef\this@problemauthor{#1}
}

\newcommand{\setProblemRevisionNumber}[1]{
	\gdef\this@problemrevnumber{#1}
}

\newcommand{\setContestLogo}[1]{
    \ifthenelse{\equal{#1}{}}{}{%
	   \@showlogotrue%
	   \gdef\this@contestlogo{#1}%
    }
}


%*********************************************************************
%                             Environments                           *
%*********************************************************************

% contest
%
% Arguments: 1) Contest name
%            2) Contest location
%            3) Contest date

\newenvironment{contest}[3]{
    \gdef\this@contestname{#1}
    \gdef\this@contestlocation{#2}
    \gdef\this@contestdate{#3}
}{}

% problem
%
% Arguments: 1) Long title          e.g. Maximum subarray
%            2) Short title         e.g. maxsub
%            3) Input filename      e.g. stdin
%            4) Output filename     e.g. stdout
%            5) Time limit          e.g. 1 second
%            6) Memory limit        e.g. 256 Mib
%

\newenvironment{problem}[6]{
    % Store values so that they don't go lost
    \gdef\last@problemauthor{\this@problemauthor}
    \gdef\last@problemtitle{\this@problemtitle}
    \gdef\this@problemtitle{#1}
    \gdef\last@problemshorttitle{\this@problemshorttitle}
    \gdef\this@problemshorttitle{#2}
    \gdef\this@inputfilename{#3}
    \gdef\this@outputfilename{#4}
    \gdef\this@problemrevnumber{}


    % Add a line to the toc now, so that it is in the right page
    \addcontentsline{toc}{section}{#1 (\texttt{#2})}
    
    % Problem title
    \noindent
    \refstepcounter{@problemcounter}
    \textbf{\problemheadfont\textsf{%
        \if@showproblemletter\kw@Problem~\Alph{@problemcounter}.\ \fi%
        \if@showproblemnumber\kw@Problem~\arabic{@problemcounter}.\ \fi%
        #1 (\texttt{#2})%
    }}%
    
    % Make the summary table
    \nopagebreak
    \par\vspace{\afterproblemhead}
    \problemtextfont\parindent=6.5mm
    \vbox{
        \begin{tabular}{l@{\extracolsep{1cm}}l}
            \kw@InputFileName & \texttt{#3} \\
            \kw@OutputFileName & \texttt{#4} \\
            \kw@TimeLimit & #5~\kw@seconds \\
            \kw@MemoryLimit & #6~MiB \\
        \end{tabular}
    }
    \nopagebreak
    \par\vspace{\afterconstraints}
    
    % Prepare for the problem statement
    \problemtextfont\parindent=0mm%
}{
    \@problemend
}

% example
%
% this is used for writing the sample testcases

\newenvironment{example}{
    \ttfamily\obeylines\obeyspaces\frenchspacing
    %
    \newcommand{\exmp}[2]{%
        \begin{minipage}[t]{\exmpwidinf}\rightskip=0pt plus 1fill\relax##1\medskip\end{minipage}&
        \begin{minipage}[t]{\exmpwidouf}\rightskip=0pt plus 1fill\relax##2\medskip\end{minipage}\\
        \hline
    }

    \newcommand{\exmpfile}[2]{
        \exmp{%
            \verbatiminput{##1}
        }{
            \verbatiminput{##2}
        }%
    }

    \begin{tabular}{|l|l|}
        \hline
        \multicolumn{1}{|c|}{\bf\texttt{\this@inputfilename}}&
        \multicolumn{1}{|c|}{\bf\texttt{\this@outputfilename}}\\
        \hline\hline
        \noindent%
}{
    \end{tabular}
}

% examplewide
%
% this is used for creating full-width examples. input and output are stacked
% vertically instead of horizontally as with the example environment.

\newenvironment{examplewide}{%
    \ttfamily\obeylines\obeyspaces\frenchspacing

    \newcommand{\exmp}[2]{
        \begin{tabular}{|c|}
            \hline
            \multicolumn{1}{|c|}{\bf\texttt{\this@inputfilename}}\\
            \hline
            \begin{minipage}[t]{\exmpwidewid}\rightskip=0pt plus 1fill\relax
                ##1
            \medskip\end{minipage}\\
            \hline
            \multicolumn{1}{|c|}{\bf\texttt{\this@outputfilename}}\\%
            \hline
            \begin{minipage}[t]{\exmpwidewid}\rightskip=0pt plus 1fill\relax
                ##2    
            \medskip\end{minipage}\\%
            \hline
        \end{tabular}
    }

    \newcommand{\exmpfile}[2]{
        \exmp{
            \verbatiminput{##1}
        }{
            \verbatiminput{##2}
        }%
    }
}{
}

% end of cms-style.sty
\makeatother
\sloppy