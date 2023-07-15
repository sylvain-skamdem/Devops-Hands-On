# Use Case:
We want to get a SNS notification to our gmail mailbox everytime a csv file is uploaded into our S3 bucket.

<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/INT%20SNS%20AND%20S3.jpg?raw=true">




## Step 1: Create the S3 bucket
1. Log in to the *AWS Management Console*: Go to the AWS Management Console website (https://console.aws.amazon.com/) and sign in using your AWS account credentials.

2. Navigate to the **S3 Service**: Once you are logged in, search for "**S3**" in the AWS services search bar or find it under the "**Storage**" category in the console dashboard. Click on "**S3**" to access the S3 service.

3. Click on "**Create Bucket**"

4. Provide *Bucket Name*: Enter a unique name for your bucket. Bucket names must be globally unique across all AWS accounts, so if your desired name is already taken, you'll need to choose a different name. You can also choose the AWS region where you want your bucket to be located.

5. Configure *Bucket Properties*: You have the option to configure various settings for your bucket, such as enabling **versioning**, **logging**, **encryption**, and **access control**. You can choose the desired configurations based on your requirements or leave them as default.

6. Set **Permissions**: In the "*Set Permissions*" step, you can define access permissions for your bucket. You can choose to grant *public access*, *restrict access to specific AWS accounts or IAM users*, or *configure more advanced access policies*.

7. *Review* and **Create**: Review the bucket configuration details on the "Review" page. Ensure that all settings are as desired. If everything looks good, click on the "**Create bucket**" button to create the S3 bucket.

![Alt text](image.png)

## Step 2: Create a SNS topic
1. Log in to the *AWS Management Console*: Go to the AWS Management Console website (https://console.aws.amazon.com/) and sign in using your AWS account credentials.

2. Navigate to the **SNS Service**: Once you are logged in, search for "SNS" in the AWS services search bar or find it under the "Application Integration" category in the console dashboard. Click on "**SNS**" to access the SNS service.

3. Create a new topic: In the SNS dashboard, click on **Topics** from left pane, then on the "**Create topic**" button to start the topic creation process.

4. Provide Topic Details: In the "Create topic" page, you need to provide the details for your new SNS topic:

    a. Select the topic **Type**: In my case I choose **Standard**.
    
    b. **Topic name**: Enter a name for your topic. This name should be unique within your AWS account. In this case we enter *uct-s3-sns-topic*
    
    c. **Display name** (optional): You can optionally enter a display name for your topic to provide more descriptive information.

    d. **Access policy** (optional): If you want to restrict or grant specific permissions to access the topic, you can specify an access policy using the JSON syntax. For now, just the topic owner can publish messages to the topic, so we'll change the publishers to everyone by checking "**Basic**" then changing **Publishers** and **Subscribers** to **Everyone**.

    e. Create the topic: Once you have provided the necessary details, click on the "**Create topic**" button to create the SNS topic.
!<img src="">


## Step 3: Configure the events notifications for the S3 bucket

1. In the newly created bucket, click the **Properties** tab
2. Scroll down and click **Create event notification** to be notified when a specific event occurs.

    a. Set the **event name**: In this case *New-csv-file-put*.

    b. Optionally set the **Prefix**: This is to Limit the notifications to objects with key starting with specified characters.

    c. Optionally set the **Suffix**: Limit the notifications to objects with key ending with specified characters. So in this case we set the suffix to *.csv*.

    d. Select the **Event types**: Specify at least one event for which you want to receive notifications. For each group, you can choose an event type for all events, or you can choose one or more individual events. In this case, we want to upload an object so we choose **Put**.

    e. Select the **Destination**: Choose **SNS topic** in this case.

    f. Specify the SNS topic: Since we've already created our SNS topic, we'll select Choose from your SNS topics, then select the appropriate SNS topic


