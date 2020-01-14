# winfetch

Tiny system info for windows.

Powershell script that mimics [ufetch](https://gitlab.com/jschx/ufetch).

## Output

```

        _.-;;-._    USER@HOST
 '-..-'|   ||   |   OS:       Microsoft Windows 10 Home 64-bit
 '-..-'|_.-,,-._|   Kernel:   10.0.19035
 '-..-'|   ||   |   Uptime:   5h 39m
 '-..-'|_.-''-._|   Packages: 50 (choco)
                    Shell:    Powershell 5.1.19035.1

```

If [chocolatey](https://chocolatey.org/) is not installed, the package count will display `N/A`.
