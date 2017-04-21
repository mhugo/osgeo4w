scp ../genini ../gen_setup_ini.sh %RELEASE_HOST%:~/ || goto :error
ssh %RELEASE_HOST% "./gen_setup_ini.sh %1" || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

