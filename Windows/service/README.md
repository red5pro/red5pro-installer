# Red5 Windows Service



## INTRODUCTION
---

This project artifact is about windows service for Red5 / Red5pro developed / designed in visual studio 2015. Thsi can be used to register Red5pro as a standard service in windows.

The service can then be configured and started / stopped using toosl built into windows. The program is developed in Windows 10 Pro, but can run on any modern windows desktop / server running Microsoft Dot Net.


## REQUIREMENTS
---

The first requirement the Red5 service is that your `RED5_HOME` must be set and should point to your Red5 home folder where your red5.bat and red5-shutdown.bat are located.

__SCREENSHOT__

![RED5 HOME VARIABLE](images/red5_home_windows.png?raw=true "Red5 Home Environment Variable")


The second vital requirement for installing this service on windows is the `installutil.exe` utility which is provided with Microsoft.Net runtime. 


[ FROM [MICROSOFT WEBSITE](https://msdn.microsoft.com/en-us/library/sd8zc8ha(v=vs.110).aspx) ]

`If you’re using the Visual Studio command prompt, InstallUtil.exe should be on the system path. If not, you can add it to the path, or use the fully qualified path to invoke it. This tool is installed with the .NET Framework, and its path is %WINDIR%\Microsoft.NET\Framework[64]\<framework_version>. For example, for the 32-bit version of the .NET Framework 4 or 4.5.*, if your Windows installation directory is C:\Windows, the path is C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe. For the 64-bit version of the .NET Framework 4 or 4.5.*, the default path is C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe.`


Most windows systems that Red5pro is designed to run on already have some version of Dot Net installed. If a particular system does not have Dot net or has a version older than `3.5`, You can always install version `4.5` or newer the latest runtiem from its [official page](https://www.microsoft.com/en-in/download/details.aspx?id=42642)

__For more information please visit the following links:__

* https://msdn.microsoft.com/en-us/library/8z6watww(v=vs.110).aspx
* https://blogs.msdn.microsoft.com/astebner/2007/03/14/mailbag-what-version-of-the-net-framework-is-included-in-what-version-of-the-os/


## USAGE
---

__LOCATE InstallUtil.exe__

* Browse to your Dotnet runtime folder :
32 BIT : C:\Windows\Microsoft.NET\Framework
64 BIT : C:\Windows\Microsoft.NET\Framework64

* Browse into your appropriate Dotnet version folder
>> ex: C:\Windows\Microsoft.NET\Framework64\v4.0.30319

__This is where the InstallUtil.exe utility is located. Note this path.__

---

* Open a command prompt shell on windows with administrative rights. ( Right click -> Run as Administrator )

* Navigate to the location of our service - `Red5Service.exe`, in commandline

---

__INSTALL SERVICE:__


`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\installutil Red5Service.exe`

[ Where installutil is sourced from the DotNet runtime folder ]


__SCREENSHOT(s)__

![Service Install](images/install_service.png?raw=true "Service Install")


__Once service is installed you can see it in the windows services list from `Computer Management -> Services`__


![Services](images/services_view.png?raw=true "Services")



---

__UNINSTALL SERVICE:__

`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\installutil /U Red5Service.exe`

[ Where installutil is sourced from the DotNet runtime folder ]


__SCREENSHOT__

![Service UnInstall](images/uninstall_service.png?raw=true "Service UnInstall")

---

__START SERVICE:__

`net start "Red5"`

---

__STOP SERVICE:__

`net stop "Red5"`

---


__CONFIGURE SERVICE AUTOSTART:__

`sc config "Red5" start=auto`

For more info visit: https://technet.microsoft.com/en-us/library/cc990290(v=ws.11).aspx


---



__CONFIGURE SERVICE MANUAL:__

`sc config "Red5" start=demand`

For more info visit: https://technet.microsoft.com/en-us/library/cc990290(v=ws.11).aspx
