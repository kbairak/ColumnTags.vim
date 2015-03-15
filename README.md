# Column Tags - Follow your tags in column-view

## Overview

This plugin aims to help you navigate through you code using
[tags](http://ctags.sourceforge.net/). Vim already has good support for this.
Having generated a tags file in your current working directory, if you move
your cursor over a keyword while in command mode and press `CTRL-]`, you will
navigate to the definition of the keyword within your project and pressing
`CTRL-t` will take you back to where you came from.

Using this plugin, the experience is very similar, but you can take advantage
of Vim's support for multiple windows and a wide screen to maintain an overview
of both the part of the code you navigated from and the part of the code that
hosts the definition of you keyword. The final experience is reminiscent of the
column-view of Mac's file manager program, Finder.

![Column-view screenshot](http://cdn.osxdaily.com/wp-content/uploads/2010/02/mac-os-x-finder-column-view.JPG)

To get started, you must create a tags file in the base folder of you project.
Most developmnent environments come with *ctags* installed, so simply run:

    cd <path-to-project>
    ctags -R .

While using the plugin, you will have up to 3 windows displayed as columns.

With `CTRL-]`, you can follow the tag under the cursor in a new vertical split.
If the number of existing columns is `g:max_columns` and the rightmost column
is focused, the view will be shifted to the left before doing the vertical
split. If you follow a tag from a column that is not rightmost, the new column
will replace those that are to the right of the one that was in focus. The goal
is to be able to view both the part of the code that executes a function or
class and its definition at the same time.

With `CTRL-t`, you can go back to where you were before following a tag. If the
column under focus is not the leftmost, this simply means focusing on the
column to the left. If the leftmost column was focused, the windows that got
hidden by following tags and moving towards the right will start being
revealed.


## Installation

Just paste the package's contents into into your .vim directory.


## Installing with [Pathogen](https://github.com/tpope/vim-pathogen)

1. `cd ~/.vim/bundle`
2. `git clone git://github.com/kbairak/ColumnTags.vim.git


## Usage

- Press `CTRL-]` to follow a tag and open it in a column right of the one you
  are focused on
- Press `CTRL-t` to go back to where you came from before following a tag. If
  you are not on the leftmost column, this will simpley focus the column to the
  left. If you are on the leftmost column, this wil shift all columns to the
  right and reveal the file you navigated to the leftmost column from
- Press `CTRL-,` to shift all columns to the right and reveal the file you
  navigated to the leftmost column from


## Customization

You can customize the maximum number of columns visible by putting this in your
.vimrc (default is 3):

    let g:max_columns = 4
