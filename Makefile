.PHONY: test lint format check

test:
	busted tests/

lint:
	luacheck lua/ tests/

format:
	stylua lua/ tests/

check: lint test
