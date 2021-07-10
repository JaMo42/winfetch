# https://github.com/JaMo42/winfetch

# Settings
# Text colors
$normalcolor = "Gray"
$usercolor = "Blue"
$labelcolor = "Blue"
$infocolor = "Gray"
# Logo colors
$red = "Red"
$green = "Green"
$blue = "Blue"
$yellow = "Yellow"

function get-uptime {
  # Subtract time of last boot from current time
  $uptime = (
    (Get-CimInstance -ClassName Win32_OperatingSystem).LocalDateTime - 
    (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
  );
  # Format
  $formatted = ""
  if ($uptime.Days -ne 0) {
    $formatted += $uptime.Days.ToString() + "d ";
  }
  if ($uptime.Hours -ne 0) {
    $formatted += $uptime.Hours.ToString() + "h ";
  }
  $formatted += $uptime.Minutes.ToString() + "m";
  return $formatted;
}

function get-packages {
  # If choco exists, get the number of packages
  if (Get-Command choco -ErrorAction SilentlyContinue) {
    return "$($(choco list --local-only -r).Count) (choco)";
  } elseif (Get-Command winget -ErrorAction SilentlyContinue) {
    return "$($(winget list).Count - 3) (winget)";
  } else {
    # Otherwise return default
    return "N/A";
  }
}

[string]$user = $env:UserName;
[string]$hostname = $env:ComputerName;
[string]$os = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption + " " +
              (Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture
[string]$kernel = (Get-CimInstance -ClassName  Win32_OperatingSystem).Version;
[string]$uptime = get-uptime;
[string]$packages = get-packages;
[string]$shell = "Powershell $($PSVersionTable.PSVersion.ToString())";

# Output:
#       _.-;;-._    user@host
#'-..-'|   ||   |   OS: ...
#'-..-'|_.-;;-._|   Kernel: ...
#'-..-'|   ||   |   Uptime: ...
#'-..-'|_.-''-._|   Packages: ... (choco)
#                   Shell: Powershell ...
[string[][]]$text =
  ("        _.-;", ";-._    ",         $user, "@", $hostname),
  (" '-..-'|   |", "|   |   ",         "OS:       ", $os),
  (" '-..-'|_.-", ",", ",", "-._|   ", "Kernel:   ", $kernel),
  (" '-..-'|   |", "|   |   ",         "Uptime:   ", $uptime),
  (" '-..-'|_.-'", "'-._|   ",         "Packages: ", $packages),
  ("                    ",             "Shell:    ", $shell);
[string[][]]$colors =
  ($red, $green,                 $usercolor, $normalcolor, $usercolor),
  ($red, $green,                 $labelcolor, $infocolor),
  ($red, $blue, $yellow, $green, $labelcolor, $infocolor),
  ($blue, $yellow,               $labelcolor, $infocolor),
  ($blue, $yellow,               $labelcolor, $infocolor),
  ($normalcolor,                 $labelcolor, $infocolor);

Write-Host;
for ($line=0; $line -lt $text.Count; $line++) {
  for ($element=0; $element -lt $text[$line].Count; $element++) {
    Write-Host $text[$line][$element] -ForegroundColor $colors[$line][$element] -NoNewline;
  }
  Write-Host;
}
Write-Host;
