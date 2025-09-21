# The Cloud Fun Facts Generator does this: With a click of a button, it delivers random cloud facts, and behind the scenes, you’ll connect multiple AWS services to make it dynamic, scalable, and interactive.

# Steps To Be Performed 👩‍💻
We’ll go through the following stages:
1.	Deploy Backend with AWS Lambda + API Gateway
2.	Enhance with DynamoDB (store facts in a table)
3.	Integrate Amazon Bedrock (GenAI) to make facts witty
4.	Deploy Frontend with AWS Amplify (to display facts)

# Services Used 🛠

•	AWS Lambda: Serverless backend to generate cloud fun facts.  
•	Amazon API Gateway: Exposes Lambda as a REST API endpoint.  
•	Amazon DynamoDB: Database for storing facts.  
•	Amazon Bedrock: Generative AI to make facts witty.  
•	AWS Amplify: Hosting service for the React frontend.  
•	AWS IAM: Identity and Access Management for secure permissions.

# ➡️ Architectural Diagram
This is the high-level architecture:

<img width="975" height="527" alt="image" src="https://github.com/user-attachments/assets/49159aea-ed91-461c-8100-d9d1a04ef507" />

 

# ➡️ Final Result
This is what your project will look like once built:
<img width="975" height="941" alt="image" src="https://github.com/user-attachments/assets/2b3fc730-09e5-4a7f-9bb8-310dd8b5bf95" />





# PROCEDURE

## 1.2 Basic Version (Lambda + API Gateway)
In this first stage, you’ll build a serverless API that returns random cloud fun facts.
This will give us a strong foundation to later extend with databases (DynamoDB) and even AI (Bedrock/OpenAI).
### Step 1: Create a Lambda Function
1.	Go to AWS Management Console → Search for Lambda.
2.	Click Create function.
3.	Select Author from scratch.  
•	Function name: CloudFunFacts  
•	Runtime: Python 3.13  
•	Permissions: Create a new role with basic Lambda permissions.

👉 What’s happening here?  
•	Lambda is AWS’s serverless compute service — you don’t need to manage servers, scaling, or patching.  
•	By creating this function, you’re telling AWS: “Whenever this function is triggered, run my Python code and return the output.”  
•	The basic Lambda role gives it permission to write logs into CloudWatch so you can debug later.  
4. Click Create function.
 
<img width="975" height="606" alt="image" src="https://github.com/user-attachments/assets/a8ee41a1-8a3f-4a6f-b5cc-d8bb3a0dc2f3" />


### Step 2: Add Code
1.	Scroll to the Code source section and replace the default handler with this code:
```
import random
import json

def lambda_handler(event, context):
    facts = [
        "AWS S3 was launched in 2006 and still rules cloud storage.",
        "Cloud computing can save companies up to 30% on IT costs.",
        "EC2 was one of the first AWS services to change IT forever.",
        "AWS offers more than 200 services — that’s more than Starbucks drinks!",
        "Cloud lets you pay-as-you-go, just like your Netflix subscription.",
        "The name 'Amazon Web Services' was first used back in 2002.",
        "AWS data centers are so secure they require palm scanners.",
        "Netflix runs most of its infrastructure on AWS.",
        "Amazon DynamoDB can handle more than 10 trillion requests per day.",
        "AWS Lambda was launched in 2014 and started the serverless trend.",
        "Cloud reduces CO₂ emissions by optimizing energy usage.",
        "AWS regions have multiple Availability Zones for reliability.",
        "Amazon originally created S3 to solve its own scaling issues.",
        "More than 80% of Fortune 500 companies use AWS.",
        "Cloud helps startups scale globally without huge upfront costs.",
        "Amazon’s first region outside the US was launched in Ireland (2007).",
        "AWS provides free tiers so students can build projects affordably.",
        "AWS CloudFront is one of the largest CDNs in the world.",
        "Serverless means you never patch servers — AWS does it for you!",
        "AWS is the market leader in cloud with ~32% share (as of 2025)."
    ]
    
    fact = random.choice(facts)
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"fact": fact})
    }

```

👉 What this does:  
•	Picks a random fun fact from our list.  
•	Returns it as a JSON response with status code 200 (success).  
•	The event and context arguments let Lambda handle inputs (like API calls) — even if we’re not using them yet.  
  2. Click Deploy to save the changes.
 <img width="975" height="559" alt="image" src="https://github.com/user-attachments/assets/edefdc74-1cbf-4c70-9346-f5bd43739a88" />


### Step 3: Test Lambda
•	Click Test → Create a new test event → Name.  
•	Leave the default JSON ({}) as-is.

<img width="642" height="653" alt="image" src="https://github.com/user-attachments/assets/9f457e54-908f-41ab-b68a-5eaf09222fc7" />


•	Run the test > Save and Click Invoke.
→ You should see a random fun fact returned in the response.
 <img width="975" height="357" alt="image" src="https://github.com/user-attachments/assets/0f809d69-0d44-4c04-bcb3-535385d70033" />

👉 What’s happening here?  
•	You’re manually invoking the Lambda in the console.  
•	AWS runs your code in a temporary environment, then destroys it (that’s the beauty of serverless).  

### Step 4: Create API Gateway
Now we’ll make this Lambda accessible through a public API endpoint.  
•	Go to API Gateway → Click Create API.  
•	Select HTTP API, then Build (simpler and cheaper than REST API).  
•	API Name → ConceptixFunfactsAPI  
•	Integration → Select your Lambda function ConceptixCloudFunFacts > Click Next.  
<img width="975" height="390" alt="image" src="https://github.com/user-attachments/assets/ae66ed61-a242-4b43-9d80-ec67ea6c9695" />

 
•	Add a route:
o	Method: GET
o	Path: /funfact
o	Integration target: Select your Lamba function
 <img width="975" height="197" alt="image" src="https://github.com/user-attachments/assets/28eec47d-30ca-40ad-920d-9d9aad00313d" />

•	Click Next > Create.
 <img width="975" height="453" alt="image" src="https://github.com/user-attachments/assets/e1cd196e-c180-4dfc-8b65-4c0393ef7eae" />

👉 What’s happening here?  
•	API Gateway acts as the front door to your Lambda.  
•	When someone hits /funfact with a GET request, API Gateway forwards it to Lambda, then returns the response.  

### Step 5: Copy Endpoint
•	In your API → go to Stages → Select default.  
•	Copy the Invoke URL (e.g., https://xxxxxx.execute-api.us-east-1.amazonaws.com).
 <img width="975" height="199" alt="image" src="https://github.com/user-attachments/assets/45d3b99a-f6c0-46e0-a800-6326e818abea" />

•	Open your browser/Postman and test:  
<https://xxxxxx.execute-api.us-east-1.amazonaws.com/funfact>  
→ You should see something like:  
```
{
  "fact": "The name 'Amazon Web Services' was first used back in 2002."
}
```
<img width="869" height="150" alt="image" src="https://github.com/user-attachments/assets/cf4c2462-54a9-40ce-b579-63e69fdf1b57" />


### Outcome of Stage 1  
At this point, you’ve built a fully functional serverless API:  
•	A Python Lambda that returns random cloud facts.  
•	An API Gateway endpoint that makes it accessible over the internet.  
This is your foundation. In the next stages, we’ll:  
•	Store facts in DynamoDB instead of hardcoding them.  
•	Make them witty using GenAI models.  
•	Add a frontend with Amplify so users can interact visually.  

________________________________________
## 1.3 Database Version (DynamoDB + Lambda)
In Stage 1, your Lambda returned hardcoded fun facts. That worked, but it’s not scalable you’d have to update the code every time you wanted to add new facts.
In this stage, you’ll store fun facts in a DynamoDB table and fetch them dynamically. This makes your API flexible, scalable, and production-ready.

### Step 1: Create DynamoDB Table  
•	Go to AWS Management Console → Search for DynamoDB.  
•	Click Create table.  
o	Table name: CloudFacts  
o	Partition key: FactID (String)  
 <img width="975" height="458" alt="image" src="https://github.com/user-attachments/assets/4d337128-a100-48d5-bb2c-f3f3194dd519" />

•	Leave other settings default (on-demand capacity is fine for this project).  
•	Click Create.  
👉 What’s happening here?  
•	DynamoDB is AWS’s NoSQL database - super fast, serverless, and fully managed.  
•	We’re creating a table where each fact has:  
o	FactID → unique identifier (like 1, 2, 3)  
o	FactText → the actual fun fact string  

### Step 2: Insert Sample Items
Now, let’s add a few sample fun facts to our database:  
•	Go to your CloudFacts table → Explore table items → Create item.  
•	Add entries like:  
```
{ "FactID": "1", "FactText": "AWS S3 was one of the very first AWS services, launched in 2006." }
{ "FactID": "2", "FactText": "Netflix runs almost all of its infrastructure on AWS." }
{ "FactID": "3", "FactText": " Cloud computing can save companies up to 30% on IT costs." }
{ "FactID": "4", "FactText": "NASA uses AWS to store and share Mars mission data with the public." }
{ "FactID": "5", "FactText": "AWS has more than 200 fully featured services today." }
{ "FactID": "6", "FactText": "The 'cloud' doesn’t float in the sky, it’s made of giant data centers on Earth." }
{ "FactID": "7", "FactText": "More than 90% of Fortune 100 companies use AWS." }
{ "FactID": "8", "FactText": "AWS data centers are so secure that they require retina scans and 24/7 guards." }
{ "FactID": "9", "FactText": "Serverless doesn’t mean there are no servers, it just means you don’t manage them." }
{ "FactID": "10", "FactText": "Each AWS Availability Zone has at least one independent power source and cooling system." }
{ "FactID": "11", "FactText": "Amazon once accidentally took down parts of the internet when S3 had an outage in 2017." }
{ "FactID": "12", "FactText": "The fastest-growing AWS service is Amazon SageMaker, used for Machine Learning." }
{ "FactID": "13", "FactText": "The word 'cloud' became popular in the 1990s as a metaphor for the internet." }
{ "FactID": "14", "FactText": "AWS Lambda can automatically scale from zero to thousands of requests per second." }
{ "FactID": "15", "FactText": "More data is stored in the cloud today than in all personal computers combined." }
 ```
<img width="975" height="271" alt="image" src="https://github.com/user-attachments/assets/e618c98c-c150-4ae6-97fe-5f9b910c27be" />

<img width="975" height="338" alt="image" src="https://github.com/user-attachments/assets/6d6141af-15f4-45ac-bff8-d60a17152de7" />

 
👉 What’s happening here?  
•	We’re populating our database with facts.  
•	Later, instead of editing Lambda code, you can just add more rows here.  

### Step 3: Update Lambda Role
By default, our Lambda cannot talk to DynamoDB. We must grant it permission:    
•	Go to IAM → Roles.   
•	Find the role associated with your CloudFunFacts Lambda.  
•	Attach policy: AmazonDynamoDBReadOnlyAccess.  

👉 Why?  
•	AWS follows least privilege principle. Without explicit permissions, Lambda cannot access other AWS services.  
•	By attaching AmazonDynamoDBReadOnlyAccess, we’re allowing Lambda to read items but not modify/delete them (safer).  
 

### Step 4: Update Lambda Code
•	Replace your Lambda code with this:  
```
import boto3
import random
import json

# Create DynamoDB client
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("ConceptixCloudFacts")

def lambda_handler(event, context):
    # Scan entire table (not efficient for huge tables, but fine here)
    response = table.scan()
    items = response.get("Items", [])

    if not items:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "No facts found"})
        }

    # Pick random fact
    fact = random.choice(items)["FactText"]

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"fact": fact})
    }
```
<img width="975" height="479" alt="image" src="https://github.com/user-attachments/assets/c98a9305-0f61-49c3-8fdf-4e62c5968d82" />

•	Click Deploy to save the code.

👉 What’s happening here?  
•	boto3.resource("dynamodb") → Connects to DynamoDB.  
•	table.scan() → Reads all items from the table.  
•	random.choice(items) → Picks one random fact.  
•	Returns it as JSON response.  

### Step 5: Test the API
•	Go back to API Gateway.  
•	Hit your endpoint:  
<https://xxxxxx.execute-api.us-east-1.amazonaws.com/funfact>  
•	This time, the response should come from DynamoDB. Example:  
```
{
  "fact": "Netflix runs almost all of its infrastructure on AWS."
}
```
<img width="975" height="128" alt="image" src="https://github.com/user-attachments/assets/ffe899ce-6c62-4170-af5d-5946abe0fea0" />


### Outcome of Stage 2
At this point, your API is data-driven:  
•	Fun facts are stored in DynamoDB.  
•	Lambda fetches them dynamically.  
•	You can add new facts without changing code.  
This is exactly how modern apps evolve: starting with hardcoded logic, then moving to database-backed flexibility.  
Next, we will take it a step further: you'll add GenAI integration (Stage 3) so the API can generate witty facts on the fly.  

________________________________________

## 1.4 GenAI Version (Make Facts Witty)
So far, your API returns plain facts. Now let’s take it one step further and make those facts funny and engaging using Amazon Bedrock.
Amazon Bedrock allows you to use foundation models (like Anthropic Claude, AI21, etc.) directly from AWS without managing infrastructure. This means you can enhance your cloud facts dynamically.

### Step 1: Request Model Access in Bedrock
•	Go to the Amazon Bedrock Console in your region.  
•	In the left menu, choose Model catalog.  
•	Find Anthropic Claude  (e.g., Claude 3.5 Sonnet)  
 <img width="975" height="598" alt="image" src="https://github.com/user-attachments/assets/62d3c8d6-aa92-429c-86f7-1b0fdd9797ca" />
  
•	Click on Modify the model access button.  
•	Select the Claude 3.5 Sonnet under Anthropic > Click Next > Submit.  
•	After approval, go back to Model access page, verify if the status has changed from “Access required” → “Access granted”.  
 <img width="975" height="428" alt="image" src="https://github.com/user-attachments/assets/a76196f4-4ddf-49e5-97f4-11525a90755a" />

Note: Requesting access itself is free, but once approved, you’ll pay only for what you use (inference calls and data processed). Costs vary by model (Claude, Titan, etc.), so check the Bedrock pricing page before experimenting. For our course, we’ll stick to the free tier for Amplify + DynamoDB, and only make minimal test calls to Bedrock.
 <img width="975" height="329" alt="image" src="https://github.com/user-attachments/assets/5ec01de9-6b6c-4b27-8e6c-630e058283cb" />


### Step 2: Update IAM Role
•	Go to IAM Console → Roles.  
•	Open the role attached to your Lambda function (CloudFunFactsRole).  
•	Attach the policy: AmazonBedrockFullAccess (this allows your Lambda to call Bedrock models).  
 <img width="975" height="190" alt="image" src="https://github.com/user-attachments/assets/b4da1298-9655-4001-9b4e-d2f55b0007bf" />



### Step 3: Update Lambda Code
•	Replace your DynamoDB Lambda code with this:  
```
import boto3
import random
import json


# DynamoDB connection
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("ConceptixCloudFacts")


# Bedrock client
bedrock = boto3.client("bedrock-runtime")


def lambda_handler(event, context):
    # Fetch all facts from DynamoDB
    response = table.scan()
    items = response.get("Items", [])
    if not items:
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": json.dumps({"fact": "No facts available in DynamoDB."})
        }


    fact = random.choice(items)["FactText"]


    # Messages for Claude 3.5 Sonnet
    messages = [
        {
            "role": "user",
            "content": f"Take this cloud computing fact and make it fun and engaging in 1-2 sentences maximum. Keep it short and witty: {fact}"
        }
    ]


    body = {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 100,
        "messages": messages,
        "temperature": 0.7
    }


    try:
        # Call Claude 3.5 Sonnet on Bedrock
        resp = bedrock.invoke_model(
            modelId="anthropic.claude-3-5-sonnet-20240620-v1:0",
            body=json.dumps(body),
            accept="application/json",
            contentType="application/json"
        )


        # Parse response
        result = json.loads(resp["body"].read())
        witty_fact = ""


        # Claude v3 response: look inside "content"
        if "content" in result and result["content"]:
            for block in result["content"]:
                if block.get("type") == "text":
                    witty_fact = block["text"].strip()
                    break


        # Fallback if empty or too long
        if not witty_fact or len(witty_fact) > 300:
            witty_fact = fact


    except Exception as e:
        print(f"Bedrock error: {e}")
        witty_fact = fact


    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps({"fact": witty_fact})
    }
```

•	Click deploy to save the code.  
•	Increase Lambda Timeout  
•	Go to Configuration → General Configuration → Edit  
•	Set Timeout to 15–30 seconds (or more if your model takes longer to respond)  
•	Save changes  
<img width="975" height="498" alt="image" src="https://github.com/user-attachments/assets/46a19656-555f-4d92-83ff-7d2429ca7d90" />

 

### Step 4: Test the GenAI-Powered Lambda
•	Go to Lambda → Select your function → Test.  
•	Run the function a few times.  
•	Instead of plain facts, you’ll see playful AI-generated versions of the same facts.  
•	Example:  
o	Input fact: “AWS S3 was launched in 2006.”  
o	Output witty fact: “AWS S3 has been around since 2006, older than the first iPhone, and still storing your selfies!”  
 <img width="975" height="186" alt="image" src="https://github.com/user-attachments/assets/e21dea25-cdbc-4968-bc56-a29bde717cad" />



### Step 5: Test the API
•	Go back to API Gateway.  
•	Hit your endpoint:  
<https://xxxxxx.execute-api.us-east-1.amazonaws.com/funfact>  
•	This time, the response should come as a witty fact from Bedrock:  
```
{
  "fact": "More than 90% of Fortune 100 companies use AWS."
}
```
<img width="975" height="97" alt="image" src="https://github.com/user-attachments/assets/521b9f65-4e22-4a33-90cd-038c7587e2f3" />

The Fun Facts API was just turned into a Generative AI-powered service🎉

________________________________________

## 1.5 Add a Frontend with AWS Amplify
In the previous stages, we built a complete serverless API that evolved from hardcoded facts → database-driven → AI-enhanced. Now you'll create a beautiful web frontend so users can interact with your Cloud Fun Facts API through a browser.
This stage completes your full-stack serverless application using AWS Amplify for hosting.

### Step 1: Create the Frontend Code
•	Create a new file called index.html on your local machine.  
•	Add the complete frontend code:  
•	index.html: see index file  

👉 What this code does:  
•	Creates a beautiful, responsive web interface  
•	Calls your API Gateway endpoint when button is clicked  
•	Displays cloud fun facts with loading states and error handling  
•	Works on desktop and mobile devices  

### Step 2: Configure Your API Endpoint
•	Get your API Gateway URL from Stage 2/3:  
o	Go to API Gateway Console  
o	Select your FunfactsAPI  
o	Go to Stages → default  
o	Copy the Invoke URL  
•	Update the API_URL in your code:  
// Replace this line in the HTML file
apiUrl: https://abc123def.execute-api.us-east-1.amazonaws.com/funfact,

👉 Important: Make sure the URL ends with **/funfact** and includes **https://**
<img width="975" height="161" alt="image" src="https://github.com/user-attachments/assets/01b401d8-ce62-4370-a30a-8981679d1c81" />

 
### Step 3: Enable CORS (Cross-Origin Resource Sharing)
Since your frontend will be hosted on a different domain than your API, you need to enable CORS:  
•	Go to API Gateway Console → select your HTTP API.  
•	In the left menu, click CORS.  
•	Configure the CORS settings:  
o	Allowed origins → your Amplify frontend domain (or for testing). Put * if you don’t have it yet and provide it later after getting it from Amplify.  
o	Allowed headers → Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token.  
o	Allowed methods → GET,OPTIONS (add POST,PUT,DELETE if needed later).  
o	Expose headers → leave empty unless your frontend needs specific headers.  
o	Max age → e.g. 3600 (seconds) so the browser caches preflight responses.  
•	Click Save.  
<img width="975" height="322" alt="image" src="https://github.com/user-attachments/assets/e0ac6d1b-7475-45ff-b757-36b311890597" />
<img width="975" height="319" alt="image" src="https://github.com/user-attachments/assets/035742d9-6eeb-43a8-a8f0-e153b5daf4a2" />

 
👉 What's CORS?  
•	CORS allows your web page (hosted on Amplify) to make API calls to your API Gateway  
•	Without CORS, browsers block cross-origin requests for security  

### Step 4: Deploy Frontend to AWS Amplify
AWS Amplify is perfect for hosting static websites with automatic HTTPS and global CDN.
Create Amplify App:  
•	Go to AWS Amplify Console  
•	Click "Host your web app"  
•	Select "Deploy without Git provider"  
 <img width="975" height="254" alt="image" src="https://github.com/user-attachments/assets/4012851b-6a39-4ebc-81c9-4a8c432b8f72" />

•	Configure app:  
o	App name: cloud-fun-facts-generator  
o	Environment name: production  
o	Method: Drag and drop  
Upload Your Code:  
•	Create a ZIP file containing your index.html  
•	Drag the ZIP file to the upload area  
•	Click "Save and deploy"  
 <img width="975" height="291" alt="image" src="https://github.com/user-attachments/assets/ad991c20-e929-43e1-882e-848b182cf83d" />
•	Wait for deployment (usually takes 1-2 minutes)

### Step 5: Test Your Full-Stack Application
•	Get your Amplify URL:After deployment, you'll get a URL like: https://main.d1234abcd.amplifyapp.com  
•	Test the complete flow: Open your Amplify URL in browser  
<img width="975" height="941" alt="image" src="https://github.com/user-attachments/assets/f9f74cf5-d9ed-48fe-9128-a4d5ef3a1184" />

________________________________________

## 1.6 Conclusion and Resource Cleanup

### Conclusion
Congratulations by completing this project, you've built more than just a random fact app. You've engineered a real-world serverless cloud application that demonstrates how to build, scale, and enhance user experiences on AWS, while keeping things fun and interactive!
This setup reflects how modern applications are built today: serverless-first architecture, API-driven communication, database-backed data storage, and Generative AI integration for added engagement.

What You've Built  
•	Deployed an AWS Lambda function to serve random cloud fun facts.  
•	Integrated API Gateway to expose Lambda as a REST API endpoint.  
•	Enhanced functionality by storing facts in a DynamoDB table.  
•	Configured IAM roles and permissions securely for DynamoDB and Bedrock access.  
•	Integrated Amazon Bedrock (GenAI) with Claude AI to rephrase cloud facts in a witty and engaging style.  

This isn't just a fun project, it's a solid foundation for modern serverless applications that combine databases, APIs, and AI.  

### Clean-up Steps
To avoid ongoing AWS charges, remember to delete the resources you created:  
•	Amplify App  
o	Go to AWS Amplify Console  
o	Select your app → Actions → Delete App  
•	API Gateway  
o	Go to API Gateway Console  
o	Select your FunfactsAPI → Actions → Delete  
•	Lambda Function(s)  
o	Go to Lambda Console  
o	Delete functions you created (e.g., CloudFunFacts)  
o	Clean up associated log groups in CloudWatch Logs (/aws/lambda/...)  
•	DynamoDB Table  
o	Go to DynamoDB Console  
o	Select the CloudFacts table → Actions → Delete table  
•	IAM Role (Optional)  
o	Go to IAM > Roles  
o	Delete the custom role created for your Lambda (e.g., CloudFunFacts-role-xyz)  
•	CloudWatch Logs  
o	Go to CloudWatch > Log groups  
o	Delete Lambda function log groups (they start with /aws/lambda/)  



