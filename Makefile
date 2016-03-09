.PHONY: test
test:
	@_test/test-charts $(TEST_CHARTS)

.PHONY: lint
lint:
	@_test/lint-charts $(TEST_CHARTS)
