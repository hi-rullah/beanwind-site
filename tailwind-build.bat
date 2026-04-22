@echo off
echo Building Tailwind CSS...
tailwindcss-windows-x64.exe -i input.css -o src/main/resources/static/css/output.css --minify
echo Done! output.css generated.
pause
