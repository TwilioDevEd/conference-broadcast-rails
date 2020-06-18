.PHONY: install serve

install:
	bundle install

serve:
	bundle exec rails server -b 0.0.0.0
