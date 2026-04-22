@echo off
echo Watching Tailwind CSS changes...
echo Press Ctrl+C to stop.
tailwindcss-windows-x64.exe -i input.css -o src/main/resources/static/css/output.css --watch
