resource "aws_instance" "Win-EC2" {
  ami             = "ami-05b0cd1af6c0c34e3"
  instance_type   = "t2.micro"
  key_name        = "skeypair"
  
  user_data = <<-EOF
              <powershell>
              # Update system packages
              Get-PackageProvider -Name NuGet -ForceBootstrap
              Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
              Install-Module PSWindowsUpdate -Force
              Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot

              </powershell>
              EOF

  tags = {
    Name        = "Windows-Inst"
    description = "Managed by Terraform"
  }
}
