@echo off
echo Running the Project Build with Maven
call mvn clean verify
if %errorLevel% == 0 (
    echo maven build successful bringing up the environment
    vagrant up
) else (
    echo build failed, please check the logs
)



