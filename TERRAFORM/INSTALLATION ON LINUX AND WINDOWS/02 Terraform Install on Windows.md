# Steps to install terraform on a windows pc using Chocolatey

## Step A 
* Open a web browser and navigate to the Chocolatey website (https://chocolatey.org/).

* On the Chocolatey website, locate the installation command for Chocolatey, which should be displayed prominently on the homepage. It typically looks like this:

    ```sh
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ```
    
    Copy this command to your clipboard.

* Open the Command Prompt as an administrator. You can do this by pressing the **Windows key**, typing "**cmd**," right-clicking on "**Command Prompt**," and selecting "**Run as administrator**."

* In the Command Prompt, right-click on the title bar, and select "**Paste**" to paste the Chocolatey installation command you copied earlier. Press Enter to execute the command.

* Wait for Chocolatey to install. This may take a few moments as Chocolatey sets up the necessary components.

* Once Chocolatey is installed, you can verify it by running the following command in the Command Prompt:

    ```
    choco -v
    ```
    This command will display the version of Chocolatey installed.

## Step B
With Chocolatey installed, you can now install Terraform. In the Command Prompt, enter the following command:

```sh
choco install terraform
```
Press *Enter* to execute the command.

Chocolatey will download and install the latest version of Terraform automatically. The installation process may take some time, depending on your internet connection and system performance.

After the installation is complete, you can verify that Terraform is installed by running the following command:

```sh
terraform version
```
If Terraform is successfully installed, you should see the version information displayed in the Command Prompt.
