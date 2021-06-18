@echo off

set type=%1
set flavor=%2

gradlew assemble%flavor%%type%
