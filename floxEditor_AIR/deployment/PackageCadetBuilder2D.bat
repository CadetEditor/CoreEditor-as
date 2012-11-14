@echo off

:: AIR application packaging
:: More information:
:: http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959

:: Path to Flex SDK binaries
set PATH=%PATH%;C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.5\sdks\4.6\bin


set APP_XML=cadetBuilder2D-app.xml 
set FILE_OR_DIR=-C ..\..\Deploy_AIR_2D .

set SOURCE_CONFIG_PATH="..\..\Deploy_AIR_2D\cadetBuilder2DConfig.xml"
set TARGET_CONFIG_PATH="..\..\Deploy_AIR_2D\config.xml"

set CERTIFICATE="Certificate.pfx"
set AIR_FILE=Cadet2D.air



if not exist %CERTIFICATE% goto certificate
set SIGNING_OPTIONS=-storetype pkcs12 -keystore %CERTIFICATE% -tsa none 



echo Signing AIR setup using certificate %CERTIFICATE%.

copy %SOURCE_CONFIG_PATH% %TARGET_CONFIG_PATH%
call adt -package %SIGNING_OPTIONS% %AIR_FILE% %APP_XML% %FILE_OR_DIR%

if errorlevel 1 goto failed





echo.
echo AIR setup created: %AIR_FILE%
echo.
goto end

:certificate
echo Certificate not found: %CERTIFICATE%
echo.
echo Troubleshotting: 
echo A certificate is required, generate one using 'CreateCertificate.bat'
echo.
goto end

:failed
echo AIR setup creation FAILED.
echo.
echo Troubleshotting: 
echo did you configure the Flex SDK path in this Batch file?
echo.

:end
pause
