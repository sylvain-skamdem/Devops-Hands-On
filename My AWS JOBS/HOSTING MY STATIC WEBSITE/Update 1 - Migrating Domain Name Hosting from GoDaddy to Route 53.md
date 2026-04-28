# Update: Migrating Domain Name Hosting from GoDaddy to Route 53

> **Context:** After the initial static website deployment (documented in the main guide), the domain name hosting was migrated from GoDaddy to Amazon Route 53. This update removes the dependency on GoDaddy's nameservers and centralizes all DNS management within AWS.

---

## Why Migrate from GoDaddy to Route 53?

| Reason | Detail |
|---|---|
| **Unified management** | All DNS records (A, CNAME, NS, SOA) managed in one AWS console alongside S3, CloudFront, ACM, SES |
| **Faster propagation** | Route 53 propagates DNS changes faster than most third-party registrars |
| **SES DKIM support** | Adding DKIM CNAME records for Amazon SES is simpler when Route 53 is the authoritative DNS |
| **Reduced dependency** | No need to log into GoDaddy for any future DNS changes |

---

## What Changes in the Architecture

In the original setup (Step 7 of the main guide), GoDaddy's nameservers were replaced with Route 53 nameservers — but GoDaddy remained the **domain registrar** controlling where DNS queries were directed.

This update transfers **full DNS authority** to Route 53 by moving the domain registration itself, so Route 53 becomes both the registrar and the DNS host.

**Before:**
```
User → GoDaddy (registrar + NS delegation) → Route 53 Hosted Zone → CloudFront → S3
```

**After:**
```
User → Route 53 (registrar + NS + DNS) → CloudFront → S3
```

---

## Prerequisites

- Domain already registered on GoDaddy: *conceptix-art.com*
- Route 53 Hosted Zone already created and working (from Step 5 of the main guide)
- Route 53 A records already pointing to CloudFront (from Steps 6 and 10 of the main guide)
- Domain must be **unlocked** on GoDaddy before transfer can proceed

> **Note:** Route 53 charges **$12/year** for `.com` domain registration. GoDaddy will refund the remaining registration period proportionally upon transfer.

---

## Step 1: Unlock the Domain on GoDaddy

Before initiating the transfer, the domain must be unlocked and a transfer authorization code (EPP code) must be obtained from GoDaddy.

1. Log in to your **GoDaddy** account
2. Go to **Profile name > My Products**
3. Under **Domains**, click on *conceptix-art.com* then click **Manage DNS**
4. Scroll down and click **Domain Settings** or the **Settings** tab
5. Under **Domain lock**, toggle it to **Unlocked**

   ![Alt text](unlock-godaddy-domain.png)

6. Still on the same page, click **Get authorization code** (also called EPP code or transfer code)
7. GoDaddy will send the **authorization code** to your registered email address — save it, you will need it in Step 3

> **Important:** The domain must remain unlocked until the transfer is fully completed. Do not re-lock it during the process.

---

## Step 2: Check Your Route 53 Hosted Zone

Before initiating the transfer, confirm that the Route 53 hosted zone is healthy and all records are correct — these records will be preserved after the transfer.

1. Navigate to the **Route 53** service in the AWS Console
2. Click **Hosted zones** and select *conceptix-art.com*
3. Confirm the following records exist and are correct:

| Record Name | Type | Value |
|---|---|---|
| conceptix-art.com | A (Alias) | CloudFront distribution |
| www.conceptix-art.com | A (Alias) | S3 website endpoint |
| *(ACM CNAME records)* | CNAME | ACM validation values |

4. Copy the **4 NS (Name Server) values** from the hosted zone — you will need them to confirm they match after transfer

   ![Alt text](route53-ns-records.png)

---

## Step 3: Initiate the Domain Transfer in Route 53

1. Navigate to the **Route 53** service
2. In the left sidebar, click **Registered domains**
3. Click **Transfer domain**
4. In the search box, enter your domain name: *conceptix-art.com*
5. Click **Check** — Route 53 will confirm the domain is transferable
6. Click **Add to cart**, then **Proceed to checkout**

   ![Alt text](route53-transfer-domain.png)

7. On the transfer details page, fill in the following:

   a. **Authorization code**: Paste the EPP code received from GoDaddy in Step 1

   b. **Name servers**: Select **Use name servers for the hosted zone for conceptix-art.com** — this automatically uses your existing Route 53 hosted zone NS records

   c. **Auto-renew**: Enable if desired (recommended)

   d. **Privacy protection**: Enable (hides personal registrant info from WHOIS)

8. Fill in your **registrant contact details** (name, address, email, phone)
9. Review the order — cost is **$12.00** for one year `.com` registration
10. Click **Complete order**

---

## Step 4: Approve the Transfer

After submitting the transfer request, two approval actions are required.

1. **AWS confirmation email**: Check the email address associated with your AWS account — AWS sends a transfer confirmation email. Click the **approval link** inside.

2. **GoDaddy approval**: GoDaddy sends a separate email asking you to approve the outgoing transfer. Click **Accept** in that email.

   > If you do not receive the GoDaddy email within 30 minutes, log into GoDaddy and check **Domain > Transfer Out** to approve it manually.

3. Back in Route 53, go to **Registered domains** — the domain status will show **Transfer in progress**

   ![Alt text](route53-transfer-in-progress.png)

> **Timeline:** `.com` domain transfers typically complete within **5–7 days**. ICANN rules require a minimum waiting period. You will receive a confirmation email from AWS when the transfer is complete.

---

## Step 5: Verify Transfer Completion

Once the transfer is complete, AWS sends a confirmation email. Then verify everything is working correctly.

1. Go to **Route 53 > Registered domains** — *conceptix-art.com* should appear with status **Active**

   ![Alt text](route53-domain-active.png)

2. Go to **Route 53 > Hosted zones** — confirm all existing records are intact (A records, CNAME records for ACM, etc.)

3. Open a new **incognito browser window** and navigate to `https://conceptix-art.com` — the website should load normally with the SSL padlock

4. Run a DNS lookup to confirm Route 53 is now the authoritative nameserver:

```bash
nslookup -type=NS conceptix-art.com
```

Expected output should show Route 53 NS records in the format:
```
ns-XXXX.awsdns-XX.com
ns-XXXX.awsdns-XX.net
ns-XXXX.awsdns-XX.org
ns-XXXX.awsdns-XX.co.uk
```

5. Also verify SSL is still valid:

```bash
curl -I https://conceptix-art.com
```

Expected: `HTTP/2 200` with no certificate errors

---

## Step 6: Clean Up GoDaddy

Once the transfer is confirmed complete and the website is verified:

1. Log into **GoDaddy** and confirm the domain no longer appears under **My Products > Domains** (or shows as transferred out)
2. Remove any saved payment methods in GoDaddy if the domain was the only product
3. No DNS changes are needed in GoDaddy — all DNS is now managed exclusively in Route 53

---

## Post-Transfer DNS Management

All future DNS changes (adding records, updating values, removing entries) are now done entirely within **Route 53 > Hosted zones > conceptix-art.com**.

Examples of future changes managed in Route 53:
- Adding SES DKIM CNAME records (done in the contact form integration — see separate guide)
- Adding subdomains (e.g. `mail.conceptix-art.com`, `api.conceptix-art.com`)
- Updating CloudFront or S3 alias targets

---

## Suggested Git Commit Message

```
update: migrate domain hosting from GoDaddy to Route 53

- Unlocked domain and obtained EPP/authorization code from GoDaddy
- Initiated domain transfer via Route 53 > Registered Domains
- Approved transfer from both AWS and GoDaddy confirmation emails
- Transfer completed — Route 53 is now registrar and DNS host
- Verified website, SSL, and all DNS records intact post-transfer
- GoDaddy no longer used for any DNS or domain management

See: Update - Migrating Domain Name Hosting from GoDaddy to Route 53.md
```

---

*Conceptix Innovations LLC — Chicagoland, IL — Technology · Creativity · Excellence*
