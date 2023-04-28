# uNStuck

A Quick way to delete namespaces on Kubernetes, that are stuck in terminating state.  

***Disclaimer: Only use this, if the stuck namespace is completely empty, as otherwise you will have dangling ressources.***  

## How to use 
1. Clone the repo on the host, where you are interacting with your cluster.  
2. cd into the cloned repo and ```sudo chmod +x unstuck-ns.sh``` to make it executable.
3. Run ```./unstuck-ns.sh``` to get rid of the annoying namespace.
4. Rerun, if you have other namespaces stuck.  

## Options
If you need to run the **kubectl** command with sudo rights (e.g. if you have a k3s-cluster) you can simple add the flag 
***--use_sudo*** to the command.  

```./unstuck-ns.sh --use_sudo```  

### Creating Alias
If you need to use this often, you can create an alias like **u-ns**.  
1. Clone repo, ```sudo chmod +x``` the script (if not done already). 
2. Move it ```sudo mv unstuck-ns.sh /usr/local/bin/unstuck-ns.sh ```. 
3. In your .bashrc add:
```
# add custom script for unstucking NS
alias u-ns="/usr/local/bin/unstuck-ns.sh"
```
4. ```source ~/.bashrc``` to reload settings.

### Credits
The script is based on the following snippet
```
NS=`kubectl get ns |grep Terminating | awk 'NR==1 {print $1}'` && kubectl get namespace "$NS" -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/$NS/finalize -f -
```
Found on [StackOverflow](https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-i-removed-it)