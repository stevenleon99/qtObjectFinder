#ifndef WINDOWSPROCESSES_H
#define WINDOWSPROCESSES_H

#include <QString>

class WindowsProcesses
{
public:
    WindowsProcesses();

    static bool launchAppIntoDifferentSession(const QString &program, const QString &arguments, const QString &workingDir, qint64 *pid, bool consoleUser);
    static qint64 findProcessId(const QString &processName);

    static bool stopProcess(qint64 pid);

    static void printLastError( const QString &msg );
};

#endif // WINDOWSPROCESSES_H
