deps:							## 获取依赖包
	@rebar3 get-deps

compile:						## 编译
	@rebar3 compile

clean:							## 只清除项目beam文件
	@rebar3 clean

clean_all: clean				## 清除所有生成的文件，包括依赖包和日志
	@rm -rf _build
	@rm -rf log

shell:							## 运行（编译之后即可运行）
	@rebar3 shell

auto:							## 运行（每次文件修改都会进行热更，只使用于开发，需要安装inotify-tools，还需要在~/.config/rebar3/rebar.config中加入{plugins, [rebar3_auto]}.）
	@rebar3 auto

release:						## 发布
	@rebar3 release

run:							## 运行（在发布后运行，代替_build/default/rel/<release>/bin/<release> console，需要在~/.config/rebar3/rebar.config中加入{plugins, [rebar3_run]}.）
	@rebar3 run

tar:							## 打包
	@rebar3 tar

prod_compile:					## 编译（生产环境）
	@rebar3 as prod compile

prod_release:					## 发布（生产环境）
	@rebar3 as prod release

prod_tar:						## 打包（生产环境）
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
