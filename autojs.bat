@echo on
cls
cd D:\wk\bcx\explorer
d:
:p
call node --stack-size=10000 scripts/sync.js index update
ping -n 60 127.0.0.1
goto p