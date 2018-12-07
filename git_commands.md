# Git commands
## Move between commits
First use **git log** to see the commits and hash associated with them.
Save that information to a file so you can move to a **future** commit if you first move to the **past**.
Use **git checkout commit_hash_number** and you will move to a given commit state.
If you want to keep the changes you made you need to create a new branch, then reset your work from the master and then merge the changes with the master, as follows:  
```bash
git commit -m "....."
git branch my-temporary-work
git checkout master
git merge my-temporary-work
```  
Reference: https://stackoverflow.com/questions/10228760/fix-a-git-detached-head  

If you do git reset --hard <SOME-COMMIT> then Git will:  
Make your current branch (typically master ) back to point at <SOME-COMMIT> .  
Then make the files in your working tree and the index ("staging area") the same as the versions committed in <SOME-COMMIT>  


__________________________


See branches:
```bash
git branch
```
change of working branch
```
git checkout your_branch_name

```
