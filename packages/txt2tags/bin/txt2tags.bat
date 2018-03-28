@echo off
call "@osgeo4w@\bin\o4w_env.bat"
python "@osgeo4w@\bin\txt2tags.py" %*
