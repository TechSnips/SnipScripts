# PowerShell 5 and 6 (Core)
enum fruit {
    apple = 1
    banana = 2
}

# Creating an enum before PowerShell 5
Add-Type -TypeDefinition @"
public enum moreFruit {
    apple = 1,
    banana = 2
}
"@

# https://docs.microsoft.com/en-us/windows/desktop/cimwin32prov/win32-systemenclosure

# Building the parameters
$params = @{
    classname = 'win32_SystemEnclosure'
    NameSpace = 'root\cimv2'
    property  = 'ChassisTypes'
}
# return
Get-CimInstance @params | Select-Object -ExpandProperty ChassisTypes

# creating our enumerator
enum Chassis {
    Other = 1
    Unknown = 2
    Desktop = 3
    LowProfileDesktop = 4
    PizzaBox = 5
    MiniTower = 6
    Tower = 7
    Portable = 8
    Laptop = 9
    Notebook = 10
    HandHeld = 11
    DockingStation = 12
    AllinOne = 13
    SubNotebook = 14
    SpaceSaving = 15
    LunchBox = 16
    MainSystemChassis = 17
    ExpansionChassis = 18
    SubChassis = 19
    BusExpansionChassis = 20
    PeripheralChassis = 21
    StorageChassis = 22
    RackMountChassis = 23
    SealedCasePC = 24
}

# using the enumerator to find the model type
[chassis](Get-CimInstance @params | Select-Object -ExpandProperty ChassisTypes)