# Experiment 02

Remember what we want to do:

- Create a resource group named as you wish
- Within it create a VNet in the CIDR range you wish
- It should have 2 subnets
- And 4 Ubuntu VM inside it running Nginx distributed among those 2 subnets. Ideally they should be in different availability zones
- Add a Load balancer to balance traffic among the 4 instances
- To ensure you can access from your browser you will need to add a network security group to allow port 80 and attach it to the corresponding Load balancer.
- Also add ssh access to all instances both with user/password as well as with a pem file

All of this we need for production, but we still want to keep a version for development as the previous experiment. Think how you can have multiple environments in one configuration

If you have time:

- Add a blob storage and a blob with a custom index.html
- Make each instance able to access such blob (you will deal with permissions)


Try to reuse part of what you had from experiment 1 and go form there!
