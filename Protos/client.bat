    @echo off

    ::协议文件路径, 最后不要跟“\”符号
    set SOURCE_FOLDER=.\protos

    ::protoc编译器路径
    set PROTOC_COMPILER_PATH=.\protoc-3.17.3-win64\protoc\protoc.exe

    ::pb文件生成路径, 最后不要跟“\”符号
    set PB_TARGET_PATH= ..\Assets\LuaScripts\Net\PB\

    ::删除之前创建的文件
    rd /s /q %PB_TARGET_PATH%

    md %PB_TARGET_PATH%
	echo NetStart
	%PROTOC_COMPILER_PATH% -o %PB_TARGET_PATH%\net.pb --proto_path=%SOURCE_FOLDER% --include_imports net.proto
    echo over
    pause
