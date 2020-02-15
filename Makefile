#  __  __       _         __ _ _
# |  \/  | __ _| | _____ / _(_) | ___
# | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | |  | | (_| |   <  __/  _| | |  __/
# |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#
#############################
## USER CONFIGURABLE SECTIONS
#############################

TARGET_PDF := main.pdf

##########
## RECIPES
##########

# This function computes a list of dependent *requirements.txt files
# from *requirements.in file.
# Usage: $(call CONSTRAINED_TEXFILES,<main.tex>)
CONSTRAINED_TEXFILES = 

.PHONY: help
help:
	@# Show this help message
	@sed -n 'x;G;/^[^\S:]\+:.*\n\s*@#.*$$/{s/^\([^\S:]\+\):.*\n\s*@#\s*\(.\+\)$$/  \1 :: \2/;p;b};g;/^##@/{s/^##@\s*\(.*\)/'"\1"'/;p}' $(MAKEFILE_LIST) \
		| awk -F' :: ' 'BEGIN { printf "Usage: make \033[0;96m<target>\033[0m\n" } /^ / { printf "\033[0;96m%-30s\033[0m %s\n", $$1, $$2 } /^[^ ]/ { printf "\n\033[1m%s\033[0m\n", $$0 }'

#############################
##@ XeLaTeX Document Building
#############################

.PHONY: $(TARGET_PDF)
$(TARGET_PDF): %.pdf: %.tex
	latexmk -xelatex -interaction=nonstopmode $<

.PHONY: build
build: $(TARGET_PDF)
	@# Build all target PDFs

.PHONY: clean
clean:
	@# Clean all intermediate cached files
	latexmk -c
	rm -f *.synctex.gz

#####################
##@ Program Shortcuts
#####################

.PHONY: git_show_tree
git_show_tree:
	@# Show git commit history as a nice tree
	@git log --graph --abbrev-commit --decorate --all \
		--format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'

###################
## SECOND EXPANSION
###################

.SECONDEXPANSION:
$(TARGET_PDF): %.pdf: $$(call CONSTRAINED_TEXFILES,$$<)
