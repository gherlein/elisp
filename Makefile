install:
	-rm ~/.emacs.d
	-rm ~/.emacs
	-ln -s ~/elisp/ ~/.emacs.d
	-ln -s ./elisp/emacs ~/.emacs

clean:
	rm *~
