# NetApp-PowerShell

A PowerShell module for managing and automating NetApp operations.

## Overview

NetApp-PowerShell is a collection of PowerShell scripts and cmdlets aimed at simplifying NetApp storage management. This module provides automation for common tasks such as provisioning, monitoring, backup, and reporting via PowerShell, making it easier for administrators and DevOps professionals to interact with NetApp storage systems.

## Features

- Connect to NetApp storage controllers
- Perform common storage tasks like creating/deleting volumes, snapshots, and aggregates
- Query NetApp system health and performance metrics
- Automate backup operations
- Generate reports
- Integration with CI/CD workflows

## Getting Started

### Prerequisites

- PowerShell 5.1 or later (Windows, Linux, or macOS)
- Access to NetApp API (ONTAP)

### Installation

You can clone this repository and import the module manually:

```powershell
git clone https://github.com/mbtechgru/NetApp-PowerShell.git
Import-Module ./NetApp-PowerShell/NetAppPowerShell.psm1
```

### Usage

1. **Connect to NetApp system:**

    ```powershell
    Connect-NetAppController -Address <controller-address> -Username <username> -Password <password>
    ```

2. **List volumes:**

    ```powershell
    Get-NetAppVolume
    ```

3. **Create a volume:**

    ```powershell
    New-NetAppVolume -Name "TestVolume" -Size "100GB"
    ```

For detailed cmdlet documentation, see the module help or usage examples in the `docs/` folder (if available).

## Contributing

Contributions and feature requests are welcome! Please fork the repository and submit a pull request or open an issue for suggestions and bugs.

## License

Distributed under the MIT License. See `LICENSE` for details.

## Author

Maintained by [mbtechgru](https://github.com/mbtechgru)
