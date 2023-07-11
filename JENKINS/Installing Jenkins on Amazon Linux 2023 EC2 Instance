# Installing Jenkins on AWS instance

In this tutorial, you will perform the following steps:

* Prerequisites
* Create a key pair using Amazon EC2. If you already have one, you can skip to step 3.
* Create a security group for your Amazon EC2 instance. If you already have one, you can skip to step 4.
* Launch an Amazon EC2 instance.
* Install and configure Jenkins.
* Clean up tutorial resources.

## Prerequisites
1. An AWS account. If you don’t have one, you can register here.
2. An Amazon EC2 key pair. If you don’t have one, refer to Creating a key pair.
3. An AWS IAM User with programmatic key access and permissions to launch EC2 instances

## Creating a key pair
Creating a key pair helps ensure that the correct form of authentication is used when you install Jenkins.

To create your key pair:

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/ and sign in.

2. In the navigation pane, under __NETWORK & SECURITY__, select __Key Pairs__.

3. Select Create __key pair__.

4. For __Name__, enter a descriptive name for the key pair. Amazon EC2 associates the public key with the name that you specify as the __key name__. A key name can include up to 255 ASCII characters. It cannot include leading or trailing spaces.

5. For __File format__, select the format in which to save the private key.

    - For OpenSSH compatibility, select **pem**.

    - For PuTTY compatibility, select **ppk**.

6. Select **Create key pair**.

7. The private key file downloads automatically. The base file name is the name you specified as the name of your key pair, and the file name extension is determined by the file format you chose. Save the private key file in a safe place.

        This is the only chance for you to save the private key file.


8. If you use an SSH client on a macOS or Linux computer to connect to your Linux instance, run the following command to set the permissions of your private key file so that only you can read it.

 ```bash
chmod 400 <key_pair_name>.pem
 ```


        If you do not set these permissions, you cannot connect to your instance using this key pair. For more information, refer to Error: Unprotected private key file.


## Creating a security group
A security group acts as a firewall that controls the traffic allowed to reach one or more EC2 instances. When you launch an instance, you can assign it one or more security groups. You add rules that control the traffic allowed to reach the instances in each security group. You can modify a security group’s rules any time, and the new rules take effect immediately.

For this tutorial, you will create a security group and add the following rules:

- Allow inbound HTTP access from anywhere.
- Allow inbound SSH traffic from your computer’s public IP address so you can connect to your instance.

To create and configure your security group:

1. Decide who may access your instance. For example, a single computer or all trusted computers on a network. For this tutorial, you can use the public IP address of your computer.

   * To find your IP address, use the check IP service tool from AWS3 or search for the phrase "what is my IP address" in any search engine.

   * If you connect through an ISP or from behind your firewall without a static IP address, you will need the range of IP addresses used by client computers. If you don’t know this address range, you can use 0.0.0.0/0 for this tutorial.


            This is unsafe for production environments because it allows everyone to access your instance using SSH.


2. Sign in to the AWS Management Console.

3. Open the Amazon EC2 console by selecting **EC2** under **Compute**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_service.png">


4. In the left-hand navigation bar, select **Security Groups**, and then select **Create Security Group**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/create_security_group.png">

5. In **Security group name**, enter the preferred name of your choice, and provide a description.

6. Select your VPC from the list. You can use the default VPC.

7. On the **Inbound tab**, add the rules as follows:

    a. Select **Add Rule**, and then select **SSH** from the Type list.

    b. Under **Source**, select **Custom**, and in the text box, enter the IP address from step 1, followed by /32 indicating a single IP Address. *For example, 104.34.241.123/32 is a single IP address, while 198.51.100.2/24 results in a range of 256 IP addresses*.

    c. Select **Add Rule**, and then select **HTTP** from the Type list.

    d. Select **Add Rule**, and then select **Custom TCP** Rule from the Type list.

    e. Under **Port Range**, enter **8080**.

8. Select **Create**.

## Launching an Amazon EC2 instance
Now that you have configured a key pair and security group, you can launch an EC2 instance.

To launch an EC2 instance:
1. Sign in to the the AWS Management Console.
2. Open the Amazon EC2 console by selecting EC2 under **Compute**.
3. From the Amazon EC2 dashboard, select **Launch Instance**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_launch_instance.png">

4. The **Choose an Amazon Machine Image (AMI)** page displays a list of basic configurations called Amazon Machine Images (AMIs) that serve as templates for your instance. Select the HVM edition of the **Amazon Linux AMI**.

        This configuration is marked Free tier eligible.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_choose_ami.png">


5. Scroll down and select the key pair you created in the *creating a key pair* section above or any existing key pair you intend to use.
 * Select **Select an existing security group**.
 * Select the security group that you created.
 * Select **Launch Instance**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_review_instance_launch.png">

6. In the left-hand navigation bar, choose **Instances** to view the status of your instance. Initially, the status of your instance is pending. After the status changes to running, your instance is ready for use.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_view_created_instance.png">

## Installing and configuring Jenkins
Now that the Amazon EC2 instance has been launched, Jenkins can be installed properly.

In this step you will deploy Jenkins on your EC2 instance by completing the following tasks:
* Connecting to your Linux instance
* Downloading and installing Jenkins
* Configuring Jenkins

### Connecting to your Linux instance
After you launch your instance, you can connect to it and use it the same way as your local machine.

Before you connect to your instance, get the **public DNS** name of the instance using the Amazon EC2 console.

1. Select the instance and locate Public DNS.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_public_dns.png">

        If your instance doesn’t have a public DNS name, open the VPC console, select the VPC, and check the Summary tab. If either DNS resolution or DNS hostnames is **no**, select **Edit** and change the value to **yes**.


#### Prerequisites
The tool that you use to connect to your Linux instance depends on your operating system.
* If your computer runs Windows, you will connect using PuTTY.
* If your computer runs Linux or Mac OS X, you will connect using the SSH client.

These tools require the use of your key pair. Be sure that you have created your key pair as described in Creating a key pair.

#### Using PuTTY to connect to your instance
1. From the **Start** menu, select **All Programs > PuTTY > PuTTY**.
2. In the **Category** pane, select **Session**, and complete the following fields:
    a. In **Host Name**, enter *ec2-user@public_dns_name*.
    b. Ensure that **Port** is *22*.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ec2_putty.png">

3. In the **Category** pane, expand **Connection**, expand **SSH**, and then select **Auth**. Complete the following:
    a. Select **Browse**.
    b. Select the .ppk file that you generated for your key pair, as described in Creating a key pair and then select **Open**.

4. Select **Open** to start the PuTTY session.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/putty_select_key_pair.png">

#### Using SSH to connect to your instance
1. Use the ssh command to connect to the instance. You will specify the private key (.pem) file and ec2-user@public_dns_name.

```bash
ssh -i /path/my-key-pair.pem ec2-user@ec2-198-51-
100-1.compute-1.amazonaws.com
``` 
You will receive a response like the following:

```
The authenticity of host 'ec2-198-51-100-1.compute1.amazonaws.com (10.254.142.33)' cant be
established.

RSA key fingerprint is 1f:51:ae:28:bf:89:e9:d8:1f:25:5d:37:2d:7d:b8:ca:9f:f5:f1:6f.

Are you sure you want to continue connecting
(yes/no)?
```
2. Enter **yes**.

You will receive a response like the following:

```
Warning: Permanently added 'ec2-198-51-100-1.compute1.amazonaws.com' (RSA) to the list of known hosts.
```

### Downloading and installing Jenkins
Completing the previous steps enables you to download and install Jenkins on AWS. To download and install Jenkins:

1. Ensure that your software packages are up to date on your instance by using the following command to perform a quick software update:

```bash
sudo yum update –y
```
2. Add the Jenkins repo using the following command:

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
```
3. Import a key file from Jenkins-CI to enable installation from the package:

```bash
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```
```bash
sudo yum upgrade
```
4. Install Java (Amazon Linux 2):

```bash
sudo amazon-linux-extras install java-openjdk11 -y
```

5. Or Install Java (Amazon Linux 2023):

```bash
sudo dnf install java-11-amazon-corretto -y
```

6. Install Jenkins:

```bash
sudo yum install jenkins -y
```

7. Enable the Jenkins service to start at boot:

```bash
sudo systemctl enable jenkins
```

8. Start Jenkins as a service:

```bash
sudo systemctl start jenkins
```

You can check the status of the Jenkins service using the command:

```bash
sudo systemctl status jenkins
```

### Configuring Jenkins
Jenkins is now installed and running on your EC2 instance. To configure Jenkins:

1. Connect to http://<your_server_public_DNS>:8080 from your browser. You will be able to access Jenkins through its management interface:
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/unlock_jenkins.png">


2. As prompted, enter the password found in **/var/lib/jenkins/secrets/initialAdminPassword**.
    a. Use the following command to display this password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

3. The Jenkins installation script directs you to the **Customize Jenkins page**. Click **Install suggested plugins**.

4. Once the installation is complete, the **Create First Admin User** will open. Enter your information, and then select **Save and Continue**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/create_admin_user.png">

5. On the left-hand side, select **Manage Jenkins**, and then select **Manage Plugins**.

6. Select the **Available** tab, and then enter **Amazon EC2** plugin at the top right.

7. Select the checkbox next to **Amazon EC2** plugin, and then select **Install without restart**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/install_ec2_plugin.png">

8. Once the installation is done, select **Back to Dashboard**.

9. Select **Configure a cloud** if there are no existing nodes or clouds.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/configure_cloud.png">


10. If you already have other nodes or clouds set up, select **Manage Jenkins**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/manage-jenkins.png">


    a. After navigating to **Manage Jenkins**, select **Configure Nodes and Clouds** from the left hand side of the page.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/manage-nodes-and-clouds.png">

    b. From here, select **Clouds**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/manage-jenkins-configure-clouds.png">

11. Select **Add a new cloud**, and select **Amazon EC2**. A collection of new fields appears.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/add-amazon-cloud.png">


12. Click **Add** under Amazon EC2 Credentials
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/configure_cloud_add_ec2_credentials.png">

    a. From the Jenkins Credentials Provider, select AWS Credentials as the **Kind**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/jenkins_credentials_provider_aws_credentials.png">


b. Scroll down and enter in the IAM User programmatic access keys with permissions to launch EC2 instances and select **Add**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/add_access_secret_access_keys.png">

c. Scroll down to select your region using the drop-down, and select **Add** for the EC2 Key Pair’s Private Key.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/configure_cloud_region_private_key.png">


d. From the Jenkins Credentials Provider, select SSH Username with private key as the Kind and set the Username to *ec2-user*.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/ssh_username.png">


e. Scroll down and select **Enter Directly** under *Private Key*, then select **Add**.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/private_key_enter_directly.png">


f. Open the private key pair you created in the creating a key pair step and paste in the contents from "-----BEGIN RSA PRIVATE KEY-----" to "-----END RSA PRIVATE KEY-----". Select **Add** when completed.
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/enter_private_key.png">

g. Scroll down to "Test Connection" and ensure it states "Success". Select **Save** when done
<img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/test_connection.png">

You are now ready to use your EC2 instance as Jenkins agents.




From Jenkins official doc at https://www.jenkins.io