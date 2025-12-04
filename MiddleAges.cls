%% MiddleAges.cls
%% ============================================================================
%% Class Name: MiddleAges
%% Description: A LaTeX class for medieval-style manuscripts
%% Author:      Guo-Hui-acoustics
%% Version:     14.1 (Spacing Optimization)
%% Last Update: 2025/12/03
%% ============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{MiddleAges}[2025/12/03 v14.1 Ultimate Manuscript Version]


% 0. 选项传递
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}


% ============================================================================
% 1. 基础宏包加载 (Dependencies)
% ============================================================================
% 页面与排版基础
\RequirePackage{geometry}
\RequirePackage{xcolor}
\RequirePackage{microtype}      % 字体微调
\RequirePackage{calc}           % 计算功能

% 图形与装饰
\RequirePackage{tikz}
\RequirePackage[object=vectorian]{pgfornament}
\RequirePackage{eso-pic}      % 背景图片
\RequirePackage{graphicx}

% 字体与文本
\RequirePackage{fontspec}
\RequirePackage{lettrine}       % 首字下沉
\RequirePackage{lipsum}         % 乱数假文（开发用）

% 标题与目录结构
\RequirePackage{titlesec}
\RequirePackage{titletoc}
\RequirePackage{fancyhdr}
\RequirePackage{marginnote}


% ============================================================================
% 2. 视觉系统定义 (Colors & Fonts)
% ===========================================================================
% 颜色定义
\definecolor{rubric}{HTML}{8B0000} % 朱红 (用于强调/装饰)
\definecolor{ink}{HTML}{362b24}    % 墨色 (用于正文)

% 字体配置
\newcommand{\fontpath}{fonts/}

\setmainfont{AveriaSerifLibre}[
    Path = \fontpath, 
    Extension = .ttf,
    UprightFont = *-Bold, 
    BoldFont = *-Bold,
    ItalicFont = *-BoldItalic, 
    BoldItalicFont = *-BoldItalic
]
\setsansfont{Almendra}[
    Path = \fontpath, 
    Extension = .ttf,
    UprightFont = *-Bold, 
    BoldFont = *-Bold,
    ItalicFont = *-BoldItalic
]
\setmonofont{SpecialElite-Regular}[Path = \fontpath, Extension = .ttf]
\newfontfamily\gothicfont{GrenzeGotisch}[
    Path = \fontpath, 
    Extension = .ttf,
    UprightFont = *-Bold, 
    BoldFont = *-Black
]

% 行距设置
\linespread{1.5}


% ============================================================================
% 3. 页面几何设置 (Geometry)
% ============================================================================
\geometry{
    a4paper,
    top=3cm, bottom=3.5cm,
    inner=2.5cm, outer=5cm,
    marginparwidth=4cm, marginparsep=0.6cm,
    headheight=20pt
}


% ============================================================================
% 4. 装饰组件库 (Graphics & Ornaments)
% ============================================================================
% 基础组件：装饰线 
% 参数：#1=花纹ID, #2=宽度, #3=重复次数
\newcommand{\patternline}[3]{%
    \par\vspace{0.5em}\noindent
    \makebox[\textwidth][c]{%
        \begin{tikzpicture}
            \pgfmathsetlengthmacro{\ornamentwidth}{#2}
            % 判断重复次数
            \ifnum#3=1
                % 只有1个，直接居中
                \node[anchor=center] at (0,0) {%
                    \color{rubric}\pgfornament[width=#2]{#1}%
                };
            \else
                % 多个，计算步长
                \pgfmathsetmacro{\totalsteps}{#3-1}
                \pgfmathsetlengthmacro{\step}{(\textwidth-\ornamentwidth)/\totalsteps}
                \foreach \x in {0,1,...,\totalsteps} {
                    \node[anchor=center] at ({\ornamentwidth/2 + \x*\step}, 0) {%
                        \color{rubric}\pgfornament[width=#2]{#1}%
                    };
                }
            \fi
        \end{tikzpicture}%
    }%
    \par\vspace{0.5em}%
}

% 预定义装饰样式
\newcommand{\tocTopLine}{\patternline{70}{0.8cm}{10}}
\newcommand{\tocBottomLine}{\patternline{70}{0.8cm}{10}}

\newcommand{\chapTopLine}{%
    \par\noindent
    \makebox[\textwidth][c]{\resizebox{\textwidth}{!}{\color{rubric}\pgfornament{88}}}\par
}

\newcommand{\chapBottomLine}{%
    \par\noindent
    \makebox[\textwidth][c]{\resizebox{\textwidth}{!}{\color{rubric}\pgfornament{89}}}\par
}

% 页眉装饰
\newcommand{\headerOrnamentLine}{%
    \vspace{-4pt}\noindent
    \begin{tikzpicture}[inner sep=0pt, outer sep=0pt, baseline=(current bounding box.center)]
        \node[anchor=west] (LeftOrn) at (0,0) {\color{rubric}\pgfornament[width=0.6cm]{11}};
        \node[anchor=east] (RightOrn) at (\textwidth,0) {\color{rubric}\pgfornament[width=0.6cm, symmetry=v]{11}};
        \draw[rubric, line width=0.4pt, shorten >=0.5em, shorten <=0.5em] 
             (LeftOrn.east) -- (RightOrn.west);
    \end{tikzpicture}
}

% 用户功能：背景设置
\newcommand{\setbackground}[1]{%
    \ClearShipoutPictureBG % 清除之前的背景（防止叠加）
    \AddToShipoutPictureBG{%
        \AtPageLowerLeft{%
            \ifodd\value{page}%
                % 奇数页：正常显示
                \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
            \else%
                % 偶数页：水平翻转 (Reflect)
                \reflectbox{\includegraphics[width=\paperwidth,height=\paperheight]{#1}}%
            \fi%
        }%
    }%
}

% 用户功能：普通装饰分割线
\newcommand{\medievaldecoration}{%
    \vspace{2em}
    \begin{center}
        \color{rubric}\pgfornament[width=4cm]{88}
    \end{center}
    \vspace{2em}
}


% ============================================================================
% 5. 标题格式设计 (Titlesec)
% ============================================================================
% Section 统一样式 
\titleformat{\section}
  {\normalfont\Large\color{rubric}\sffamily\centering}
  {%
    \raisebox{2pt}{\pgfornament[width=0.4cm]{9}}%
    \hspace{0.5em}\thesection\hspace{0.5em}%
    \raisebox{2pt}{\pgfornament[width=0.4cm]{9}}%
  }
  {0.5em}
  {}

% 动态样式定义函数
% 定义 FrontMatter (前言) 的章节外观
\newcommand{\@styleFrontMatterChapter}{%
    \titleformat{\chapter}[display]
      {\normalfont\centering}
      {} {0pt}
      {\tocTopLine\vspace{-1em}\Huge\color{ink}\gothicfont}
      [\vspace{0em}\tocBottomLine]
}

% 定义 MainMatter (正文) 的章节外观
\newcommand{\@styleMainMatterChapter}{%
    \titleformat{\chapter}[display]
      {\normalfont\centering}
      {\Huge\gothicfont\color{rubric} Chapter \thechapter}
      {0pt}
      {\chapTopLine\vspace{1em}\Huge\color{ink}\gothicfont}
      [\vspace{0em} \chapBottomLine]
}

% 定义 Numberless (无编号) 章节外观
\titleformat{name=\chapter,numberless}[display]
  {\normalfont\centering}
  {} {0pt}
  {\tocTopLine\vspace{0em}\Huge\color{ink}\gothicfont}
  [\vspace{0em}\tocBottomLine \vspace{-0.5em}]


% 间距设置
\titlespacing*{\chapter}{0pt}{0pt}{60pt}
\titlespacing*{name=\chapter,numberless}{0pt}{0pt}{30pt}




% ============================================================================
% 6. 目录样式 (TOC)
% ============================================================================
\renewcommand{\contentsname}{Table of Contents}
% Chapter 条目
\titlecontents{chapter}[0pt]
    {\addvspace{1em}\large\gothicfont\color{ink}}
    {\color{rubric}Chapter \thecontentslabel\quad}
    {}
    {\hfill\color{rubric}\thecontentspage}

% Section 条目
\titlecontents{section}[2em]
    {\addvspace{0.2em}\sffamily\color{ink}}
    {\thecontentslabel\quad}
    {}
    {\hfill\thecontentspage}

% 重定义目录命令：添加特殊的页面清除和样式重置
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{%
    \clearpage
    \begingroup
        \pagestyle{empty}
        \oldtableofcontents
        \thispagestyle{empty}
        \clearpage
    \endgroup
}


% ============================================================================
% 7. 页眉页脚 (Fancyhdr)
% ============================================================================

% 样式 A: FrontMatter
\fancypagestyle{frontmatterstyle}{%
    \fancyhf{}
    \fancyfoot[C]{\color{rubric}\sffamily \textbullet\ \thepage\ \textbullet}
    \renewcommand{\headrulewidth}{0pt}
}

% 样式 B: MainMatter
\fancypagestyle{mainmatterstyle}{%
    \fancyhf{}
    \fancyhead[CE]{%
        {\color{rubric}\sffamily \thepage \quad $\cdot$ \quad \leftmark} \\ 
        \headerOrnamentLine
    }
    \fancyhead[CO]{%
        {\color{rubric}\sffamily \rightmark \quad $\cdot$ \quad \thepage} \\ 
        \headerOrnamentLine
    }
    \renewcommand{\headrulewidth}{0pt}
}

% 样式 C: Plain (用于章首页) 
\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyfoot[C]{\color{rubric}\sffamily \textbullet\ \thepage\ \textbullet}
  \renewcommand{\headrulewidth}{0pt}
}


% ============================================================================
% 8. 辅助功能组件 (Helpers)
% ============================================================================
% 旁注 (Side Note)
\newcommand{\sidenote}[1]{%
    \marginpar{%
        \footnotesize\rmfamily\color{rubric}%
        \itshape\raggedright\vspace{0pt}#1%
    }%
}

% 章节概览模块 (文本框 + 箴言)
% 参数：#1=标题, #2=列表内容, #3=箴言正文, #4=箴言出处
\newcommand{\chapteroverview}[4]{%
    \begin{center}
        \begin{tikzpicture}
            % --- 1. 核心盒子 (Box) ---
            \node (box) [align=left, text width=0.85\textwidth, inner sep=15pt] {
                % 框内标题
                \begin{center}
                    \color{rubric}\pgfornament[width=0.5cm]{11} 
                    \textbf{\large \gothicfont #1} 
                    \color{rubric}\pgfornament[width=0.5cm, symmetry=v]{11}
                \end{center}
                % 框内列表
                \normalsize\sffamily\color{ink} 
                \begin{itemize} \setlength{\itemsep}{0.3em} 
                    #2
                \end{itemize}
            };
            
            % --- 2. 绘制边框 ---
            \draw[rubric, line width=1pt] (box.north west) rectangle (box.south east);
            \draw[rubric, line width=0.5pt] ([xshift=2pt, yshift=-2pt]box.north west) rectangle ([xshift=-2pt, yshift=2pt]box.south east);
            
            % --- 3. 四角装饰 ---
            \node[anchor=north west] at (box.north west) {\color{rubric}\pgfornament[width=0.6cm]{63}};
            \node[anchor=north east] at (box.north east) {\color{rubric}\pgfornament[width=0.6cm, symmetry=v]{63}};
            \node[anchor=south west] at (box.south west) {\color{rubric}\pgfornament[width=0.6cm, symmetry=h]{63}};
            \node[anchor=south east] at (box.south east) {\color{rubric}\pgfornament[width=0.6cm, symmetry=c]{63}};

            % --- 4. 箴言 (Quote) ---
            % 调整：yshift 控制文本框底边到第一行箴言的距离，设为 \baselineskip (一个行距)
            % 调整：\\[\baselineskip] 控制正文与作者之间的距离，设为一个行距
            \node [anchor=north east, text width=0.8\textwidth, align=flush right, yshift=-1em] at (box.south east) {
                \small\ttfamily\color{ink} "#3"  \\
                \small\rmfamily\scshape \color{rubric} --- #4
            };
        \end{tikzpicture}
    \end{center}

}


% ============================================================================
% 9. 文档结构钩子 (Hooks)
% ============================================================================
% 前言区钩子
\renewcommand{\frontmatter}{%
    \clearpage
    \@mainmatterfalse
    \pagenumbering{roman}
    \pagestyle{frontmatterstyle}
    \@styleFrontMatterChapter % 应用样式
}

% 正文区钩子
\renewcommand{\mainmatter}{%
    \clearpage
    \@mainmattertrue
    \pagenumbering{arabic}
    \pagestyle{mainmatterstyle}
    \@styleMainMatterChapter % 应用样式
}

% 初始化
\AtBeginDocument{
    \color{ink}
    \@styleFrontMatterChapter % 默认应用前言样式
}


\endinput
%% End of MiddleAges.cls