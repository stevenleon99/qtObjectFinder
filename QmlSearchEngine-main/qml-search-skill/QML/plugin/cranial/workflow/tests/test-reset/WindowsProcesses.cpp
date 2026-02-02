/**
 * @class WindowsProcesses
 * @ingroup watchdogService
 * @brief Manage windows process IDs for product executables
 */

#include "WindowsProcesses.h"
#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <QDebug>
#include <Wtsapi32.h>
#include <Userenv.h>

WindowsProcesses::WindowsProcesses()
{

}

qint64 WindowsProcesses::findProcessId(const QString &processName)
{
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;
    hProcessSnap = CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 );
    if( hProcessSnap == INVALID_HANDLE_VALUE )
    {
        printLastError("CreateToolhelp32Snapshot (of processes)");
        return( -1 );
    }

    // Set the size of the structure before using it.
    pe32.dwSize = sizeof( PROCESSENTRY32 );

    // Retrieve information about the first process,
    // and exit if unsuccessful
    if( !Process32First( hProcessSnap, &pe32 ) )
    {
        printLastError( "Process32First" ); // show cause of failure
        CloseHandle( hProcessSnap );          // clean the snapshot object
        return( -1 );
    }

    do
    {
        if(processName == QString::fromWCharArray(pe32.szExeFile))
        {
            CloseHandle( hProcessSnap );          // clean the snapshot object
            return pe32.th32ProcessID;
        }

    } while( Process32Next( hProcessSnap, &pe32 ));

    CloseHandle( hProcessSnap );          // clean the snapshot object
    return -1;
}

bool WindowsProcesses::launchAppIntoDifferentSession(const QString &program, const QString &arguments, const QString &workingDir, qint64 *pid, bool consoleUser)
{
    HANDLE hUserTokenDup = NULL;

    if(consoleUser)
    {
        WTSQueryUserToken (WTSGetActiveConsoleSessionId (), &hUserTokenDup) ;
    }
    else
    {

        // Changeing winLogon to services as in commented out line allows
        // apps to run in session 0 and continue without restarting when
        // the user logs out.  However there was an issue with Fovia so
        // this line should be commented until the switch to IMFusion is made.
        //DWORD winlogonPid = WindowsProcesses::findProcessId("services.exe");
        DWORD winlogonPid = WindowsProcesses::findProcessId("winlogon.exe");
        HANDLE hProcess = OpenProcess(MAXIMUM_ALLOWED,FALSE,winlogonPid);
        if(hProcess)
        {
            DWORD dwSessionId = WTSGetActiveConsoleSessionId();
            TOKEN_PRIVILEGES tp;
            LUID luid;
            HANDLE hPToken;

            if(!::OpenProcessToken(hProcess,TOKEN_ADJUST_PRIVILEGES|TOKEN_QUERY
                                   |TOKEN_DUPLICATE|TOKEN_ASSIGN_PRIMARY|TOKEN_ADJUST_SESSIONID
                                   |TOKEN_READ|TOKEN_WRITE,&hPToken))
            {
                printLastError("Process token open Error");
            }

            if (!LookupPrivilegeValue(NULL,SE_DEBUG_NAME,&luid))
            {
                printf("Lookup Privilege value Error: %u\n",GetLastError());
            }
            tp.PrivilegeCount =1;
            tp.Privileges[0].Luid =luid;
            tp.Privileges[0].Attributes =SE_PRIVILEGE_ENABLED;

            if(!DuplicateTokenEx(hPToken,MAXIMUM_ALLOWED,NULL,
                                 SecurityIdentification,TokenPrimary,&hUserTokenDup))
            {
                printLastError("DuplicateTokenEx");
            }

            //Adjust Token privilege
            SetTokenInformation(hUserTokenDup, TokenSessionId,(void*)dwSessionId,sizeof(DWORD));

            if (!AdjustTokenPrivileges(hUserTokenDup,FALSE,&tp,sizeof(TOKEN_PRIVILEGES),
                                       (PTOKEN_PRIVILEGES)NULL,NULL))
            {
                printLastError("Adjust Privilege value Error");
            }

            CloseHandle(hProcess);
            CloseHandle(hPToken);
        }
        else
        {
            printLastError("OpenProcess");
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    QString commandLine = program;
    commandLine.replace('/', '\\');
    if(!arguments.isEmpty()) {
        commandLine += QString(' ') + arguments;
    }

    PROCESS_INFORMATION pinfo;

    STARTUPINFO startupInfo;
    ZeroMemory(&startupInfo, sizeof(STARTUPINFO));
    startupInfo.cb= sizeof(STARTUPINFO);

    bool success = CreateProcessAsUser(hUserTokenDup, // client's access token
                                  0, // file to execute
                                  (wchar_t*)commandLine.utf16(), // command line
                                  0, // pointer to process SECURITY_ATTRIBUTES
                                  0, // pointer to thread SECURITY_ATTRIBUTES
                                  FALSE, // handles are not inheritable
                                  CREATE_UNICODE_ENVIRONMENT | CREATE_NO_WINDOW, // creation flags
                                  0, // pointer to new environment block
                                  workingDir.isEmpty() ? 0 : (wchar_t*)workingDir.utf16(), // name of current directory
                                  &startupInfo, // pointer to STARTUPINFO structure
                                  &pinfo // receives information about new process
                                  );

    if (success) {
        CloseHandle(pinfo.hThread);
        CloseHandle(pinfo.hProcess);
        if (pid)
            *pid = pinfo.dwProcessId;
    }
    else
    {
        printLastError("CreateProcessAsUser");
    }

    //Perform All the Close Handles tasks

    CloseHandle(hUserTokenDup);

    return success;
}

void WindowsProcesses::printLastError( const QString &msg )
{
    DWORD eNum;
    TCHAR sysMsg[256];
    TCHAR* p;

    eNum = GetLastError( );
    FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                   NULL, eNum,
                   MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
                   sysMsg, 256, NULL );

    // Trim the end of the line and terminate it with a null
    p = sysMsg;
    while( ( *p > 31 ) || ( *p == 9 ) )
        ++p;
    do { *p-- = 0; } while( ( p >= sysMsg ) &&
                            ( ( *p == '.' ) || ( *p < 33 ) ) );

    // Display the message
    qDebug() << "WARNING: " << msg.toStdString().c_str() << "[ failed with error: " << eNum << "(" << QString::fromWCharArray(sysMsg).toStdString().c_str() << ")]";
}

bool WindowsProcesses::stopProcess(qint64 pid)
{
    HANDLE pHandle = OpenProcess(PROCESS_TERMINATE,false,pid);

    if(pHandle)
    {
        if(!TerminateProcess(pHandle,1))
        {
            printLastError("Failed to terminate pid:");
            CloseHandle(pHandle);
            return false;
        }

        CloseHandle(pHandle);
    }
    else
    {
        printLastError("Failed to open for termination pid:");
        return false;
    }

    return true;
}

