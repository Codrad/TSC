::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

vsim -%1 -do "do run.do 15 3 7777 RandInc-15"
cd ../tools
::make multiple run_test.bat with dfferent cases. Use -c(terminal). Add more variables to 