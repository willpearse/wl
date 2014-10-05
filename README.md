wl: Will's Library of Will
==========================
A note-taking system for those tired of complications

##Licence
See file ``LICENCE``. GPL v2.

##Overview 
If you have any of:
* folder(s) of PDFs you've read
* a file containing notes about those PDFs
* a folder(s) of notes about meetings or ideas
* a desire to simply search them
...this is the program for you.

##Instructions
1. Open up 'wl.rb' and add each parameter. Examples are given; remember that folder can have sub-folders that will also be searched.
2. (optional) run something like ``sudo ln -s /home/user/wl/wl.rb /usr/bin/wl`` to let you run ``wl`` more easily
3. Done!

##Examples searches
* ``wl -p tilman`` - search for papers written by Tilman, and any notes you've written about his papers
* ``wl -p tilman -o 2`` - as above, but open the second PDF the program finds
* ``wl -n tilman`` - search your folder of notes and meetings (NOTE: different from you file with notes about papers) for anything by Tilman
* ``wl -n tilman --thorough`` - as above, but also search inside files in your notes folder. You can make this the default behavour by editing ``wl.rb`` as described above.

##Notes
This is hardly likely to be the best way to store things. This just happens to work well for me. The script is not battle-tested, and will break if you ask it things it can't figure out (e.g., don't search for PDFs if you have no PDF directory).

It is easy to edit this; e.g., to make it search a directory of notes on papers. I occasionally update this, and have vague plans to make more features. Ask if interested.