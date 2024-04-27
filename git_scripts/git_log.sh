if [ -d .gitrepo ]; then
    cat .gitrepo/.git_log
else
    echo "Repository not initialized. Use 'bash submission.sh git_init <remote-repo-path>' to initialize the repository."
fi