oh-my-posh.exe init pwsh --config "C:\Configurations\ps1\gaddo.omp.json" | Invoke-Expression
Import-Module posh-git # more details https://github.com/dahlbyk/posh-git

function git-pc() {
	git rev-parse --abbrev-ref HEAD | git push -u origin
}