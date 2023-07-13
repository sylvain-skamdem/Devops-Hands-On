# How to install Terraform on Ubuntu 22.04

## Step 1:

Ensure that your system is up to date and you have installed the gnupg, software-properties-common, and curl packages installed. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

## Step 2: Install the HashiCorp GPG key
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

## Step 3: Verify the key's fingerprint.
```bash
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

        The gpg command will report the key fingerprint:
        /usr/share/keyrings/hashicorp-archive-keyring.gpg
        -------------------------------------------------
        pub   rsa4096 XXXX-XX-XX [SC]
        AAAA AAAA AAAA AAAA
        uid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
        sub   rsa4096 XXXX-XX-XX [E]


## Step 4: Add the official HashiCorp repository to your system 

The lsb_release -cs command finds the distribution release codename for your current system, such as buster, groovy, or sid.
```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```


## Step 5: Download the package information from HashiCorp
```bash
sudo apt update
```


## Step 6: Install Terraform from the new repository.
```bash
sudo apt-get install terraform
```

```
Tip
Now that you have added the HashiCorp repository, you can install Vault, Consul, Nomad and Packer with the same command.
```

Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands.

```hcl
terraform -help
```

Add any subcommand to terraform -help to learn more about what it does and available options.
```hcl
terraform -help plan
```


```
*Troubleshoot*
If you get an error that terraform could not be found, your PATH environment variable was not set up properly. Please go back and ensure that your PATH variable contains the directory where Terraform was installed.
```

## Step 7: Enable tab completion
If you use either *Bash* or Zsh, you can enable tab completion for Terraform commands. To enable autocomplete, first ensure that a config file exists for your chosen shell.
```bash
touch ~/.bashrc
```
Then install the autocomplete package.
```hcl
terraform -install-autocomplete
```
Once the autocomplete support is installed, you will need to restart your shell.



