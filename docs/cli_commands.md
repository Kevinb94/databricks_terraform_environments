Check if you have the environment variables setup for authenticating  
printenv | grep -E 'AWS|DATABRICKS' | sort


#  Verify terrform can read your vpc and subnet ids 

cd stacks/dev/
terraform init -reconfigure
terraform refresh
terraform output