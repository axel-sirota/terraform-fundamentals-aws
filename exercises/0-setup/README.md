# Getting Set up for Exercises and Experiments

In this first exercise we'll make sure that we're all set up with our AWS credentials and access to AWS.

## Log into the AWS Console and Create an Access Key for yourself

1. Log in to AWS using the link, username, and password provided to you
2. In the top bar, near the right, you'll see your username/alias @ somenumbers. Clicking on that will display a dropdown
3. In the dropdown, click on "My Security Credentials"
4. This will take you to your security credentials screen/tab. Feel free to change your password if you like, you'll be using this account for the next 3 days.
5. Click "Create access key"
6. An access key and secret will be created for you, **copy the Access key ID and Secret access key (or download a CSV file), we'll use them in setting your environment up below**
7. Close out of the modal/pop-up

## Set up your environment credentials to connect to AWS

1. Run `aws configure`, it will ask for your AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION. Set them as the following:
```
AWS_ACCESS_KEY_ID=[The access key ID you created above]
AWS_SECRET_ACCESS_KEY=[The secret access key you created above]
AWS_DEFAULT_REGION=us-east-2
```

Having done that, we should be ready to move on! To test you can do:

```bash
aws iam get-login-profile --user-name ${your_username}
```

## Test everything

1. Let's test this works. We will go through the steps of terraform (from this directory, you can use the VS Code terminal):

    - `terraform init`
    - `terraform fmt`
    - `terraform validate`
    - `terraform plan -out setup.tfplan`
    - `terraform apply "setup.tfplan"`

2. At the end you should see a bucket named as the output in your account. Congratulations!!

3. As always in this class, let's cleanup:

    - `terraform destroy -auto-approve`
   
