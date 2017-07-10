deps:
	@rebar3 get-deps

compile:
	@rebar3 compile

clean:
	@rebar3 clean

clean_all: clean
	@rm -rf _build
	@rm -rf log

release:
	@rebar3 release

prod_compile:
	@rebar3 as prod compile

prod_release:
	@rebar3 as prod release

prod_tar:
	@rebar3 as prod tar

## ============================================
## private
## ============================================
mk_dir:
	@if [ -d $(dir) ]; then \
		echo "mkdir $(dir) ok"; \
	else \
		mkdir $(dir); \
		echo "mkdir $(dir) ok"; \
	fi;
