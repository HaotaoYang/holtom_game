deps:
	@rebar3 get-deps			## 获取依赖包

compile:
	@rebar3 compile				## 编译

clean:
	@rebar3 clean				## 只清除项目beam文件

clean_all: clean				## 清除所有生成的文件，包括依赖包和日志
	@rm -rf _build
	@rm -rf log

shell:							## 运行（编译之后即可运行）
	@rebar3 shell

release:						## 发布
	@rebar3 release

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
