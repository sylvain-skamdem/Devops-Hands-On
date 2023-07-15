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

!<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/image0.png?raw=true">

## Step 2: Create a SNS topic
1. Sign in to the Amazon SNS console https://console.aws.amazon.com/sns/home.

2. On the navigation panel, choose **Topics**.

3. On the Topics page, choose **Create topic**.

4. On the Create topic page, in the Details section, do the following:

    a. For **Type**, choose a topic type (**Standard** or **FIFO**).

    b. Enter a **Name** for the topic. For a FIFO topic, add .fifo to the end of the name.

    c. (Optional) Enter a **Display name** for the topic.

        Important
        When subscribing to an email endpoint, the combined character count for the Amazon SNS topic display name and the sending email address (for example, no-reply@sns.amazonaws.com) must not exceed 320 UTF-8 characters. You can use a third party encoding tool to verify the length of the sending address before configuring a display name for your Amazon SNS topic.

    d. (Optional) For a FIFO topic, you can choose content-based message deduplication to enable default message deduplication. For more information, see Message deduplication for FIFO topics.

    e. (Optional) Expand the Encryption section and do the following. For more information, see Encryption at rest https://docs.aws.amazon.com/sns/latest/dg/sns-server-side-encryption.html.

    - Choose **Enable encryption**.

    - Specify the AWS KMS key. For more information, see Key terms.

        For each KMS type, the Description, Account, and KMS ARN are displayed.

        The AWS managed KMS for Amazon SNS (Default) alias/aws/sns is selected by default.

        To use a custom KMS from your AWS account, choose the KMS key field and then choose the custom KMS from the list.

        To use a custom KMS ARN from your AWS account or from another AWS account, enter it into the KMS key field.

    f. (Optional) *By default, only the topic owner can publish or subscribe to the topic*. To configure additional access permissions, expand the Access policy section. For more information, see Identity and access management in Amazon SNS and Example cases for Amazon SNS access control.

    g. (Optional) To configure how Amazon SNS retries failed message delivery attempts, expand the Delivery retry policy (HTTP/S) section. For more information, see Amazon SNS message delivery retries.

    h. (Optional) To configure how Amazon SNS logs the delivery of messages to CloudWatch, expand the Delivery status logging section. For more information, see Amazon SNS message delivery status.

    i. (Optional) To add metadata tags to the topic, expand the Tags section, enter a Key and a Value (optional) and choose Add tag. For more information, see Amazon SNS topic tagging.

    j. Choose **Create topic**.

    k. Copy the **topic ARN** to the clipboard, for example:

*arn:aws:sns:us-east-2:123456789012:MyTopic*

<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/image2.png?raw=true">

## Step 3: Subscribe to the topic
For this exercise, use email as the communications protocol. 
1. Sign in to the Amazon SNS console https://console.aws.amazon.com/sns/home.

2. In the left navigation pane, choose **Subscriptions**.

3. On the Subscriptions page, choose **Create subscription**.

4. On the Create subscription page, in the Details section, do the following:

    a. For **Topic ARN**, choose the Amazon Resource Name (ARN) of a topic.

    b. For **Protocol**, choose an endpoint type. In this case, we choosed *Email*.

    c. For **Endpoint**, enter the endpoint value. Here we entered our email address that will get the notification *sylvain.skamdem@gmail.com.* Keep the other options as default.

    d. Choose **Create subscription**.


!<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/image5.png?raw=true">

5. Check your provided mailbox (inbox and spam folders) for a **subscription confirmation** email and click the link to confirm your subscription. Once you click the subscription link, you get this message:

!<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/image7.png?raw=true">


## Step 4: Update the access policy of the topic

Replace the access policy attached to the topic with the following policy. In it, provide your *SNS topic ARN, bucket name, and bucket owner's account ID*.

    ```json
    {
        "Version": "2012-10-17",
        "Id": "example-ID",
        "Statement": [
            {
                "Sid": "Example SNS topic policy",
                "Effect": "Allow",
                "Principal": {
                    "Service": "s3.amazonaws.com"
                },
                "Action": [
                    "SNS:Publish",
                ],
                "Resource": "SNS-topic-ARN",
                "Condition": {
                    "ArnLike": {
                        "aws:SourceArn": "arn:aws:s3:*:*:bucket-name"
                    },
                    "StringEquals": {
                        "aws:SourceAccount": "bucket-owner-account-id"
                    }
                }
            }
        ]
    }                
    ```

## Step 5: Add a notification configuration to your S3 bucket

1. In the created bucket, click the **Properties** tab
2. Scroll down and click **Create event notification** to be notified when a specific event occurs.

    a. Set the **event name**: In this case *New-csv-file-put*.

    b. Optionally set the **Prefix**: This is to Limit the notifications to objects with key starting with specified characters.

    c. Optionally set the **Suffix**: Limit the notifications to objects with key ending with specified characters. So in this case we set the suffix to *.csv*.

    d. Select the **Event types**: Specify at least one event for which you want to receive notifications. For each group, you can choose an event type for all events, or you can choose one or more individual events. In this case, we want to upload an object so we choose **Put**.

    e. Select the **Destination**: Choose **SNS topic** in this case.

    f. Specify the SNS topic: Since we've already created our SNS topic, we'll select Choose from your SNS topics, then select the appropriate SNS topic
3. Click on **Save changes**.

## Step 6: Test the setup
1. Upload a csv file into the S3 bucket
!<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/image6.png?raw=true">

2. As soon as you upload the csv file, you receive the notification in your Google mailbox:

!<img src="https://github.com/sylvainksimo/Devops-Hands-On/blob/main/My%20AWS%20JOBS/INTEGRATING%20AWS%20SNS%20WITH%20AWS%20S3%20EVENTS/Images/image8.png?raw=true">