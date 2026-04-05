IMAGE       ?= claude-devcon:latest
INSTALL_DIR ?= $(HOME)/.local/bin
COMPLETION_BASH ?= $(HOME)/.local/share/bash-completion/completions
COMPLETION_ZSH  ?= $(HOME)/.zsh/completions

.PHONY: all build test test-script test-image install install-bin install-completions \
        uninstall uninstall-bin uninstall-completions clean

all: build test

build:
	docker build -t $(IMAGE) .

test: test-script test-image

test-script:
	@command -v bats >/dev/null 2>&1 \
	  || { echo "bats not found — install with: brew install bats-core"; exit 1; }
	bats tests/test_script.bats

test-image: build
	bash tests/test_image.sh

install: install-bin install-completions

install-bin:
	mkdir -p $(INSTALL_DIR)
	install -m 755 claude-devcon $(INSTALL_DIR)/claude-devcon
	@echo "Installed to $(INSTALL_DIR)/claude-devcon"
	@echo "Ensure $(INSTALL_DIR) is in your PATH"

install-completions:
	mkdir -p $(COMPLETION_BASH)
	install -m 644 completions/claude-devcon.bash $(COMPLETION_BASH)/claude-devcon
	mkdir -p $(COMPLETION_ZSH)
	install -m 644 completions/_claude-devcon $(COMPLETION_ZSH)/_claude-devcon
	@echo "Installed bash completion to $(COMPLETION_BASH)/claude-devcon"
	@echo "Installed zsh completion to $(COMPLETION_ZSH)/_claude-devcon"

uninstall: uninstall-bin uninstall-completions

uninstall-bin:
	rm -f $(INSTALL_DIR)/claude-devcon
	@echo "Removed $(INSTALL_DIR)/claude-devcon"

uninstall-completions:
	rm -f $(COMPLETION_BASH)/claude-devcon
	rm -f $(COMPLETION_ZSH)/_claude-devcon
	@echo "Removed completions"

clean:
	docker rmi $(IMAGE) 2>/dev/null || true
