APP_NAME=holtom_game
APP_VSN=$(shell awk '/release_vsn/{ print $$1 }' rebar.config | tr -d \")

###===================================================================
### build
###===================================================================
.PHONY: deps compile clean clean_all shell auto release run tar appup_gen relup_tar prod_compile prod_release prod_tar prod_appup_gen prod_relup_tar

deps:							## 获取依赖包
	@rebar3 get-deps

compile:						## 编译
	@rebar3 compile

upgrade:						## 升级deps
	@rebar3 upgrade

clean:							## 只清除项目beam文件
	@rebar3 clean

clean_all: clean				## 清除所有生成的文件，包括依赖包和日志
	@rebar3 clean -a
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

appup_gen:						## 版本更新生成.appup文件（需要安装rebar3_appup_plugin）
	@rebar3 appup generate

relup_tar:						## 版本更新打包（需要安装rebar3_appup_plugin）
	@rebar3 relup tar

prod_compile:					## 编译（生产环境）
	@rebar3 as prod compile

prod_release:					## 发布（生产环境）
	@rebar3 as prod release

prod_tar:						## 打包（生产环境）
	@rebar3 as prod tar

prod_appup_gen:					## 版本更新生成.appup文件（需要安装rebar3_appup_plugin）（生产环境）
	@rebar3 as prod appup generate

prod_relup_tar:					## 版本更新打包（需要安装rebar3_appup_plugin）（生产环境）
	@rebar3 as prod relup tar

###===================================================================
### release
###===================================================================
.PHONY: dev prod

dev:
	@rebar3 as dev tar
	@test -d tars/dev || mkdir -p tars/dev
	@cp ./_build/dev/rel/$(APP_NAME)/$(APP_NAME)-$(APP_VSN).tar.gz ./tars/dev/dev-$(APP_NAME)-$(APP_VSN).tar.gz

prod:
	@rebar3 as prod tar
	@test -d tars/prod || mkdir -p tars/prod
	@cp ./_build/prod/rel/$(APP_NAME)/$(APP_NAME)-$(APP_VSN).tar.gz ./tars/prod/prod-$(APP_NAME)-$(APP_VSN).tar.gz

###===================================================================
### private
###===================================================================
